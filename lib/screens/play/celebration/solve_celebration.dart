import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:nonogram/widgets/nonogram_pixel_art.dart';

/// Các bước của hiệu ứng giải xong một màn.
enum SolveCelebrationPhase {
  /// Không có hiệu ứng (đang chơi, hoặc mở một màn đã giải sẵn).
  idle,

  /// Sóng sáng lan trên bàn chơi, từ góc trái dưới lên góc phải trên.
  wave,

  /// Đã sang màn kết quả; tranh đang bay từ chỗ lưới vào ô kết quả.
  flight,

  /// Tranh đã nằm yên trong ô kết quả.
  done,
}

/// Điều phối hiệu ứng giải xong: sóng lan trên lưới, rồi tranh bay từ lưới
/// vào ô tranh của màn kết quả (kiểu hero animation trong cùng một trang).
///
/// Chỉ báo thay đổi khi đổi bước; từng khung hình của sóng / đường bay đi
/// qua [wave] và [flight] để bàn chơi chỉ vẽ lại lớp hiệu ứng.
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
  static const flightDuration = Duration(milliseconds: 700);

  final AnimationController _wave;
  final AnimationController _flight;

  /// Gắn vào vùng lưới trên bàn chơi (điểm xuất phát của đường bay).
  final GlobalKey gridKey = GlobalKey(debugLabel: 'solve-grid');

  /// Gắn vào ô tranh trên màn kết quả (điểm đến của đường bay).
  final GlobalKey pictureKey = GlobalKey(debugLabel: 'solve-picture');

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

  late final Animation<double> flight = _flight.drive(
    CurveTween(curve: Curves.easeInOutCubic),
  );

  /// Đường bay (toạ độ toàn màn hình); null khi không bay.
  Rect? _from;
  Rect? _to;
  Rect? get flightFrom => _from;
  Rect? get flightTo => _to;

  /// Đang sóng: trang chơi vẫn giữ bàn chơi thay vì sang màn kết quả.
  bool get holdsBoard => _phase == SolveCelebrationPhase.wave;

  /// Tranh trên màn kết quả đang bị che, chờ bản bay tới.
  bool get hidesPicture => _phase == SolveCelebrationPhase.flight;

  /// Màn kết quả này đến từ hiệu ứng (tranh bay vào), nên tranh không tự
  /// phóng to lúc hiện ra nữa.
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
    _setPhase(SolveCelebrationPhase.wave);
    HapticFeedback.mediumImpact();
    try {
      await _wave.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    }
    if (_disposed || _phase != SolveCelebrationPhase.wave) return;

    _from = _globalRect(gridKey);
    _setPhase(SolveCelebrationPhase.flight);
    // Chờ màn kết quả dựng xong để đo ô tranh.
    WidgetsBinding.instance.addPostFrameCallback((_) => _fly());
  }

  Future<void> _fly() async {
    if (_disposed || _phase != SolveCelebrationPhase.flight) return;
    _to = _globalRect(pictureKey);
    if (_from == null || _to == null) {
      _land();
      return;
    }
    notifyListeners();
    try {
      await _flight.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    }
    _land();
  }

  void _land() {
    if (_disposed || _phase != SolveCelebrationPhase.flight) return;
    _from = _to = null;
    HapticFeedback.lightImpact();
    _setPhase(SolveCelebrationPhase.done);
  }

  /// Về trạng thái ban đầu (sang màn mới, hoặc chơi lại).
  void reset() {
    _wave.stop();
    _flight.stop();
    _wave.value = 0;
    _flight.value = 0;
    _from = _to = null;
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
          if (!celebration.hidesPicture || from == null) {
            return const SizedBox.shrink();
          }
          // Khung đầu tiên của màn kết quả chưa đo được ô tranh: giữ tranh
          // đúng chỗ lưới để không bị nháy trống.
          final to = celebration.flightTo ?? from;
          // Đổi toạ độ toàn màn hình sang toạ độ của lớp phủ này.
          final box = context.findRenderObject();
          final origin =
              box is RenderBox && box.hasSize
                  ? box.localToGlobal(Offset.zero)
                  : Offset.zero;
          final src = from.shift(-origin);
          final dst = to.shift(-origin);
          final art = NonogramPixelArt.picture(context, celebration.solution);
          return AnimatedBuilder(
            animation: celebration.flight,
            child: art,
            builder: (context, child) {
              final t = celebration.flight.value;
              // Nhô lên một chút giữa đường bay cho có cảm giác "nhấc" tranh.
              final lift = sin(t * pi);
              return Stack(
                children: [
                  Positioned.fromRect(
                    rect: Rect.lerp(src, dst, t)!,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18 * lift),
                            blurRadius: 24 * lift,
                            offset: Offset(0, 10 * lift),
                          ),
                        ],
                      ),
                      child: child,
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

/// Lớp sóng vẽ đè lên lưới khi vừa giải xong: mỗi ô tô sáng lên (vàng) rồi
/// về màu cũ khi sóng đi qua; ô trống được xoá sạch dấu X để lộ hình.
class SolveWavePainter extends CustomPainter {
  SolveWavePainter({
    required this.progress,
    required this.solution,
    required this.cellSize,
    required this.filledColor,
    required this.highlightColor,
    required this.backgroundColor,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final List<List<int>> solution;
  final double cellSize;
  final Color filledColor;
  final Color highlightColor;
  final Color backgroundColor;

  /// Phần thời gian mỗi ô sáng lên; phần còn lại là độ trễ theo vị trí.
  static const _cellSpan = 0.35;

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

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t <= 0 || solution.isEmpty) return;
    final rows = solution.length;
    final cols = solution.first.length;
    final paint = Paint();
    // Chừa nét lưới giữa các ô.
    const inset = 0.75;
    final radius = Radius.circular(cellSize * 0.18);

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
          if (p >= 1) continue;
          final glow = sin(p * pi);
          paint.color = Color.lerp(filledColor, highlightColor, glow)!;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              rect.deflate(inset).inflate(cellSize * 0.12 * glow),
              radius,
            ),
            paint,
          );
        } else {
          paint.color = backgroundColor.withValues(
            alpha: Curves.easeOut.transform(p),
          );
          canvas.drawRect(rect.deflate(inset), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(SolveWavePainter old) =>
      old.progress != progress ||
      old.solution != solution ||
      old.cellSize != cellSize ||
      old.filledColor != filledColor ||
      old.highlightColor != highlightColor ||
      old.backgroundColor != backgroundColor;
}
