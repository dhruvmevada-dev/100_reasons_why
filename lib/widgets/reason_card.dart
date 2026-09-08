import 'package:flutter/material.dart';
import '../models/reason.dart';
import '../theme/app_theme.dart';

class ReasonCard extends StatelessWidget {
  final Reason reason;
  final int total;

  const ReasonCard({
    super.key,
    required this.reason,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isSpecial = reason.special;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSpecial
              ? [AppColors.accentSoft, AppColors.accentDeep]
              : [AppColors.secondarySoft, AppColors.secondary],
        ),
        boxShadow: [
          BoxShadow(
            color: (isSpecial ? AppColors.accentDeep : AppColors.secondaryDeep)
                .withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 18),
            spreadRadius: -12,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Watermark number in the background
          Positioned(
            right: -10,
            bottom: -20,
            child: Text(
              '#${reason.number.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 130,
                fontWeight: FontWeight.w800,
                fontFamily: 'Georgia',
                color: (isSpecial ? AppColors.textOnAccent : AppColors.accent)
                    .withOpacity(0.12),
                height: 1,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: small number chip + heart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (isSpecial
                                ? AppColors.textOnAccent
                                : AppColors.accent)
                            .withOpacity(isSpecial ? 0.22 : 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '#${reason.number.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: isSpecial
                              ? AppColors.textOnAccent
                              : AppColors.accentDeep,
                        ),
                      ),
                    ),
                    Icon(
                      isSpecial ? Icons.favorite : Icons.favorite_border,
                      color: isSpecial
                          ? AppColors.textOnAccent
                          : AppColors.accent.withOpacity(0.55),
                      size: 22,
                    ),
                  ],
                ),

                // Main reason text, centered visually
                Expanded(
                  child: Center(
                    child: Text(
                      reason.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isSpecial ? 26 : 21,
                        fontWeight: isSpecial ? FontWeight.w700 : FontWeight.w500,
                        height: 1.45,
                        color: isSpecial
                            ? AppColors.textOnAccent
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                // Bottom label
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    isSpecial ? 'the last one' : 'reason ${reason.number} of $total',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isSpecial
                          ? AppColors.textOnAccent.withOpacity(0.85)
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
