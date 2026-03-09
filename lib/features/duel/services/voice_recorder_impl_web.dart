// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:async';
import 'dart:typed_data';

import 'package:record/record.dart';

/// Web recording implementation — uses MediaRecorder via record package.
/// No permission_handler needed (browser handles mic permission natively).
class VoiceRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _blobUrl;

  /// MIME type sent to the server — webm/opus in Chrome.
  String get mimeType => 'audio/webm';

  Future<bool> start() async {
    // Browser will prompt for mic permission automatically.
    try {
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.opus, bitRate: 64000),
        path: '', // Ignored on web — record stores audio in memory.
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Stops recording and returns audio bytes read from the blob URL.
  Future<Uint8List?> stop() async {
    final blobUrl = await _recorder.stop();
    _blobUrl = blobUrl;
    if (blobUrl == null || blobUrl.isEmpty) return null;
    return _fetchBlobBytes(blobUrl);
  }

  Future<void> cancel() async {
    await _recorder.cancel();
    if (_blobUrl != null) {
      html.Url.revokeObjectUrl(_blobUrl!);
      _blobUrl = null;
    }
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }

  /// Reads a blob: URL into raw bytes using XMLHttpRequest.
  Future<Uint8List?> _fetchBlobBytes(String blobUrl) async {
    final completer = Completer<Uint8List?>();
    final req = html.HttpRequest();
    req.open('GET', blobUrl, async: true);
    req.responseType = 'arraybuffer';
    req.onLoad.listen((_) {
      final buf = req.response as ByteBuffer?;
      completer.complete(buf?.asUint8List());
    });
    req.onError.listen((_) => completer.complete(null));
    req.send();
    return completer.future;
  }
}
