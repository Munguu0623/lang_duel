import 'package:flutter/foundation.dart';

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.isLoading = false,
  });

  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final bool isLoading;

  ChatMessage copyWith({
    String? text,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      isMe: isMe,
      timestamp: timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
