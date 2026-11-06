// Status Chip Widget for Application Status
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/application.dart';

class StatusChip extends StatelessWidget {
  final ApplicationStatus status;
  final bool showIcon;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.status,
    this.showIcon = true,
    this.fontSize = AppSizes.fontSm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              _getIcon(),
              color: _getTextColor(),
              size: 14,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            _getStatusText(),
            style: TextStyle(
              color: _getTextColor(),
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (status) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.paymentTriggered:
        return 'Payment Processing';
      case ApplicationStatus.paymentCompleted:
        return 'Completed';
    }
  }

  IconData _getIcon() {
    switch (status) {
      case ApplicationStatus.draft:
        return Icons.edit_outlined;
      case ApplicationStatus.submitted:
        return Icons.send_outlined;
      case ApplicationStatus.underReview:
        return Icons.hourglass_top_outlined;
      case ApplicationStatus.approved:
        return Icons.check_circle_outline;
      case ApplicationStatus.rejected:
        return Icons.cancel_outlined;
      case ApplicationStatus.paymentTriggered:
        return Icons.payment_outlined;
      case ApplicationStatus.paymentCompleted:
        return Icons.verified_outlined;
    }
  }

  Color _getBackgroundColor() {
    switch (status) {
      case ApplicationStatus.draft:
        return const Color(AppColors.textMuted).withOpacity(0.1);
      case ApplicationStatus.submitted:
        return const Color(AppColors.info).withOpacity(0.1);
      case ApplicationStatus.underReview:
        return const Color(AppColors.warning).withOpacity(0.1);
      case ApplicationStatus.approved:
        return const Color(AppColors.success).withOpacity(0.1);
      case ApplicationStatus.rejected:
        return const Color(AppColors.error).withOpacity(0.1);
      case ApplicationStatus.paymentTriggered:
        return const Color(AppColors.primaryStart).withOpacity(0.1);
      case ApplicationStatus.paymentCompleted:
        return const Color(AppColors.success).withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (status) {
      case ApplicationStatus.draft:
        return const Color(AppColors.textMuted).withOpacity(0.3);
      case ApplicationStatus.submitted:
        return const Color(AppColors.info).withOpacity(0.3);
      case ApplicationStatus.underReview:
        return const Color(AppColors.warning).withOpacity(0.3);
      case ApplicationStatus.approved:
        return const Color(AppColors.success).withOpacity(0.3);
      case ApplicationStatus.rejected:
        return const Color(AppColors.error).withOpacity(0.3);
      case ApplicationStatus.paymentTriggered:
        return const Color(AppColors.primaryStart).withOpacity(0.3);
      case ApplicationStatus.paymentCompleted:
        return const Color(AppColors.success).withOpacity(0.3);
    }
  }

  Color _getTextColor() {
    switch (status) {
      case ApplicationStatus.draft:
        return const Color(AppColors.textMuted);
      case ApplicationStatus.submitted:
        return const Color(AppColors.info);
      case ApplicationStatus.underReview:
        return const Color(AppColors.warning);
      case ApplicationStatus.approved:
        return const Color(AppColors.success);
      case ApplicationStatus.rejected:
        return const Color(AppColors.error);
      case ApplicationStatus.paymentTriggered:
        return const Color(AppColors.primaryStart);
      case ApplicationStatus.paymentCompleted:
        return const Color(AppColors.success);
    }
  }
}

// Risk Level Chip
class RiskChip extends StatelessWidget {
  final double riskScore;

  const RiskChip({super.key, required this.riskScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIcon(),
            color: _getTextColor(),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            _getRiskLevel(),
            style: TextStyle(
              color: _getTextColor(),
              fontSize: AppSizes.fontSm,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getRiskLevel() {
    if (riskScore < 20) return 'Low Risk';
    if (riskScore < 50) return 'Medium Risk';
    return 'High Risk';
  }

  IconData _getIcon() {
    if (riskScore < 20) return Icons.verified_outlined;
    if (riskScore < 50) return Icons.warning_outlined;
    return Icons.error_outline;
  }

  Color _getBackgroundColor() {
    if (riskScore < 20) return const Color(AppColors.success).withOpacity(0.1);
    if (riskScore < 50) return const Color(AppColors.warning).withOpacity(0.1);
    return const Color(AppColors.error).withOpacity(0.1);
  }

  Color _getTextColor() {
    if (riskScore < 20) return const Color(AppColors.success);
    if (riskScore < 50) return const Color(AppColors.warning);
    return const Color(AppColors.error);
  }
}
