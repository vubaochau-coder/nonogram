import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nonogram/checkin/check_in_policy.dart';
import 'package:nonogram/checkin/check_in_service.dart';
import 'package:nonogram/checkin/game_clock.dart';
import 'package:nonogram/core/context_ext.dart';
import 'package:nonogram/data/nonogram_repository.dart';
import 'package:nonogram/models/power_up_inventory.dart';
import 'package:nonogram/premium/premium_controller.dart';
import 'package:nonogram/premium/purchase_gateway.dart';
import 'package:nonogram/rating/app_rating.dart';
import 'package:provider/provider.dart';

import 'tester_purchase_gateway.dart';
import 'tester_settings.dart';

/// Công cụ tester (chỉ bản `dev`): test nhanh những thứ thường phải chờ —
/// điểm danh qua nhiều ngày, mua gói không quảng cáo, hoàn thành màn, quảng
/// cáo xen kẽ, lời mời đánh giá.
///
/// Chuỗi trên màn này không dịch: chỉ dành cho người test nội bộ.
class TesterToolsPage extends StatelessWidget {
  const TesterToolsPage({super.key});

  static T? _maybe<T>(BuildContext context) {
    try {
      return Provider.of<T>(context, listen: false);
    } on ProviderNotFoundException {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final clock = _maybe<GameClock>(context);
    final checkIn = _maybe<CheckInService>(context);
    final premium = _maybe<PremiumController>(context);
    final repository = _maybe<NonogramRepository>(context);
    final rating = _maybe<AppRatingController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Công cụ tester')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          if (clock != null && checkIn != null)
            _CheckInSection(clock: clock, checkIn: checkIn),
          if (premium != null) _PremiumSection(premium: premium),
          const _PlaySection(),
          if (repository != null) _PowerUpSection(repository: repository),
          _AdsRatingSection(rating: rating),
        ],
      ),
    );
  }
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
}

