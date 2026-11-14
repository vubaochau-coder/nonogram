import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

/// Các tiếng trong game (file trong `assets/sounds/`, tạo bằng
/// `tools/generate_sounds.py`).
enum GameSound {
  /// Tô một ô.
  fill('fill', voices: 3),

  /// Đánh X / xoá ô.
  mark('mark', voices: 3),

  /// Vừa khớp xong một hàng / cột.
  line('line', voices: 2),

  /// Sóng nổi ô khi giải xong.
  wave('wave'),

  /// Tranh bay sang màn kết quả.
  whoosh('whoosh'),

  /// Tranh đáp xuống thẻ kết quả; hộp quà điểm danh bật nắp.
  fanfare('fanfare'),

  /// Nút điểm danh vỡ như bong bóng.
  pop('pop'),

  /// Ô hôm nay trên lịch được đóng dấu.
  stamp('stamp'),

  /// Hộp quà điểm danh rung (mỗi nhịp một tiếng).
  knock('knock', voices: 2);

  const GameSound(this.file, {this.voices = 1});

  final String file;

  /// Số tiếng cùng loại phát chồng lên nhau được (kéo tô nhanh).
  final int voices;

  String get assetPath => 'sounds/$file.wav';
}

/// Nơi phát tiếng thật; tách riêng để test không cần plugin âm thanh.
abstract interface class GameSoundEngine {
  void play(GameSound sound);
  void dispose();
}

/// Bật / tắt âm thanh (mặc định bật, lưu trên máy) và phát tiếng.
///
/// Dùng chung box tuỳ chọn với `AppThemeModeController`.
class AppSoundController extends ValueNotifier<bool> {
  AppSoundController._(this._box, bool enabled, this._engine) : super(enabled);

  static const _boxName = 'nonogram_preferences_v1';
  static const _enabledKey = 'sound_enabled';

  /// Cùng một tiếng ngắn không phát dày hơn mức này (kéo tô qua nhiều ô).
  static const minGap = Duration(milliseconds: 45);

  final Box<dynamic>? _box;
  final GameSoundEngine? _engine;
  final Map<GameSound, DateTime> _lastPlayed = {};

  /// Gọi sau `Hive.initFlutter()`.
  static Future<AppSoundController> load() async {
    // Nạp sẵn file ở nền để tiếng đầu tiên không bị trễ.
    final engine = AudioPlayersSoundEngine()..warmUp();
    try {
      final box = await Hive.openBox<dynamic>(_boxName);
      return AppSoundController._(box, box.get(_enabledKey) != false, engine);
    } catch (_) {
      return AppSoundController._(null, true, engine);
    }
  }

  /// Dùng trong test: không lưu; không có [engine] thì không phát gì.
  AppSoundController.inMemory({bool enabled = true, GameSoundEngine? engine})
    : _box = null,
      _engine = engine,
      super(enabled);

  bool get enabled => value;

  Future<void> setEnabled(bool enabled) async {
    if (value == enabled) return;
    value = enabled;
    await _box?.put(_enabledKey, enabled);
  }

  void play(GameSound sound) {
    if (!value || _engine == null) return;
    final now = DateTime.now();
    final last = _lastPlayed[sound];
    if (last != null && now.difference(last) < minGap) return;
    _lastPlayed[sound] = now;
    _engine.play(sound);
  }

  /// Null khi không có (test dựng trang mà không cấp): không phát gì.
  static AppSoundController? maybeOf(BuildContext context) {
    try {
      return Provider.of<AppSoundController>(context, listen: false);
    } on ProviderNotFoundException {
      return null;
    }
  }

  @override
  void dispose() {
    _engine?.dispose();
    super.dispose();
  }
}

/// Phát bằng `audioplayers`: mỗi tiếng giữ sẵn vài player đã nạp file, phát
/// xoay vòng. Android dùng chế độ độ trễ thấp (SoundPool). Tiếng game hoà
/// chung với nhạc đang phát của máy và im khi máy để chế độ im lặng (iOS).
class AudioPlayersSoundEngine implements GameSoundEngine {
  final Map<GameSound, List<AudioPlayer>> _players = {};
  final Map<GameSound, int> _next = {};
  Future<void>? _ready;

  static bool get _lowLatency =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> _prepare() async {
    try {
      await AudioPlayer.global.setAudioContext(
        AudioContextConfig(
          focus: AudioContextConfigFocus.mixWithOthers,
          respectSilence: true,
        ).build(),
      );
    } catch (_) {}
    for (final sound in GameSound.values) {
      final list = <AudioPlayer>[];
      for (var i = 0; i < sound.voices; i++) {
        try {
          final player = AudioPlayer();
          await player.setReleaseMode(ReleaseMode.stop);
          if (_lowLatency) await player.setPlayerMode(PlayerMode.lowLatency);
          await player.setSource(AssetSource(sound.assetPath));
          list.add(player);
        } catch (_) {
          // Máy không phát được tiếng này: bỏ qua, game vẫn chạy.
        }
      }
      _players[sound] = list;
    }
  }

  void warmUp() => _ready ??= _prepare();

  @override
  void play(GameSound sound) {
    warmUp();
    unawaited(_play(sound));
  }

  Future<void> _play(GameSound sound) async {
    try {
      await _ready;
      final list = _players[sound];
      if (list == null || list.isEmpty) return;
      final i = (_next[sound] ?? 0) % list.length;
      _next[sound] = i + 1;
      final player = list[i];
      await player.stop();
      await player.resume();
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final list in _players.values) {
      for (final player in list) {
        player.dispose();
      }
    }
    _players.clear();
  }
}
