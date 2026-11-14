import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonogram/core/app_sounds.dart';
import 'package:nonogram/models/nonogram_cell_state.dart';

import 'bloc/nonogram_play_bloc.dart';
import 'bloc/nonogram_play_state.dart';

/// Phát tiếng khi bàn chơi đổi: tô ô, đánh X / xoá ô, khớp xong một hàng /
/// cột. Tiếng giải xong do hiệu ứng giải xong phát.
class NonogramPlaySounds extends StatefulWidget {
  const NonogramPlaySounds({super.key, required this.child});

  final Widget child;

  @override
  State<NonogramPlaySounds> createState() => _NonogramPlaySoundsState();
}

class _NonogramPlaySoundsState extends State<NonogramPlaySounds> {
  PlayTally? _last;

  void _onState(BuildContext context, NonogramPlayState state) {
    final tally = _tallyOf(state);
    final prev = _last;
    _last = tally;
    // Lúc mở màn / khôi phục ván / sang màn mới thì im.
    if (prev == null || state.isLoading || prev.game != tally.game) return;
    final sound = soundFor(prev, tally);
    if (sound != null) AppSoundController.maybeOf(context)?.play(sound);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NonogramPlayBloc, NonogramPlayState>(
      listenWhen:
          (p, c) =>
              !identical(p.gridData, c.gridData) || p.isLoading != c.isLoading,
      listener: _onState,
      child: widget.child,
    );
  }
}

/// Tiếng cho một lần bàn chơi đổi từ [prev] sang [next]; null = im. Dùng
/// chung cho màn chơi và bài hướng dẫn.
GameSound? soundFor(PlayTally prev, PlayTally next) {
  final filledUp = next.filled > prev.filled;
  // Khớp thêm hàng / cột (trừ nước cuối giải xong: hiệu ứng giải xong lo).
  if (next.lines > prev.lines && next.lines < next.totalLines) {
    return GameSound.line;
  }
  if (filledUp) return GameSound.fill;
  final removed =
      (prev.filled - next.filled).clamp(0, 1 << 30) +
      (prev.marked - next.marked).clamp(0, 1 << 30);
  // Chơi lại từ đầu xoá cả bàn: không kêu.
  if (next.marked > prev.marked || (removed > 0 && removed <= 2)) {
    return GameSound.mark;
  }
  return null;
}

/// Đếm nhanh bàn chơi: ván nào, bao nhiêu ô tô / ô X, bao nhiêu hàng + cột
/// đã khớp.
typedef PlayTally =
    ({Object? game, int filled, int marked, int lines, int totalLines});

PlayTally _tallyOf(NonogramPlayState state) {
  var filled = 0;
  var marked = 0;
  for (final row in state.gridData) {
    for (final cell in row) {
      if (cell == NonogramCellState.filled) {
        filled++;
      } else if (cell == NonogramCellState.marked) {
        marked++;
      }
    }
  }
  final lines =
      state.satisfiedRows.where((v) => v).length +
      state.satisfiedCols.where((v) => v).length;
  return (
    game: (state.puzzle?.id, state.startTime),
    filled: filled,
    marked: marked,
    lines: lines,
    totalLines: state.satisfiedRows.length + state.satisfiedCols.length,
  );
}
