import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Singleton audio service for persistent background music.
///
/// Lifecycle:
///   - Create once and provide via [ChangeNotifierProvider].
///   - Call [play] to start looping background music.
///   - Call [stop] to silence it completely.
///   - [isPlaying] reflects the current playback state.
///
/// Uses [ReleaseMode.loop] so the track repeats automatically.
class AudioController extends ChangeNotifier {
  AudioController() {
    _player.onPlayerStateChanged.listen((state) {
      final nowPlaying = state == PlayerState.playing;
      if (nowPlaying != _isPlaying) {
        _isPlaying = nowPlaying;
        notifyListeners();
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  bool _isBusy = false; // debounce guard against rapid toggling

  bool get isPlaying => _isPlaying;

  static const String _assetPath = 'audio/Where_the_Sand_Settles.mp3';

  /// Start background music in an infinite loop. No-op if already playing.
  Future<void> play() async {
    if (_isPlaying || _isBusy) return;
    _isBusy = true;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource(_assetPath));
    } finally {
      _isBusy = false;
    }
  }

  /// Stop background music completely. No-op if already stopped.
  Future<void> stop() async {
    if (!_isPlaying || _isBusy) return;
    _isBusy = true;
    try {
      await _player.stop();
    } finally {
      _isBusy = false;
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
