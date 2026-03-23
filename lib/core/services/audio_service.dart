import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🎙️ Audio Service — record user voice, play bot TTS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

class AudioService {
  AudioService();

  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  bool _isRecording = false;
  String? _lastRecordingPath;

  bool get isRecording => _isRecording;
  String? get lastRecordingPath => _lastRecordingPath;

  // ── Permissions ────────────────────────────────────
  /// Requests microphone permission. Returns true if granted.
  Future<bool> requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) return true;

    _log.w('Microphone permission denied: $status');
    return false;
  }

  // ── Recording ──────────────────────────────────────
  /// Starts recording audio to a temporary .m4a file.
  Future<void> startRecording() async {
    if (_isRecording) return;

    final hasPermission = await requestMicPermission();
    if (!hasPermission) {
      throw AudioPermissionDeniedException();
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/duel_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
      ),
      path: path,
    );

    _isRecording = true;
    _lastRecordingPath = path;
    _log.i('Recording started → $path');
  }

  /// Stops recording and returns the audio file.
  Future<File?> stopRecording() async {
    if (!_isRecording) return null;

    final path = await _recorder.stop();
    _isRecording = false;
    _log.i('Recording stopped → $path');

    if (path == null) return null;
    return File(path);
  }

  // ── Playback ───────────────────────────────────────
  /// Plays audio from a URL (e.g. TTS response).
  Future<void> playFromUrl(String url) async {
    await _player.stop();
    await _player.play(UrlSource(url));
  }

  /// Plays audio from a local file path.
  Future<void> playFromFile(String path) async {
    await _player.stop();
    await _player.play(DeviceFileSource(path));
  }

  /// Stops any current playback.
  Future<void> stopPlayback() async {
    await _player.stop();
  }

  // ── Cleanup ────────────────────────────────────────
  /// Call when leaving the duel screen.
  Future<void> dispose() async {
    if (_isRecording) await _recorder.stop();
    await _player.dispose();
    await _recorder.dispose();
  }
}

// ── Exceptions ───────────────────────────────────────
class AudioPermissionDeniedException implements Exception {
  @override
  String toString() => 'Microphone permission was denied.';
}