String _date(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/'
    '${d.month.toString().padLeft(2, '0')}/${d.year}';

// --- Ngày & điểm danh ---

class _CheckInSection extends StatelessWidget {
  const _CheckInSection({required this.clock, required this.checkIn});

  final GameClock clock;
  final CheckInService checkIn;

  Future<void> _shift(BuildContext context, int days) async {
    final tester = context.read<TesterSettings>();
    await tester.shiftDays(days);
    // Lùi ngày: gỡ bánh cóc chống chỉnh giờ để điểm danh lại được.
    if (days < 0) await checkIn.debugRewindToToday();
  }

  Future<void> _resetShift(BuildContext context) async {
    final tester = context.read<TesterSettings>();
    final back = tester.dayShiftDays > 0;
    await tester.setDayShift(0);
    if (back) await checkIn.debugRewindToToday();
  }

  /// Điểm danh [days] ngày liền: hôm nay (nếu chưa), rồi tua sang từng ngày
  /// sau và điểm danh tiếp.
  Future<void> _checkInDays(BuildContext context, int days) async {
    final tester = context.read<TesterSettings>();
    var done = 0;
    for (var i = 0; i < days; i++) {
      if (!checkIn.canCheckIn) await tester.shiftDays(1);
      if (await checkIn.checkIn() == null) break;
      done++;
    }
    if (!context.mounted) return;
    _toast(
      context,
      done == days
          ? 'Đã điểm danh $done ngày (tổng ${checkIn.count} lần)'
          : 'Chỉ điểm danh được $done/$days ngày — hãy mở một chế độ chơi',
    );
  }

  Future<void> _reset(BuildContext context) async {
    final ok = await _confirm(
      context,
      title: 'Xoá dữ liệu điểm danh?',
      message:
          'Xoá lịch sử điểm danh, coi như hôm nay mới cài app. Quà đã nhận '
          'vẫn còn trong kho.',
    );
    if (ok != true) return;
    await checkIn.debugReset();
    if (context.mounted) _toast(context, 'Đã xoá dữ liệu điểm danh');
  }

  @override
  Widget build(BuildContext context) {
    final tester = context.watch<TesterSettings>();
    return ListenableBuilder(
      listenable: Listenable.merge([clock, checkIn]),
      builder: (context, _) {
        final shift = tester.dayShiftDays;
        final toNext = CheckInPolicy.checkInsToNextMilestone(checkIn.count);
        return _Section(
          title: 'Ngày & điểm danh',
          children: [
            _Info(
              'Ngày của game',
              '${_date(clock.now())}'
                  '${shift == 0 ? '' : '  (tua ${shift > 0 ? '+' : ''}$shift ngày)'}',
            ),
            _Info('Đã điểm danh', '${checkIn.count} lần'),
            _Info(
              'Hôm nay',
              checkIn.checkedInToday
                  ? 'đã điểm danh'
                  : checkIn.canCheckIn
                  ? 'chưa điểm danh'
                  : 'bị chặn (đã lùi giờ)',
            ),
            _Info('Quà mốc tiếp theo', 'sau $toNext lần nữa'),
            _Info('Gói không quảng cáo', checkIn.isPremium ? 'có' : 'không'),
            const SizedBox(height: 8),
            _Buttons([
              _Btn('-1 ngày', () => _shift(context, -1)),
              _Btn('+1 ngày', () => _shift(context, 1), primary: true),
              _Btn('+7 ngày', () => _shift(context, 7)),
              _Btn(
                'Về hôm nay',
                shift == 0 ? null : () => _resetShift(context),
              ),
            ]),
            _Buttons([
              _Btn('Điểm danh 1 ngày', () => _checkInDays(context, 1)),
              _Btn(
                'Điểm danh $toNext ngày (tới quà mốc)',
                () => _checkInDays(context, toNext),
              ),
            ]),
            _Buttons([
              _Btn(
                'Xoá dữ liệu điểm danh',
                () => _reset(context),
                danger: true,
              ),
            ]),
            const _Note(
              'Tua giờ chỉ đổi giờ của game (điểm danh, hạn của lượt trong '
              'ngày), không đổi giờ điện thoại. Lùi ngày sẽ tự gỡ chặn chống '
              'chỉnh giờ và bỏ các lần điểm danh "trong tương lai".',
            ),
          ],
        );
      },
    );
  }
}

// --- Gói không quảng cáo ---

class _PremiumSection extends StatelessWidget {
  const _PremiumSection({required this.premium});

  final PremiumController premium;

  TesterPurchaseGateway? get _gateway {
    final g = premium.gateway;
    return g is TesterPurchaseGateway ? g : null;
  }

  Future<void> _setStore(BuildContext context, TesterStore store) async {
    await context.read<TesterSettings>().setStore(store);
    await premium.refresh();
  }

  Future<void> _setFakeOwned(BuildContext context, bool owned) async {
    await context.read<TesterSettings>().setFakeOwned(owned);
    await premium.refresh();
    if (context.mounted) {
      _toast(
        context,
        owned ? 'Đã kích hoạt gói' : 'Đã thu hồi gói (hoàn tiền)',
      );
    }
  }

  Future<void> _buy(BuildContext context) async {
    final outcome = await premium.buy();
    if (context.mounted) _toast(context, 'Kết quả mua: ${_outcome(outcome)}');
  }

  Future<void> _completePending(BuildContext context) async {
    final ok = await _gateway?.completePending() ?? false;
    if (context.mounted) {
      _toast(
        context,
        ok ? 'Giao dịch chờ đã thanh toán xong' : 'Không có giao dịch chờ',
      );
    }
  }

  static String _outcome(PurchaseOutcome o) => switch (o) {
    PurchaseOutcome.purchased => 'mua thành công',
    PurchaseOutcome.pending => 'chờ thanh toán',
    PurchaseOutcome.cancelled => 'người dùng huỷ',
    PurchaseOutcome.failed => 'lỗi',
    PurchaseOutcome.unavailable => 'cửa hàng không dùng được',
  };

  @override
  Widget build(BuildContext context) {
    final tester = context.watch<TesterSettings>();
    final gateway = _gateway;
    final fake = tester.store == TesterStore.fake;
    return ListenableBuilder(
      listenable: premium,
      builder: (context, _) {
        return _Section(
          title: 'Gói không quảng cáo',
          children: [
            _Info('Trạng thái', premium.isPremium ? 'ĐÃ MUA' : 'chưa mua'),
            _Info(
              'Cửa hàng',
              premium.canPurchase
                  ? 'dùng được · ${premium.price}'
                  : 'không dùng được',
            ),
            const SizedBox(height: 8),
            SegmentedButton<TesterStore>(
              segments: const [
                ButtonSegment(
                  value: TesterStore.fake,
                  label: Text('Cửa hàng giả'),
                ),
                ButtonSegment(
                  value: TesterStore.real,
                  label: Text('Google Play'),
                ),
              ],
              selected: {tester.store},
              onSelectionChanged: (s) => _setStore(context, s.first),
            ),
            if (fake) ...[
              const SizedBox(height: 12),
              Text('Khi bấm mua thì:', style: context.labelLarge),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final o in const [
                    PurchaseOutcome.purchased,
                    PurchaseOutcome.pending,
                    PurchaseOutcome.cancelled,
                    PurchaseOutcome.failed,
                  ])
                    ChoiceChip(
                      label: Text(_outcome(o)),
                      selected: tester.fakeBuyOutcome == o,
                      onSelected: (_) => tester.setFakeBuyOutcome(o),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _Buttons([
                _Btn(
                  'Bấm mua',
                  premium.isPremium || premium.isBusy
                      ? null
                      : () => _buy(context),
                  primary: true,
                ),
                _Btn(
                  'Hoàn tất giao dịch chờ',
                  gateway?.pendingProduct == null
                      ? null
                      : () => _completePending(context),
                ),
              ]),
              _Buttons([
                _Btn(
                  'Coi như đã mua',
                  premium.isPremium ? null : () => _setFakeOwned(context, true),
                ),
                _Btn(
                  'Hoàn tiền / thu hồi',
                  premium.isPremium
                      ? () => _setFakeOwned(context, false)
                      : null,
                  danger: true,
                ),
              ]),
            ],
            _Note(
              fake
                  ? 'Cửa hàng giả không tốn tiền. Có thể mua ở đây hoặc ở thẻ '
                      'gói trong tab Tôi. "Hoàn tiền / thu hồi" giống lúc '
                      'Google Play báo đã hoàn tiền khi mở app.'
                  : 'Google Play thật: cần cài app từ kênh thử nghiệm và đăng '
                      'nhập tài khoản có trong "Thử nghiệm giấy phép" của Play '
                      'Console. Huỷ đơn thử ở Play Console → Quản lý đơn hàng.',
            ),
          ],
        );
      },
    );
  }
}

// --- Màn chơi ---

class _PlaySection extends StatelessWidget {
  const _PlaySection();

  @override
  Widget build(BuildContext context) {
    final tester = context.watch<TesterSettings>();
    return _Section(
      title: 'Màn chơi',
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Nút ⚡ "Giải ngay" trong màn chơi'),
          subtitle: const Text(
            'Trên thanh tiêu đề (màn ngang: cột trái). Bấm là tô đúng đáp án '
            'và hoàn thành màn như khi tự giải.',
          ),
          value: tester.showSolveButton,
          onChanged: tester.setShowSolveButton,
        ),
      ],
    );
  }
}

