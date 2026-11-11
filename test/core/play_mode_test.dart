import 'package:flutter_test/flutter_test.dart';
import 'package:nonogram/core/app_flavor.dart';
import 'package:nonogram/core/play_mode.dart';

void main() {
  test('only the dev flavor has the play mode selection', () {
    expect(AppFlavor.fromName('dev'), AppFlavor.dev);
    expect(AppFlavor.fromName('store'), AppFlavor.store);
    // iOS, web và `flutter test` không truyền --flavor: coi như bản store.
    expect(AppFlavor.fromName(null), AppFlavor.store);
    expect(AppFlavor.dev.hasPlayModeSelection, isTrue);
    expect(AppFlavor.store.hasPlayModeSelection, isFalse);
  });

  test('each play mode has its own levels and progress box', () {
    expect(PlayMode.user.levelsPath, 'assets/levels');
    expect(PlayMode.developer.levelsPath, 'assets/levels_dev');
    // Chế độ nhà phát triển giữ box tiến độ của các bản thử trước đây.
    expect(PlayMode.developer.progressBoxName, 'nonogram_offline_v1');
    expect(
      PlayMode.user.progressBoxName,
      isNot(PlayMode.developer.progressBoxName),
    );
  });

  test('play mode preferences remember the last mode', () async {
    final prefs = PlayModePreferences.inMemory();
    expect(prefs.lastMode, isNull);
    await prefs.save(PlayMode.developer);
    expect(prefs.lastMode, PlayMode.developer);
    expect(PlayMode.tryParse('user'), PlayMode.user);
    expect(PlayMode.tryParse('nope'), isNull);
  });
}
