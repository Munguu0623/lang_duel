/// Stage types — determines the gameplay mechanic.
enum StageType { free, question, boss, errorFix, describe }

/// A single stage on the level map.
class Stage {
  const Stage({
    required this.id,
    required this.title,
    required this.prompt,
    required this.type,
    required this.emoji,
  });

  final int id;
  final String title;
  final String prompt;
  final StageType type;
  final String emoji;

  bool get isBoss => type == StageType.boss;

  String get typeLabel => switch (type) {
    StageType.free     => '🗣️ Чөлөөт яриа',
    StageType.question => '❓ Асуулт-Хариулт',
    StageType.boss     => '⚔️ Boss Battle',
    StageType.errorFix => '🔍 Алдаа олох',
    StageType.describe => '🖼️ Тайлбарлах',
  };
}

/// A1 Level — 10 stages with boss battles at 5 and 10.
const List<Stage> a1Stages = [
  Stage(id: 1,  title: 'Мэндчилгээ',       prompt: 'Introduce yourself: name, age, where you live',        type: StageType.free,     emoji: '👋'),
  Stage(id: 2,  title: 'Гэр бүл',           prompt: 'Tell me about your family members',                    type: StageType.question, emoji: '👨‍👩‍👧'),
  Stage(id: 3,  title: 'Өдөр тутам',        prompt: 'Describe your daily routine from morning to night',    type: StageType.free,     emoji: '☀️'),
  Stage(id: 4,  title: 'Хоол',              prompt: 'What is your favorite food and why?',                  type: StageType.question, emoji: '🍜'),
  Stage(id: 5,  title: 'BOSS: Миний тухай', prompt: 'Tell me everything about yourself in 60 seconds',      type: StageType.boss,     emoji: '⚔️'),
  Stage(id: 6,  title: 'Сургууль',          prompt: 'Describe your school or workplace',                    type: StageType.free,     emoji: '🏫'),
  Stage(id: 7,  title: 'Хобби',             prompt: 'What do you do in your free time?',                    type: StageType.question, emoji: '🎮'),
  Stage(id: 8,  title: 'Алдаа ол',          prompt: 'Find and correct the grammar mistakes',                type: StageType.errorFix, emoji: '🔍'),
  Stage(id: 9,  title: 'Зураг тайлбарла',   prompt: 'Describe what you see in detail',                      type: StageType.describe, emoji: '🖼️'),
  Stage(id: 10, title: 'LEVEL UP!',         prompt: 'Final: Have a full conversation about your life',      type: StageType.boss,     emoji: '👑'),
];