// --- Kho gợi ý / gậy phép ---

class _PowerUpSection extends StatefulWidget {
  const _PowerUpSection({required this.repository});

  final NonogramRepository repository;

  @override
  State<_PowerUpSection> createState() => _PowerUpSectionState();
}

class _PowerUpSectionState extends State<_PowerUpSection> {
  PowerUpInventory? _inventory;
  StreamSubscription<PowerUpInventory>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.repository.powerUpChanges.listen(
      (i) => setState(() => _inventory = i),
    );
    _reload();
  }

  Future<void> _reload() async {
    final i = await widget.repository.getPowerUps();
    if (mounted) setState(() => _inventory = i);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _save(PowerUpInventory Function(PowerUpInventory) change) async {
    final current = await widget.repository.getPowerUps();
    await widget.repository.savePowerUps(change(current));
  }

  @override
  Widget build(BuildContext context) {
    final i = _inventory;
    // Đổi ngày (tua giờ) làm lượt trong ngày hết hạn.
    context.watch<TesterSettings>();
    return _Section(
      title: 'Kho gợi ý / gậy phép',
      children: [
        if (i != null) ...[
          _Info('Gợi ý', '${i.hints} vĩnh viễn + ${i.dailyHints} trong ngày'),
          _Info(
            'Gậy phép',
            '${i.wands} vĩnh viễn + ${i.dailyWands} trong ngày',
          ),
        ],
        const SizedBox(height: 8),
        _Buttons([
          _Btn(
            '+10 gợi ý',
            () => _save((i) => i.addPermanent(PowerUp.hint, 10)),
          ),
          _Btn(
            '+10 gậy phép',
            () => _save((i) => i.addPermanent(PowerUp.wand, 10)),
          ),
          _Btn(
            'Về 0 (test quảng cáo có thưởng)',
            () => _save((_) => const PowerUpInventory(hints: 0, wands: 0)),
            danger: true,
          ),
        ]),
      ],
    );
  }
}

