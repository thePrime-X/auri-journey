import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/neon_card.dart';

class JourneyMapCard extends StatelessWidget {
  const JourneyMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonCard(
      padding: EdgeInsets.zero,
      backgroundColor: AppColors.bg3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CIRCUIT JOURNEY',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Explore sectors',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.bg4,
            ),
            child: const Center(
              child: Text(
                'Journey Map Placeholder',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.12),
              border: Border(
                top: BorderSide(color: AppColors.border.withValues(alpha: 0.4)),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT LOCATION',
                        style: TextStyle(
                          color: AppColors.cyan,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Conditional Forest',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: null, child: Text('Continue →')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
