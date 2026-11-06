// Application Tracking Screen (Screen 6)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/application_service.dart';
import '../../services/auth_service.dart';
import '../../models/application.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../widgets/status_chip.dart';
import '../../widgets/gradient_button.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadApplications();
    });
  }

  Future<void> _loadApplications() async {
    final authService = context.read<AuthService>();
    final appService = context.read<ApplicationService>();
    await appService.loadApplicationsForStudent(authService.currentUser?.id ?? 'STU001');
  }

  void _logout() async {
    final authService = context.read<AuthService>();
    await authService.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final appService = context.watch<ApplicationService>();
    final applications = appService.applications;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Center(
                        child: Text(
                          (authService.currentUser?.name ?? 'S')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: AppSizes.fontLg,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authService.currentUser?.name ?? 'Student',
                            style: const TextStyle(
                              color: Color(AppColors.textDark),
                              fontSize: AppSizes.fontMd,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Application Tracking',
                            style: TextStyle(
                              color: Color(AppColors.textMuted),
                              fontSize: AppSizes.fontSm,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Color(AppColors.textMuted)),
                    ),
                  ],
                ),
              ),
              // Applications list
              Expanded(
                child: appService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : applications.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.all(AppSizes.lg),
                            itemCount: applications.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
                            itemBuilder: (context, index) {
                              return _buildApplicationCard(applications[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Color(AppColors.textMuted),
          ),
          const SizedBox(height: AppSizes.md),
          const Text(
            'No Applications Yet',
            style: TextStyle(
              color: Color(AppColors.textDark),
              fontSize: AppSizes.fontLg,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          const Text(
            'Start a new application to track its progress here',
            style: TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: AppSizes.fontSm,
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          GradientButton(
            text: 'Start New Application',
            icon: Icons.add,
            onPressed: () => Navigator.pushNamed(context, '/student/basic-details'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(ScholarshipApplication application) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(AppSizes.md),
      onTap: () => _showApplicationDetails(application),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 24),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.scholarshipName,
                      style: const TextStyle(
                        color: Color(AppColors.textDark),
                        fontSize: AppSizes.fontMd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${application.id}',
                      style: const TextStyle(
                        color: Color(AppColors.textMuted),
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(status: application.status),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          // Timeline
          _buildTimeline(application),
          // Payment info if applicable
          if (application.status == ApplicationStatus.paymentTriggered ||
              application.status == ApplicationStatus.paymentCompleted) ...[
            const Divider(color: Color(AppColors.glassBorder)),
            _buildPaymentInfo(application),
          ],
          // Rejection reason if applicable
          if (application.isRejected && application.rejectionReason != null) ...[
            const Divider(color: Color(AppColors.glassBorder)),
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: const Color(AppColors.error).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(AppColors.error), size: 16),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      application.rejectionReason!,
                      style: const TextStyle(
                        color: Color(AppColors.error),
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeline(ScholarshipApplication application) {
    final steps = [
      _TimelineStep(
        title: 'Submitted',
        subtitle: application.submittedAt != null
            ? _formatDate(application.submittedAt!)
            : 'Pending',
        isComplete: application.submittedAt != null,
        isActive: application.status == ApplicationStatus.submitted,
      ),
      _TimelineStep(
        title: 'Under Review',
        subtitle: application.isUnderReview ? 'In progress' : 'Waiting',
        isComplete: application.status.index > ApplicationStatus.submitted.index,
        isActive: application.status == ApplicationStatus.underReview,
      ),
      _TimelineStep(
        title: application.isRejected ? 'Rejected' : 'Approved',
        subtitle: application.reviewedAt != null
            ? _formatDate(application.reviewedAt!)
            : 'Pending',
        isComplete: application.isApproved || application.isRejected,
        isActive: application.isApproved || application.isRejected,
        isError: application.isRejected,
      ),
      _TimelineStep(
        title: 'Payment',
        subtitle: application.status == ApplicationStatus.paymentTriggered
            ? 'Processing'
            : application.status == ApplicationStatus.paymentCompleted
                ? 'Completed'
                : 'Pending',
        isComplete: application.status == ApplicationStatus.paymentCompleted,
        isActive: application.status == ApplicationStatus.paymentTriggered,
      ),
    ];

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: step.isComplete
                            ? step.isError
                                ? const Color(AppColors.error)
                                : const Color(AppColors.success)
                            : step.isActive
                                ? const Color(AppColors.primaryStart)
                                : const Color(AppColors.glassBorder),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step.isComplete
                            ? step.isError
                                ? Icons.close
                                : Icons.check
                            : step.isActive
                                ? Icons.hourglass_top
                                : Icons.circle,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step.title,
                      style: TextStyle(
                        color: step.isComplete || step.isActive
                            ? const Color(AppColors.textDark)
                            : const Color(AppColors.textMuted),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      step.subtitle,
                      style: const TextStyle(
                        color: Color(AppColors.textMuted),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 24),
                    color: step.isComplete
                        ? const Color(AppColors.success)
                        : const Color(AppColors.glassBorder),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaymentInfo(ScholarshipApplication application) {
    return Row(
      children: [
        const Icon(Icons.payment, color: Color(AppColors.success), size: 20),
        const SizedBox(width: AppSizes.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Processing',
                style: TextStyle(
                  color: Color(AppColors.success),
                  fontSize: AppSizes.fontSm,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (application.paymentDetails != null)
                Text(
                  'Transaction ID: ${application.paymentDetails!['transactionId']}',
                  style: const TextStyle(
                    color: Color(AppColors.textMuted),
                    fontSize: AppSizes.fontXs,
                  ),
                ),
            ],
          ),
        ),
        if (application.paymentDetails != null)
          Text(
            '₹${application.paymentDetails!['amount']}',
            style: const TextStyle(
              color: Color(AppColors.success),
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  void _showApplicationDetails(ScholarshipApplication application) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(AppColors.surfaceDark),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(AppColors.glassBorder),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                application.scholarshipName,
                style: const TextStyle(
                  color: Color(AppColors.textDark),
                  fontSize: AppSizes.fontXl,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              StatusChip(status: application.status),
              const SizedBox(height: AppSizes.lg),
              _buildDetailRow('Application ID', application.id),
              _buildDetailRow('Institute', application.instituteName),
              _buildDetailRow('Course', application.course ?? '-'),
              _buildDetailRow('UMIS ID', application.umisId),
              _buildDetailRow('Family Income', '₹${application.annualFamilyIncome.toStringAsFixed(0)}'),
              if (application.aiDecision != null)
                _buildDetailRow('AI Decision', application.aiDecision!),
              if (application.aiExplanation != null) ...[
                const SizedBox(height: AppSizes.md),
                const Text(
                  'AI Analysis',
                  style: TextStyle(
                    color: Color(AppColors.textMuted),
                    fontSize: AppSizes.fontSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  application.aiExplanation!,
                  style: const TextStyle(
                    color: Color(AppColors.textDark),
                    fontSize: AppSizes.fontSm,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(AppColors.textMuted),
                fontSize: AppSizes.fontSm,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(AppColors.textDark),
                fontSize: AppSizes.fontSm,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _TimelineStep {
  final String title;
  final String subtitle;
  final bool isComplete;
  final bool isActive;
  final bool isError;

  _TimelineStep({
    required this.title,
    required this.subtitle,
    this.isComplete = false,
    this.isActive = false,
    this.isError = false,
  });
}
