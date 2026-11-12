import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'rating_policy.dart';

/// Mở trang của app trên cửa hàng.
abstract class StoreLauncher {
  Future<void> openStoreListing();
}

/// Mở CH Play: ưu tiên app Play Store (`market://`), không có thì mở trang
/// web.
class PlayStoreLauncher implements StoreLauncher {
  const PlayStoreLauncher({this.packageName = 'com.chauvb.nonogram'});

  final String packageName;

  @override
  Future<void> openStoreListing() async {
    try {
      final opened = await launchUrl(
        Uri.parse('market://details?id=$packageName'),
        mode: LaunchMode.externalApplication,
      );
      if (opened) return;
    } catch (_) {}
    try {
      await launchUrl(
        Uri.parse('https://play.google.com/store/apps/details?id=$packageName'),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Open store listing: $e');
    }
  }
}

/// Lời mời đánh giá app: nhớ đã hỏi bao nhiêu lần, quyết định có hỏi không
/// (theo [RatingPolicy]) và mở cửa hàng khi người chơi cho 5 sao.
class AppRatingController {
  AppRatingController._(this._box, {required RatingState state})
    : _state = state,
      policy = const RatingPolicy(),
      store = const PlayStoreLauncher();

  /// Dùng chung box tuỳ chọn với `OnboardingPreferences`.
  static const _boxName = 'nonogram_preferences_v1';
  static const _answeredKey = 'rating_answered';
  static const _promptsKey = 'rating_prompts';
  static const _lastSolvedKey = 'rating_last_prompt_solved';

  final Box<dynamic>? _box;
  final RatingPolicy policy;
  final StoreLauncher store;
  RatingState _state;

  RatingState get state => _state;

  /// Gọi sau `Hive.initFlutter()`.
  static Future<AppRatingController> load() async {
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      return AppRatingController._(
        box,
        state: RatingState(
          answered: box.get(_answeredKey) == true,
          prompts: (box.get(_promptsKey) as int?) ?? 0,
          lastPromptSolved: box.get(_lastSolvedKey) as int?,
        ),
      );
    } catch (_) {
      return AppRatingController._(null, state: const RatingState());
    }
  }

  /// Dùng trong test: không lưu.
  AppRatingController.inMemory({
    RatingState state = const RatingState(),
    this.policy = const RatingPolicy(),
    required this.store,
  }) : _box = null,
       _state = state;

  /// Số sao để mở cửa hàng.
  static const storeStars = 5;

  bool shouldPrompt(int solvedLevels) =>
      policy.shouldPrompt(solvedLevels: solvedLevels, state: _state);

  /// Ghi nhận đã hiện lời mời (trước khi người chơi trả lời).
  Future<void> recordPrompt(int solvedLevels) async {
    _state = RatingState(
      answered: _state.answered,
      prompts: _state.prompts + 1,
      lastPromptSolved: solvedLevels,
    );
    await _box?.put(_promptsKey, _state.prompts);
    await _box?.put(_lastSolvedKey, solvedLevels);
  }

  /// Người chơi chọn [stars] sao: không hỏi nữa; 5 sao thì mở cửa hàng.
  Future<void> submit(int stars) async {
    _state = RatingState(
      answered: true,
      prompts: _state.prompts,
      lastPromptSolved: _state.lastPromptSolved,
    );
    await _box?.put(_answeredKey, true);
    if (stars >= storeStars) await store.openStoreListing();
  }
}
