// =============================================================================
// api_client.dart — Retrofit @RestApi interface
// =============================================================================
//
// Энэ файл нь backend-тай харилцах бүх HTTP endpoint-уудыг нэг дор тодорхойлно.
// Retrofit package ашиглан @RestApi annotation-аар abstract class үүсгэнэ.
// build_runner ажиллуулсны дараа `api_client.g.dart` файл автоматаар үүснэ.
//
// ШААРДЛАГАТАЙ IMPORT-УУД:
//   - package:dio/dio.dart
//   - package:retrofit/retrofit.dart
//   - болон бүх DTO файлууд (features/-аас)
//
// ДООРХ ENDPOINT-УУДЫГ ТОДОРХОЙЛНО:
//
// --- AUTH ---
//   @POST('/auth/google')
//   Future<AuthResponseDto> loginWithGoogle(@Body() GoogleAuthRequestDto body)
//   → Firebase idToken илгээж, backend-аас accessToken + refreshToken авна
//
//   @POST('/auth/refresh')
//   Future<AuthResponseDto> refreshToken(@Body() RefreshRequestDto body)
//   → refreshToken илгээж, шинэ accessToken авна
//
//   @DELETE('/auth/logout')
//   Future<void> logout()
//   → Backend дээр refresh token устгана
//
// --- USER / PROFILE ---
//   @GET('/users/me')
//   Future<UserDto> getProfile()
//   → Нэвтэрсэн хэрэглэгчийн мэдээлэл авна
//
//   @PATCH('/users/me')
//   Future<UserDto> updateProfile(@Body() UpdateProfileDto body)
//   → Нэр, emoji шинэчлэнэ
//
//   @GET('/users/me/achievements')
//   Future<List<AchievementDto>> getAchievements()
//   → Хэрэглэгчийн амжилтуудын жагсаалт авна
//
// --- TOPICS ---
//   @GET('/topics')
//   Future<List<TopicDto>> getTopics(@Query('level') String? level)
//   → Home screen дээр харагдах topic жагсаалт
//   → level параметр: 'A1','A2','B1','B2','C1' (заавал биш)
//
// --- DUEL / MATCHMAKING ---
//   @POST('/duels/match')
//   Future<DuelSessionDto> findMatch(@Body() MatchRequestDto body)
//   → Дайралт эхлүүлнэ. body: { cefrLevel, topicId }
//   → Response: { sessionId, opponentType: 'bot'|'human', opponent: {...} }
//
//   @GET('/duels/{sessionId}')
//   Future<DuelSessionDto> getDuelSession(@Path('sessionId') String id)
//   → Тухайн session-ийн одоогийн байдлыг авна
//
//   @POST('/duels/{sessionId}/turns')
//   Future<TurnResultDto> submitTurn(
//     @Path('sessionId') String id,
//     @Body() TurnSubmitRequestDto body,
//   )
//   → Нэг ээлжийн хариулт илгээнэ (transcript + scoreBreakdown)
//   → Response: bot-ийн хариулт + bot score
//
//   @GET('/duels/{sessionId}/result')
//   Future<DuelResultDto> getDuelResult(@Path('sessionId') String id)
//   → Бүх ээлж дууссаны дараа эцсийн дүн авна
//
// --- LEADERBOARD ---
//   @GET('/leaderboard')
//   Future<List<LeaderboardEntryDto>> getLeaderboard(
//     @Query('period') String period,  // 'weekly' | 'alltime'
//   )
//
// --- PAYMENT / SUBSCRIPTION ---
//   @POST('/payments/verify')
//   Future<PremiumStatusDto> verifyPurchase(@Body() PurchaseVerifyRequestDto body)
//   → App Store / Google Play receipt илгээж premium баталгаажуулна
//
//   @GET('/users/me/subscription')
//   Future<PremiumStatusDto> getSubscriptionStatus()
//   → App нээх үед premium статус шалгана
//
// --- AI (PROXY) ---
// Дараах endpoint-ууд нь OpenAI болон DeepSeek-рүү backend proxy хийнэ.
// Flutter апп шууд AI API-руу холбогдохгүй — API key аюулгүй байхын тулд.
//
//   @POST('/ai/transcribe')
//   Future<TranscribeResponseDto> transcribeAudio(@Body() FormData formData)
//   → Audio file илгээж, Whisper STT-р текст болгоно
//
//   @POST('/ai/score')
//   Future<ScoreResponseDto> scoreResponse(@Body() ScoreRequestDto body)
//   → Хэрэглэгчийн хариултыг DeepSeek-р үнэлнэ
//
//   @POST('/ai/bot-reply')
//   Future<BotReplyResponseDto> getBotReply(@Body() BotReplyRequestDto body)
//   → Bot-ийн дараагийн хариултыг DeepSeek-р үүсгэнэ
//
// =============================================================================
// ФАЙЛ ҮҮСГЭХ ДАРААЛАЛ:
//   1. Энэ файлд бүх endpoint-уудыг тодорхойл
//   2. dart run build_runner build --delete-conflicting-outputs ажиллуул
//   3. api_client.g.dart автоматаар үүснэ — энэ файлыг edit хийхгүй
// =============================================================================
