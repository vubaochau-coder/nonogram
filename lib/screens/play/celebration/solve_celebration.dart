import 'dart:math';
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/widgets/nonogram_pixel_art.dart';

/// Các bước của hiệu ứng giải xong một màn.
enum SolveCelebrationPhase {
  /// Không có hiệu ứng (đang chơi, hoặc mở một màn đã giải sẵn).
  idle,

  /// Sóng lan trên bàn chơi từ góc trái dưới lên góc phải trên: từng ô tô
  /// nổi lên rồi hạ xuống.
  wave,

  /// Đã sang màn kết quả: khung chạy quanh tranh, tranh vừa thu nhỏ vừa bay
  /// vào thẻ kết quả.
  flight,

  /// Tranh đã nằm yên trong thẻ kết quả.
  done,
}

/// Điều phối hiệu ứng giải xong: sóng nổi ô trên lưới, rồi khung chạy quanh
/// tranh trong lúc tranh thu nhỏ và bay vào thẻ tranh của màn kết quả (kiểu
/// hero animation trong cùng một trang).
///
/// Chỉ báo thay đổi khi đổi bước; từng khung hình đi qua các [Animation]
/// để chỉ những lớp hiệu ứng vẽ lại.
class SolveCelebration extends ChangeNotifier {
  SolveCelebration({required TickerProvider vsync})
    : _wave = AnimationController(
        vsync: vsync,
        duration: waveDuration + _waveHold,
      ),
      _flight = AnimationController(vsync: vsync, duration: flightDuration);

  /// Thời gian sóng đi hết lưới.
  static const waveDuration = Duration(milliseconds: 1300);

  /// Nghỉ một nhịp sau sóng để người chơi kịp nhìn hình hoàn chỉnh.
  static const _waveHold = Duration(milliseconds: 250);

  /// Cả bước bay: tranh tới nơi sau khoảng 0,9 giây ([_landAt]), phần còn
  /// lại để nội dung màn kết quả hiện nốt.
  static const flightDuration = Duration(milliseconds: 1100);
  static const _landAt = 0.82;

  final AnimationController _wave;
  final AnimationController _flight;

  /// Gắn vào vùng lưới trên bàn chơi (điểm xuất phát).
  final GlobalKey gridKey = GlobalKey(debugLabel: 'solve-grid');

  /// Gắn vào tranh trên màn kết quả (chỗ tranh đáp xuống).
  final GlobalKey pictureKey = GlobalKey(debugLabel: 'solve-picture');

  /// Gắn vào thẻ tranh trên màn kết quả (khung chạy tới đây).
  final GlobalKey cardKey = GlobalKey(debugLabel: 'solve-card');

  /// Gắn vào bàn chơi, để bàn chơi (còn mờ dần lúc tranh bay) giữ nguyên
  /// trạng thái khi được đặt dưới màn kết quả.
  final GlobalKey boardKey = GlobalKey(debugLabel: 'solve-board');

  /// Phát tiếng theo từng bước (sóng, tranh bay, tranh đáp).
  void Function(GameSound sound)? onSound;

  SolveCelebrationPhase _phase = SolveCelebrationPhase.idle;
  SolveCelebrationPhase get phase => _phase;

  List<List<int>> _solution = const [];
  List<List<int>> get solution => _solution;

  /// Tiến độ sóng, 0..1 trên cả [waveDuration] (phần nghỉ phía sau giữ ở 1).
  late final Animation<double> wave = _wave.drive(
    CurveTween(
      curve: Interval(
        0,
        waveDuration.inMilliseconds / (waveDuration + _waveHold).inMilliseconds,
      ),
    ),
  );

  /// Tranh di chuyển + thu nhỏ.
  late final Animation<double> move = _flight.drive(
    CurveTween(curve: const Interval(0, _landAt, curve: Curves.easeInOutCubic)),
  );

  /// Khung chạy vòng quanh tranh.
  late final Animation<double> trace = _flight.drive(
    CurveTween(curve: const Interval(0, 0.55, curve: Curves.easeInOutCubic)),
  );

  /// Khung dịu màu dần về viền của thẻ kết quả trước khi đáp.
  late final Animation<double> settle = _flight.drive(
    CurveTween(curve: const Interval(0.55, _landAt)),
  );

  /// Nền thẻ kết quả hiện ra sau khi khung chạy xong.
  late final Animation<double> cardFill = _flight.drive(
    CurveTween(curve: const Interval(0.55, _landAt, curve: Curves.easeOut)),
  );

