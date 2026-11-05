import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/nonogram_play_bloc.dart';
import '../bloc/nonogram_play_event.dart';

/// Báo kích thước vùng chứa bàn chơi cho bloc (bloc tự bỏ qua nếu không đổi),
/// để màn mới tự chọn cỡ ô vừa màn hình.
class BoardViewportReporter extends StatelessWidget {
  const BoardViewportReporter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedWidth && constraints.hasBoundedHeight) {
          final bloc = context.read<NonogramPlayBloc>();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (bloc.isClosed) return;
            bloc.add(
              BoardViewportMeasured(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            );
          });
        }
        return child;
      },
    );
  }
}
