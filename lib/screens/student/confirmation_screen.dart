// Eligibility Confirmation Screen (Screen 5)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/eligibility_service.dart';
import '../../services/application_service.dart';
import '../../services/digilocker_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glassmorphic_card.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    setState(() => _isSubmitting = true);

    final authService = context.read<AuthService>();
    final eligibilityService = context.read<EligibilityService>();
    final digiLocker = context.read<DigiLockerService>();
    final appService = context.read<ApplicationService>();

    // Create and submit application
    await appService.createApplication(
      studentId: authService.currentUser?.id ?? 'STU001',
      studentName: authService.currentUser?.name ?? 'Student',
      scholarshipId: eligibilityService.selectedScholarship?.id ?? '',
      scholarshipName: eligibilityService.selectedScholarship?.name ?? '',
      documents: digiLocker.documents,
    );

    await appService.submitApplication();

    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
    });

    _animController.forward();
  }

  void _goToTracking() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/student/tracking',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final eligibilityService = context.watch<EligibilityService>();
    final scholarship = eligibilityService.selectedScholarship;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: _isSubmitted
                ? _buildSuccessState()
                : _buildConfirmationState(scholarship),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationState(scholarship) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Color(AppColors.textDark)),
            ),
            const Expanded(
              child: Text(
                'Confirm & Submit',
                style: TextStyle(
                  color: Color(AppColors.textDark),
                  fontSize: AppSizes.fontXl,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        // Progress
        _buildProgressIndicator(4),
        const SizedBox(height: AppSizes.xl),
        // Eligibility confirmation card
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Success Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(AppColors.success).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: const Icon(
                    Icons.verified,
                    size: 40,
                    color: Color(AppColors.success),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                // Eligibility message
                const Text(
                  'You are eligible to apply for',
                  style: TextStyle(
                    color: Color(AppColors.textMuted),
                    fontSize: AppSizes.fontMd,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  scholarship?.name ?? 'Selected Scholarship',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(AppColors.textDark),
                    fontSize: AppSizes.fontXl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.xl),
                // Summary card
                GlassmorphicCard(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Application Summary',
                        style: TextStyle(
                          color: Color(AppColors.textDark),
                          fontSize: AppSizes.fontLg,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                      _buildSummaryRow('Scholarship', scholarship?.name ?? '-'),
                      _buildSummaryRow('Amount', scholarship?.formattedAmount ?? '-'),
                      _buildSummaryRow('Duration', scholarship?.duration ?? '-'),
                      _buildSummaryRow('Documents', '4 verified via DigiLocker'),
                      _buildSummaryRow('Status', 'Ready for submission'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                // Warning
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: const Color(AppColors.warning).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    border: Border.all(
                      color: const Color(AppColors.warning).withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Color(AppColors.warning)),
                      SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          'Once submitted, your application cannot be edited. Please verify all details before proceeding.',
                          style: TextStyle(
                            color: Color(AppColors.warning),
                            fontSize: AppSizes.fontSm,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        // Submit button
        GradientButton(
          text: 'Submit Application',
          icon: Icons.send,
          onPressed: _submitApplication,
          isLoading: _isSubmitting,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated success icon
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(AppColors.success), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: const Color(AppColors.success).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.check,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        const Text(
          'Application Submitted!',
          style: TextStyle(
            color: Color(AppColors.textDark),
            fontSize: AppSizes.fontXxl,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        const Text(
          'Your application has been submitted successfully and is now in the SAG Officer\'s queue for review.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(AppColors.textMuted),
            fontSize: AppSizes.fontMd,
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        // Application ID
        GlassmorphicCard(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long, color: Color(AppColors.primaryStart)),
              const SizedBox(width: AppSizes.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application ID',
                    style: TextStyle(
                      color: Color(AppColors.textMuted),
                      fontSize: AppSizes.fontXs,
                    ),
                  ),
                  Text(
                    'APP${DateTime.now().year}${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    style: const TextStyle(
                      color: Color(AppColors.textDark),
                      fontSize: AppSizes.fontMd,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.xxl),
        GradientButton(
          text: 'Track Your Application',
          icon: Icons.track_changes,
          onPressed: _goToTracking,
          width: double.infinity,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Widget _buildProgressIndicator(int currentStep) {
    return Row(
      children: List.generate(6, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < 5 ? 4 : 0),
            height: 4,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(AppColors.primaryStart)
                  : const Color(AppColors.glassBorder),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