  /// Phần còn lại của màn kết quả (huy hiệu, tên màn, nút) hiện dần.
  late final Animation<double> reveal = _flight.drive(
    CurveTween(curve: const Interval(0.55, 1, curve: Curves.easeOutCubic)),
  );

  /// Bàn chơi (số gợi ý, thanh công cụ) mờ dần lúc tranh bắt đầu bay.
  late final Animation<double> boardOpacity = _flight.drive(
    Tween<double>(
      begin: 1,
      end: 0,
    ).chain(CurveTween(curve: const Interval(0, 0.27, curve: Curves.easeOut))),
  );

  /// Đường bay (toạ độ toàn màn hình).
  Rect? _from;
  Rect? _pictureTo;
  Rect? _cardTo;
  Rect? get flightFrom => _from;
  Rect? get pictureTo => _pictureTo;
  Rect? get cardTo => _cardTo;

  /// Đang sóng: trang chơi vẫn giữ bàn chơi thay vì sang màn kết quả.
  bool get holdsBoard => _phase == SolveCelebrationPhase.wave;

  /// Đang bay: tranh thật trên màn kết quả bị che, chờ bản bay tới.
  bool get isFlying => _phase == SolveCelebrationPhase.flight;

  /// Màn kết quả này đến từ hiệu ứng.
  bool get isActive => _phase != SolveCelebrationPhase.idle;

  bool _disposed = false;

  void _setPhase(SolveCelebrationPhase value) {
    if (_disposed || _phase == value) return;
    _phase = value;
    notifyListeners();
  }

  /// Bắt đầu hiệu ứng cho màn vừa giải xong.
  Future<void> start(List<List<int>> solution) async {
    if (_phase != SolveCelebrationPhase.idle) return;
    _solution = solution;
    _flight.value = 0;
    _setPhase(SolveCelebrationPhase.wave);
    HapticFeedback.mediumImpact();
    onSound?.call(GameSound.wave);
    try {
      await _wave.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    }
    if (_disposed || _phase != SolveCelebrationPhase.wave) return;

    _from = _globalRect(gridKey);
    _setPhase(SolveCelebrationPhase.flight);
    // Chờ màn kết quả dựng xong để đo thẻ tranh.
    WidgetsBinding.instance.addPostFrameCallback((_) => _fly());
  }

  Future<void> _fly() async {
    if (_disposed || _phase != SolveCelebrationPhase.flight) return;
    _pictureTo = _globalRect(pictureKey);
    _cardTo = _globalRect(cardKey);
    if (_from == null || _pictureTo == null || _cardTo == null) {
      _flight.value = 1;
      onSound?.call(GameSound.fanfare);
      _land();
      return;
    }
    notifyListeners();
    onSound?.call(GameSound.whoosh);
    var landed = false;
    void onTick() {
      if (landed || _flight.value < _landAt) return;
      landed = true;
      HapticFeedback.lightImpact();
      onSound?.call(GameSound.fanfare);
    }

    _flight.addListener(onTick);
    try {
      await _flight.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    } finally {
      _flight.removeListener(onTick);
    }
    _land();
  }

  void _land() {
    if (_disposed || _phase != SolveCelebrationPhase.flight) return;
    _from = _pictureTo = _cardTo = null;
    _setPhase(SolveCelebrationPhase.done);
  }

  /// Về trạng thái ban đầu (sang màn mới, hoặc chơi lại).
  void reset() {
    _wave.stop();
    _flight.stop();
    _wave.value = 0;
    _flight.value = 0;
    _from = _pictureTo = _cardTo = null;
    _setPhase(SolveCelebrationPhase.idle);
  }

  static Rect? _globalRect(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  static SolveCelebration? maybeOf(BuildContext context, {bool listen = true}) {
    try {
      return Provider.of<SolveCelebration>(context, listen: listen);
    } on ProviderNotFoundException {
      return null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _wave.dispose();
    _flight.dispose();
    super.dispose();
  }
}

/// Cấp [SolveCelebration] cho trang chơi và vẽ tranh đang bay lên trên cùng.
class SolveCelebrationScope extends StatefulWidget {
  const SolveCelebrationScope({super.key, required this.child});

  final Widget child;

  @override
  State<SolveCelebrationScope> createState() => _SolveCelebrationScopeState();
}

class _SolveCelebrationScopeState extends State<SolveCelebrationScope>
    with TickerProviderStateMixin {
  late final SolveCelebration _celebration = SolveCelebration(vsync: this);

  @override
  void dispose() {
    _celebration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _celebration.onSound = AppSoundController.maybeOf(context)?.play;
    return ChangeNotifierProvider.value(
      value: _celebration,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(child: _FlyingPicture(celebration: _celebration)),
        ],
      ),
    );
  }
}

