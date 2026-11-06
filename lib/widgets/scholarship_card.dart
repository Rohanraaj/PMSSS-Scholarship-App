// Scholarship Card Widget
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/scholarship.dart';
import '../services/eligibility_service.dart';
import 'glassmorphic_card.dart';

class ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;
  final EligibilityResult? eligibilityResult;
  final bool isSelected;
  final VoidCallback? onTap;

  const ScholarshipCard({
    super.key,
    required this.scholarship,
    this.eligibilityResult,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: GlassmorphicCard(
        onTap: onTap,
        borderColor: isSelected
            ? const Color(AppColors.success)
            : const Color(AppColors.glassBorder),
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with selection indicator
            Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(AppColors.primaryStart),
                        Color(AppColors.primaryEnd),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scholarship.name,
                        style: const TextStyle(
                          color: Color(AppColors.textDark),
                          fontSize: AppSizes.fontMd,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (eligibilityResult != null)
                        _buildMatchScore(eligibilityResult!.matchScore),
                    ],
                  ),
                ),
                // Selection checkbox
                if (isSelected)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(AppColors.success),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            // Amount and Duration
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.currency_rupee,
                  label: scholarship.formattedAmount,
                  color: const Color(AppColors.success),
                ),
                const SizedBox(width: AppSizes.sm),
                _buildInfoChip(
                  icon: Icons.access_time,
                  label: scholarship.duration,
                  color: const Color(AppColors.info),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            // Description
            Text(
              scholarship.description,
              style: const TextStyle(
                color: Color(AppColors.textMuted),
                fontSize: AppSizes.fontSm,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Eligibility reasons
            if (eligibilityResult != null) ...[
              const SizedBox(height: AppSizes.md),
              const Divider(color: Color(AppColors.glassBorder)),
              const SizedBox(height: AppSizes.sm),
              ...eligibilityResult!.eligibilityReasons.take(3).map((reason) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Color(AppColors.success),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          reason.replaceAll('✓ ', ''),
                          style: const TextStyle(
                            color: Color(AppColors.textMuted),
                            fontSize: AppSizes.fontXs,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMatchScore(double score) {
    Color color;
    if (score >= 80) {
      color = const Color(AppColors.success);
    } else if (score >= 60) {
      color = const Color(AppColors.warning);
    } else {
      color = const Color(AppColors.error);
    }

    return Row(
      children: [
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(AppColors.surfaceDark),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: score / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${score.toInt()}% Match',
          style: TextStyle(
            color: color,
            fontSize: AppSizes.fontXs,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: AppSizes.fontXs,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
