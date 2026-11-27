part of 'check_in_screen.dart';

/// Check-in and make-up flow of [CheckInScreen]: records the day, then plays
/// the stamp, streak bar and gift animations while holding the old state on
/// screen.
mixin _CheckInFlow on State<CheckInScreen>, TickerProvider {
  late DateTime _month;
  bool _busy = false;
  final _buttonKey = GlobalKey(debugLabel: 'check-in-button');
  final _stampKey = GlobalKey(debugLabel: 'check-in-stamp');
  final _streakKey = GlobalKey(debugLabel: 'check-in-streak');
  final _nodeKeys = {
    for (final m in CheckInPolicy.streakMilestones)
      m: GlobalKey(debugLabel: 'check-in-milestone-$m'),
  };

  /// Ô nhận [_stampKey] (ô sắp được đóng dấu); mặc định hôm nay.
  int? _stampDay;

  /// Đang chạy hiệu ứng: ô này vẽ như chưa điểm danh, thẻ chuỗi hiện số cũ.
  int? _holdDay;
  StreakStats? _heldStats;

  /// Thanh chuỗi đang chạy (null: theo chuỗi dài nhất thật).
  double? _barOverride;

  /// Các mốc đã nhận đang hiện (null: theo service). Quà vừa đạt chưa bấm
  /// "Nhận" thì chưa có trong này.
  Set<int>? _claimedOverride;

  /// Quà vừa đạt, đang chờ mở.
  Set<int> _pendingGifts = const {};

  /// Hiệu ứng đã vẽ bản sao của nút trên lớp phủ: ẩn nút thật.
  bool _hideButton = false;
  CheckInCelebration? _celebration;
  late final AnimationController _bar = AnimationController.unbounded(
    vsync: this,
  );

  static DateTime _monthOf(int day) {
    final date = dateOfDayNumber(day);
    return DateTime(date.year, date.month);
  }

  static Rect? _rectOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> _checkIn(CheckInService service) =>
      _record(service, service.today, service.checkIn, withButton: true);

  Future<void> _makeUp(CheckInService service, int day) async {
    if (_busy || !service.canMakeUp(day)) return;
    final l10n = context.l10n;
    final date = MaterialLocalizations.of(
      context,
    ).formatShortMonthDay(dateOfDayNumber(day));
    final ads = context.ads;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => CheckInMakeUpSheet(date: date),
    );
    if (confirmed != true || !mounted) return;
    if (ads.isEnabled) {
      if (!ads.isReady(AdPlacement.checkInMakeUp)) {
        ToastUtils.warning(title: l10n.adRewardNotReady);
        return;
      }
      setState(() => _busy = true);
      final rewarded = await ads.showRewarded(AdPlacement.checkInMakeUp);
      if (!mounted) return;
      setState(() => _busy = false);
      if (!rewarded) return;
    }
    await _record(service, day, () => service.makeUp(day), withButton: false);
  }

  /// Điểm danh / bù [day] rồi chạy hiệu ứng.
  Future<void> _record(
    CheckInService service,
    int day,
    Future<CheckInOutcome?> Function() action, {
    required bool withButton,
  }) async {
    if (_busy) return;
    final month = _monthOf(day);
    final before = service.streak(month.year, month.month);
    setState(() {
      _busy = true;
      _month = month;
      _stampDay = day;
    });
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final button = withButton ? _rectOf(_buttonKey) : null;
    final cell = _rectOf(_stampKey);
    final animate =
        !MediaQuery.disableAnimationsOf(context) &&
        cell != null &&
        (!withButton || button != null);

    // Giữ ô, thanh và mốc như cũ trước khi service báo đổi.
    setState(() {
      _holdDay = animate ? day : null;
      _heldStats = animate ? before : null;
      _barOverride = animate ? before.longest.toDouble() : null;
      _claimedOverride = animate
          ? {...service.claimedMilestones(month.year, month.month)}
          : null;
    });
    final outcome = await action();
    if (!mounted) return;
    if (outcome == null) {
      _reset();
      return;
    }

    if (animate) {
      await _celebrate(service, outcome, button: button, cell: cell);
    }
    if (!mounted) return;
    _reset();
    _toast(outcome, animated: animate);
  }

  Future<void> _celebrate(
    CheckInService service,
    CheckInOutcome outcome, {
    required Rect? button,
    required Rect cell,
  }) async {
    final sounds = AppSoundController.maybeOf(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    final ads = context.ads;
    final l10n = context.l10n;

    // 1. Đóng dấu ô ngày.
    setState(() => _hideButton = button != null);
    final stamp = _celebration = CheckInCelebration(
      vsync: this,
      overlay: overlay,
      button: button,
      buttonChild: button == null ? null : _buttonFor(service),
      today: cell,
      sounds: sounds,
      onLand: () {
        if (mounted) setState(() => _holdDay = null);
      },
    );
    await stamp.run();
    stamp.dispose();
    _celebration = null;
    if (!mounted) return;
    setState(() {
      _hideButton = false;
      _holdDay = null;
      _heldStats = null;
      _pendingGifts = {for (final g in outcome.gifts) g.milestone};
    });

    // 2. Thanh chuỗi chạy tới chuỗi dài nhất mới.
    if (outcome.longestAfter > outcome.longestBefore) {
      final from = outcome.longestBefore.toDouble();
      final to = math.min(outcome.longestAfter, 28).toDouble();
      _bar.value = from;
      final ms = math.max(450, ((to - from) * 60).round());
      await _bar.animateTo(
        to,
        duration: Duration(milliseconds: ms),
        curve: Curves.easeOutCubic,
      );
      if (!mounted) return;
    }

    // 3. Mở lần lượt quà các mốc vừa đạt.
    for (final gift in outcome.gifts) {
      final node = _rectOf(_nodeKeys[gift.milestone]!);
      if (node == null) continue;
      final open = _celebration = CheckInCelebration(
        vsync: this,
        overlay: overlay,
        gift: gift.reward,
        giftMilestone: gift.milestone,
        badge: node,
        giftTarget: node.center,
        sounds: sounds,
        // Không có quảng cáo (web, iOS): không có nút "Nhận x2".
        onDouble: ads.isEnabled
            ? () async {
                if (!ads.isReady(AdPlacement.checkInDoubleGift)) {
                  ToastUtils.warning(title: l10n.adRewardNotReady);
                  return false;
                }
                if (!await ads.showRewarded(AdPlacement.checkInDoubleGift)) {
                  return false;
                }
                return service.doubleGift(
                  day: outcome.day,
                  milestone: gift.milestone,
                );
              }
            : null,
        onCollected: () {
          if (!mounted) return;
          setState(() {
            _claimedOverride = {...?_claimedOverride, gift.milestone};
            _pendingGifts = {..._pendingGifts}..remove(gift.milestone);
          });
        },
      );
      await open.run();
      open.dispose();
      _celebration = null;
      if (!mounted) return;
    }
  }

  void _reset() {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _hideButton = false;
      _holdDay = null;
      _heldStats = null;
      _barOverride = null;
      _claimedOverride = null;
      _pendingGifts = const {};
      _stampDay = null;
    });
  }

  /// A copy of the check-in button, drawn on the celebration overlay.
  CheckInButton _buttonFor(CheckInService service);

  void _toast(CheckInOutcome outcome, {required bool animated});
}
