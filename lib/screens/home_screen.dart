import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/reason.dart';
import '../theme/app_theme.dart';
import '../widgets/reason_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  ReasonsData? _data;
  String? _error;

  late final PageController _pageController;
  double _page = 0;

  late final AnimationController _introController;
  late final Animation<double> _introFade;
  late final Animation<Offset> _introSlide;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.84)
      ..addListener(() {
        setState(() {
          _page = _pageController.page ?? 0;
        });
      });

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _introFade = CurvedAnimation(parent: _introController, curve: Curves.easeOut);
    _introSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _introController, curve: Curves.easeOutCubic));

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final raw = await DefaultAssetBundle.of(context)
          .loadString('assets/data/reasons.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      setState(() {
        _data = ReasonsData.fromJson(json);
      });
      _introController.forward();
    } catch (e) {
      setState(() {
        _error = 'Could not load reasons.json\n$e';
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _introController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _data == null) return KeyEventResult.ignored;
    final current = _pageController.page?.round() ?? 0;
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (current < _data!.reasons.length - 1) _goTo(current + 1);
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (current > 0) _goTo(current - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ),
      );
    }

    if (_data == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.accent,
          ),
        ),
      );
    }

    final reasons = _data!.reasons;
    final total = reasons.length;
    final currentIndex = _page.round().clamp(0, total - 1).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKey,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.background, AppColors.backgroundAlt],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                final cardHeight =
                    (constraints.maxHeight * 0.62).clamp(320.0, 560.0).toDouble();
                final cardMaxWidth = isWide ? 380.0 : constraints.maxWidth * 0.78;

                return FadeTransition(
                  opacity: _introFade,
                  child: SlideTransition(
                    position: _introSlide,
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        _Header(title: _data!.title, subtitle: _data!.subtitle),
                        const SizedBox(height: 10),
                        _ProgressBar(current: currentIndex, total: total),
                        const SizedBox(height: 6),
                        Text(
                          '${currentIndex + 1} / $total',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              height: cardHeight,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: total,
                                itemBuilder: (context, index) {
                                  final diff = (_page - index).abs().clamp(0.0, 1.0).toDouble();
                                  final scale = 1 - (diff * 0.18);
                                  final opacity = 1 - (diff * 0.55);
                                  final angle = (_page - index).clamp(-1.0, 1.0).toDouble() * 0.05;

                                  return Center(
                                    child: Transform.rotate(
                                      angle: angle,
                                      child: Transform.scale(
                                        scale: scale,
                                        child: Opacity(
                                          opacity: opacity.clamp(0.0, 1.0).toDouble(),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: cardMaxWidth,
                                            ),
                                            child: ReasonCard(
                                              reason: reasons[index],
                                              total: total,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _NavRow(
                          onPrev: currentIndex > 0
                              ? () => _goTo(currentIndex - 1)
                              : null,
                          onNext: currentIndex < total - 1
                              ? () => _goTo(currentIndex + 1)
                              : null,
                          onRestart: currentIndex == total - 1
                              ? () => _goTo(0)
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isWide
                              ? 'swipe, click the arrows, or use ← →'
                              : 'swipe left or right',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.75),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.favorite, color: AppColors.accent, size: 18),
          ],
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total <= 1 ? 1.0 : (current + 1) / total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 6,
          child: Stack(
            children: [
              Container(color: AppColors.secondarySoft),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0).toDouble()),
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: child,
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.accentSoft, AppColors.accent],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onRestart;

  const _NavRow({this.onPrev, this.onNext, this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundIconButton(icon: Icons.chevron_left, onTap: onPrev),
        const SizedBox(width: 20),
        if (onRestart != null)
          _PillButton(label: 'Start over', icon: Icons.replay, onTap: onRestart!)
        else
          const SizedBox(width: 8),
        const SizedBox(width: 20),
        _RoundIconButton(icon: Icons.chevron_right, onTap: onNext),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Material(
      color: enabled ? AppColors.secondary : AppColors.secondarySoft.withOpacity(0.5),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: enabled
                ? AppColors.accentDeep
                : AppColors.textSecondary.withOpacity(0.4),
            size: 24,
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.accent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.textOnAccent, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textOnAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
