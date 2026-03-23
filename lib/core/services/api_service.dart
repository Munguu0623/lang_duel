import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:voice_duel/core/constants/app_constants.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🌐 API Service — communicates with backend, OpenAI,
//    and DeepSeek for STT, scoring, and bot replies
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

class ApiService {
  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: ApiConfig.connectionTimeout,
              receiveTimeout: ApiConfig.receiveTimeout,
            ));

  final Dio _dio;

  // ── Auth token management ──────────────────────────
  String? _token;

  void setAuthToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _token = null;
    _dio.options.headers.remove('Authorization');
  }

  // ── Speech-to-Text (OpenAI Whisper / gpt-4o-transcribe) ──
  /// Sends an audio file to OpenAI and returns the transcript.
  Future<SttResult> transcribeAudio(File audioFile) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioFile.path,
          filename: 'audio.m4a',
        ),
        'model': 'gpt-4o-transcribe',
        'response_format': 'verbose_json',
        'language': 'en',
      });

      final response = await Dio(BaseOptions(
        baseUrl: ApiConfig.openAiBaseUrl,
        headers: {
          'Authorization': 'Bearer \${_getOpenAiKey()}',
        },
      )).post('/audio/transcriptions', data: formData);

      final data = response.data;
      return SttResult(
        text: data['text'] ?? '',
        durationMs: ((data['duration'] ?? 0) * 1000).round(),
      );
    } catch (e) {
      _log.e('STT failed', error: e);
      rethrow;
    }
  }

  // ── DeepSeek — Score a user's response ─────────────
  /// Sends the user's transcript + topic to DeepSeek
  /// and returns a structured score breakdown.
  Future<ScoringResult> scoreResponse({
    required String userText,
    required String topic,
    required String cefrLevel,
  }) async {
    try {
      final response = await Dio(BaseOptions(
        baseUrl: ApiConfig.deepSeekBaseUrl,
        headers: {
          'Authorization': 'Bearer \${_getDeepSeekKey()}',
          'Content-Type': 'application/json',
        },
      )).post('/chat/completions', data: {
        'model': 'deepseek-chat',
        'temperature': 0.3,
        'messages': [
          {
            'role': 'system',
            'content': '''
You are an English language scoring engine.
Score the student's response on a scale based on CEFR $cefrLevel level.
Return ONLY valid JSON with this exact structure:
{
  "grammar": <0-30>,
  "vocabulary": <0-30>,
  "fluency": <0-20>,
  "relevance": <0-20>,
  "corrections": [{"wrong": "...", "correct": "...", "explanation": "..."}],
  "advice": "One sentence of encouragement and improvement tip"
}
'''
          },
          {
            'role': 'user',
            'content': 'Topic: "$topic"\nStudent response: "$userText"',
          },
        ],
      });

      final content = response.data['choices'][0]['message']['content'];
      final json = jsonDecode(content) as Map<String, dynamic>;

      return ScoringResult(
        grammar: json['grammar'] as int,
        vocabulary: json['vocabulary'] as int,
        fluency: json['fluency'] as int,
        relevance: json['relevance'] as int,
        corrections: (json['corrections'] as List?)
                ?.map((c) => Correction(
                      wrong: c['wrong'],
                      correct: c['correct'],
                      explanation: c['explanation'],
                    ))
                .toList() ??
            [],
        advice: json['advice'] as String? ?? '',
      );
    } catch (e) {
      _log.e('Scoring failed', error: e);
      rethrow;
    }
  }

  // ── DeepSeek — Generate bot reply ──────────────────
  /// The bot generates a contextual English reply for
  /// the duel conversation.
  Future<String> generateBotReply({
    required String topic,
    required String cefrLevel,
    required List<Map<String, String>> conversationHistory,
  }) async {
    try {
      final response = await Dio(BaseOptions(
        baseUrl: ApiConfig.deepSeekBaseUrl,
        headers: {
          'Authorization': 'Bearer \${_getDeepSeekKey()}',
          'Content-Type': 'application/json',
        },
      )).post('/chat/completions', data: {
        'model': 'deepseek-chat',
        'temperature': 0.7,
        'max_tokens': 150,
        'messages': [
          {
            'role': 'system',
            'content': '''
You are an English conversation partner in a voice duel game.
Topic: "$topic". CEFR Level: $cefrLevel.
Reply naturally in 2-3 sentences. Ask a follow-up question.
Be friendly and encouraging. Match the CEFR level complexity.
'''
          },
          ...conversationHistory,
        ],
      });

      return response.data['choices'][0]['message']['content'] as String;
    } catch (e) {
      _log.e('Bot reply failed', error: e);
      rethrow;
    }
  }

  // ── Private helpers ────────────────────────────────
  // In production these come from secure backend, never bundled in app.
  String _getOpenAiKey() => const String.fromEnvironment('OPENAI_API_KEY');
  String _getDeepSeekKey() => const String.fromEnvironment('DEEPSEEK_API_KEY');
}

// ── Response DTOs ────────────────────────────────────
class SttResult {
  const SttResult({required this.text, required this.durationMs});
  final String text;
  final int durationMs;
}

class ScoringResult {
  const ScoringResult({
    required this.grammar,
    required this.vocabulary,
    required this.fluency,
    required this.relevance,
    required this.corrections,
    required this.advice,
  });

  final int grammar;
  final int vocabulary;
  final int fluency;
  final int relevance;
  final List<Correction> corrections;
  final String advice;

  int get total => grammar + vocabulary + fluency + relevance;
}

class Correction {
  const Correction({
    required this.wrong,
    required this.correct,
    required this.explanation,
  });

  final String wrong;
  final String correct;
  final String explanation;
}
