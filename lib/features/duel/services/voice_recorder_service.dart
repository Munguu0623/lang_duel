// Platform-specific implementation selected at compile time:
//   Native (Android / iOS / Desktop): dart:io + permission_handler
//   Web:                               dart:html + MediaRecorder
//
// Both expose the same API:
//   start()  → Future<bool>
//   stop()   → Future<Uint8List?>   (audio bytes, null on error)
//   cancel() → Future<void>
//   dispose()→ Future<void>
//   mimeType → String              ('audio/m4a' native | 'audio/webm' web)
export 'voice_recorder_impl_native.dart'
    if (dart.library.html) 'voice_recorder_impl_web.dart';
