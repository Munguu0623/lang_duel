import 'dart:io';
import 'dart:typed_data';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// Native (Android / iOS / Desktop) recording implementation.
/// stop() reads the temp file into bytes and deletes it.
class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentPath;

  /// MIME type sent to the server — aac/m4a on native.
  String get mimeType => 'audio/m4a';

  Future<bool> start() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return false;

    final dir = Directory.systemTemp;
    _currentPath =
        '${dir.path}/duel_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 64000),
      path: _currentPath!,
    );
    return true;
  }

  /// Stops recording and returns audio bytes (null on error).
  Future<Uint8List?> stop() async {
    final path = await _recorder.stop();
    _currentPath = null;
    if (path == null) return null;

    final file = File(path);
    if (!await file.exists()) return null;
    final bytes = await file.readAsBytes();
    await file.delete(); // Clean up temp file
    return bytes;
  }

  /// Cancels recording without returning audio.
  Future<void> cancel() async {
    await _recorder.cancel();
    if (_currentPath != null) {
      final file = File(_currentPath!);
      if (await file.exists()) await file.delete();
      _currentPath = null;
    }
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