/// Viền thẻ tranh trên màn kết quả; khung chạy dịu dần về màu này.
Color solveCardBorderColor(BuildContext context) =>
    Theme.of(context).colorScheme.primary.withValues(alpha: 0.35);

/// Bo góc thẻ tranh trên màn kết quả (khung chạy bo dần tới đây).
const solveCardRadius = 24.0;

class _FlyingPicture extends StatelessWidget {
  const _FlyingPicture({required this.celebration});

  final SolveCelebration celebration;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ListenableBuilder(
        listenable: celebration,
        builder: (context, _) {
          final from = celebration.flightFrom;
          if (!celebration.isFlying || from == null) {
            return const SizedBox.shrink();
          }
          // Đổi toạ độ toàn màn hình sang toạ độ của lớp phủ này.
          final box = context.findRenderObject();
          final origin =
              box is RenderBox && box.hasSize
                  ? box.localToGlobal(Offset.zero)
                  : Offset.zero;
          final src = from.shift(-origin);
          // Khung hình đầu của màn kết quả chưa đo được thẻ tranh: giữ tranh
          // đúng chỗ lưới để không bị nháy trống.
          final pictureDst = celebration.pictureTo?.shift(-origin) ?? src;
          final cardDst = celebration.cardTo?.shift(-origin);
          final colors = Theme.of(context).colorScheme;
          final picture = NonogramBoardPicture(solution: celebration.solution);

          return AnimatedBuilder(
            animation: celebration.move,
            child: picture,
            builder: (context, child) {
              final t = celebration.move.value;
              final rect = Rect.lerp(src, pictureDst, t)!;
              return Stack(
                children: [
                  Positioned.fromRect(rect: rect, child: child!),
                  if (cardDst != null)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: SolveFramePainter(
                          from: src.inflate(5),
                          fromRadius: 6,
                          to: cardDst,
                          toRadius: solveCardRadius,
                          move: t,
                          trace: celebration.trace.value,
                          settle: celebration.settle.value,
                          color: colors.primary,
                          settledColor: solveCardBorderColor(context),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Khung chạy vòng quanh tranh theo chiều kim đồng hồ (bắt đầu ở góc trên
/// trái, có chấm sáng ở đầu), đồng thời giãn dần thành viền thẻ kết quả.
class SolveFramePainter extends CustomPainter {
  SolveFramePainter({
    required this.from,
    required this.fromRadius,
    required this.to,
    required this.toRadius,
    required this.move,
    required this.trace,
    required this.settle,
    required this.color,
    required this.settledColor,
  });

  final Rect from;
  final double fromRadius;
  final Rect to;
  final double toRadius;
  final double move;
  final double trace;
  final double settle;
  final Color color;
  final Color settledColor;

  /// Viền bo góc, bắt đầu ở mép trên ngay sau góc trên trái, chạy theo chiều
  /// kim đồng hồ.
  static Path outline(Rect r, double radius) {
    final rad = min(radius, min(r.width, r.height) / 2);
    final c = Radius.circular(rad);
    return Path()
      ..moveTo(r.left + rad, r.top)
      ..lineTo(r.right - rad, r.top)
      ..arcToPoint(Offset(r.right, r.top + rad), radius: c)
      ..lineTo(r.right, r.bottom - rad)
      ..arcToPoint(Offset(r.right - rad, r.bottom), radius: c)
      ..lineTo(r.left + rad, r.bottom)
      ..arcToPoint(Offset(r.left, r.bottom - rad), radius: c)
      ..lineTo(r.left, r.top + rad)
      ..arcToPoint(Offset(r.left + rad, r.top), radius: c);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (trace <= 0) return;
    final rect = Rect.lerp(from, to, move)!;
    final radius = fromRadius + (toRadius - fromRadius) * move;
    final PathMetric metric = outline(rect, radius).computeMetrics().first;
    final length = metric.length * trace.clamp(0.0, 1.0);
    final stroke =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 - settle
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = Color.lerp(color, settledColor, settle)!;
    canvas.drawPath(metric.extractPath(0, length), stroke);

    if (trace < 1) {
      final head = metric.getTangentForOffset(length)?.position;
      if (head != null) {
        final dot = Paint()..color = color;
        canvas.drawCircle(head, 9, dot..color = color.withValues(alpha: 0.16));
        canvas.drawCircle(head, 5, dot..color = color.withValues(alpha: 0.45));
        canvas.drawCircle(head, 3, dot..color = color);
      }
    }
  }

  @override
  bool shouldRepaint(SolveFramePainter old) =>
      old.from != from ||
      old.to != to ||
      old.move != move ||
      old.trace != trace ||
      old.settle != settle ||
      old.color != color ||
      old.settledColor != settledColor ||
      old.fromRadius != fromRadius ||
      old.toRadius != toRadius;
}

/// Lớp sóng vẽ đè lên lưới khi vừa giải xong: mỗi ô tô nổi lên (to ra, nhấc
/// lên, đổ bóng) rồi hạ về chỗ cũ khi sóng đi qua; dấu X mờ dần để lộ hình.
class SolveWavePainter extends CustomPainter {
  SolveWavePainter({
    required this.progress,
    required this.solution,
    required this.cellSize,
    required this.filledColor,
    required this.backgroundColor,
    this.shadowColor = Colors.black,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final List<List<int>> solution;
  final double cellSize;
  final Color filledColor;
  final Color backgroundColor;
  final Color shadowColor;

  /// Phần thời gian mỗi ô nổi lên; phần còn lại là độ trễ theo vị trí.
  static const _cellSpan = 0.22;

  /// Ô nổi cao nhất to thêm chừng này.
  static const _maxScale = 0.16;

  /// Tiến độ riêng của ô (0..1): ô góc trái dưới bắt đầu trước, góc phải
  /// trên bắt đầu sau cùng.
  static double cellProgress({
    required double t,
    required int row,
    required int col,
    required int rows,
    required int cols,
  }) {
    final steps = max(1, rows + cols - 2);
    final delay = (col + (rows - 1 - row)) / steps * (1 - _cellSpan);
    return ((t - delay) / _cellSpan).clamp(0.0, 1.0);
  }

  /// Độ nổi của ô (0 = nằm yên, 1 = cao nhất).
  static double lift(double p) => p <= 0 || p >= 1 ? 0 : sin(p * pi);

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || solution.isEmpty) return;
    final rows = solution.length;
    final cols = solution.first.length;
    final paint = Paint();
    // Chừa nét lưới giữa các ô.
    const inset = 0.75;
    final fillInset = cellSize >= 16 ? 1.5 : 0.5;

    final raised = <(double, Rect)>[];
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        final p = cellProgress(t: t, row: r, col: c, rows: rows, cols: cols);
        if (p <= 0) continue;
        final rect = Rect.fromLTWH(
          c * cellSize,
          r * cellSize,
          cellSize,
          cellSize,
        );
        if (solution[r][c] == 1) {
          final h = lift(p);
          if (h <= 0.01) continue;
          // Che ô gốc bên dưới, để chỗ ô vừa nhấc lên lộ nền + bóng.
          paint.color = backgroundColor;
          canvas.drawRect(rect.deflate(inset), paint);
          raised.add((h, rect));
        } else {
          paint.color = backgroundColor.withValues(
            alpha: Curves.easeOut.transform(p),
          );
          canvas.drawRect(rect.deflate(inset), paint);
        }
      }
    }

    // Ô cao hơn vẽ sau để nằm trên ô hàng xóm.
    raised.sort((a, b) => a.$1.compareTo(b.$1));
    for (final (h, rect) in raised) {
      final scale = 1 + _maxScale * h;
      final up = cellSize * 0.1 * h;
      final cell = Rect.fromCenter(
        center: rect.center,
        width: (rect.width - fillInset * 2) * scale,
        height: (rect.height - fillInset * 2) * scale,
      );
      final radius = Radius.circular(cellSize * (0.12 + 0.06 * h));
      paint.color = shadowColor.withValues(alpha: 0.16 * h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(cell.shift(Offset(0, up * 0.4)), radius),
        paint,
      );
      paint.color = filledColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(cell.shift(Offset(0, -up)), radius),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SolveWavePainter old) =>
      old.progress != progress ||
      old.solution != solution ||
      old.cellSize != cellSize ||
      old.filledColor != filledColor ||
      old.backgroundColor != backgroundColor ||
      old.shadowColor != shadowColor;
}