// --- Quảng cáo & đánh giá ---

class _AdsRatingSection extends StatelessWidget {
  const _AdsRatingSection({required this.rating});

  final AppRatingController? rating;

  @override
  Widget build(BuildContext context) {
    final tester = context.watch<TesterSettings>();
    final rating = this.rating;
    return _Section(
      title: 'Quảng cáo & đánh giá',
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Bỏ giãn cách quảng cáo xen kẽ'),
          subtitle: const Text(
            'Rời màn hoàn thành nào cũng hiện quảng cáo xen kẽ (thay vì 5 '
            'phút một lần). Đã mua gói thì vẫn không hiện.',
          ),
          value: tester.adsNoInterval,
          onChanged: tester.setAdsNoInterval,
        ),
        if (rating != null)
          StatefulBuilder(
            builder:
                (context, setState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Info(
                      'Lời mời đánh giá',
                      rating.state.answered
                          ? 'đã trả lời'
                          : 'đã hỏi ${rating.state.prompts} lần',
                    ),
                    _Buttons([
                      _Btn('Đặt lại lời mời đánh giá', () async {
                        await rating.debugReset();
                        setState(() {});
                        if (context.mounted) {
                          _toast(
                            context,
                            'Đã đặt lại: hỏi khi rời màn hoàn thành, từ màn đã giải '
                            'thứ ${rating.policy.firstAfter}',
                          );
                        }
                      }),
                    ]),
                  ],
                ),
          ),
      ],
    );
  }
}

// --- Khung ---

Future<bool?> _confirm(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Xoá'),
            ),
          ],
        ),
  );
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: context.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.bodyMedium.copyWith(
                color: context.color.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.bodyMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: context.bodySmall.copyWith(
          color: context.color.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _Btn {
  const _Btn(
    this.label,
    this.onPressed, {
    this.primary = false,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final bool danger;
}

class _Buttons extends StatelessWidget {
  const _Buttons(this.buttons);

  final List<_Btn> buttons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final b in buttons)
            b.primary
                ? FilledButton(onPressed: b.onPressed, child: Text(b.label))
                : OutlinedButton(
                  onPressed: b.onPressed,
                  style:
                      b.danger
                          ? OutlinedButton.styleFrom(
                            foregroundColor: context.color.error,
                          )
                          : null,
                  child: Text(b.label),
                ),
        ],
      ),
    );
  }
}
