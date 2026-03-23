import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🔍 Matchmaking Screen — 20s search → bot fallback
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class MatchmakingScreen extends ConsumerStatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  ConsumerState<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends ConsumerState<MatchmakingScreen>
    with SingleTickerProviderStateMixin {
  int _elapsedSeconds = 0;
  bool _found = false;
  Timer? _timer;
  late final AnimationController _popCtrl;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _startSearch();
  }

  void _startSearch() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _elapsedSeconds++);

      // Simulate finding a bot after 3 seconds
      if (_elapsedSeconds >= 3 && !_found) {
        timer.cancel();
        setState(() => _found = true);
        _popCtrl.forward();

        // Navigate to duel after showing "found" state
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) context.pushReplacement(AppRoutes.duel);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topic = ref.watch(selectedTopicProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.06),
              AppColors.info.withOpacity(0.06),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: _found ? _buildFound(topic) : _buildSearching(),
          ),
        ),
      ),
    );
  }

  Widget _buildSearching() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            backgroundColor: AppColors.light,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Өрсөлдөгч хайж байна...', style: AppText.displaySm),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$_elapsedSeconds секунд',
          style: AppText.bodyMd.copyWith(color: AppColors.darkSoft),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(
          '20 сек дотор олдохгүй бол AI Bot тэмцэнэ',
          style: AppText.bodySm,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFound(dynamic topic) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _popCtrl, curve: Curves.elasticOut),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🤖', style: TextStyle(fontSize: 56)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Bot олдлоо!',
            style: AppText.displaySm.copyWith(color: AppColors.primary),
          ),
          if (topic != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Сэдэв: "${topic.title}"',
              style: AppText.bodyMd.copyWith(color: AppColors.darkSoft),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppBadge(
              text: 'Level ${topic.cefrLevel.label}',
              color: AppColors.info.withOpacity(0.15),
              textColor: AppColors.info,
            ),
          ],
        ],
      ),
    );
  }
}
