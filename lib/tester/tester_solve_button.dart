import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_bloc.dart';
import 'package:nonogram/screens/play/bloc/nonogram_play_event.dart';
import 'package:provider/provider.dart';

import 'tester_settings.dart';

/// Nút "Giải ngay" của công cụ tester trên màn chơi: tô đúng đáp án và hoàn
/// thành màn. Không hiện gì ở bản `store` (không có [TesterSettings]) hoặc khi
/// tester đã tắt nút.
class TesterSolveButton extends StatelessWidget {
  const TesterSolveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TesterSettings? tester;
    try {
      tester = context.watch<TesterSettings>();
    } on ProviderNotFoundException {
      return const SizedBox.shrink();
    }
    if (!tester.showSolveButton) return const SizedBox.shrink();
    return IconButton(
      key: const ValueKey('tester-solve'),
      tooltip: 'Tester: giải ngay',
      icon: const Icon(LucideIcons.zap, size: 20, color: Color(0xFFF59E0B)),
      onPressed:
          () =>
              context.read<NonogramPlayBloc>().add(const DebugSolveRequested()),
    );
  }
}
