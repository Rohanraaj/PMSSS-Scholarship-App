// Eligibility Evaluation & Scholarship Discovery Screen (Screen 4)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/eligibility_service.dart';
import '../../services/digilocker_service.dart';
import '../../services/application_service.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../widgets/scholarship_card.dart';

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isEvaluating = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _evaluateEligibility();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _evaluateEligibility() async {
    final eligibilityService = context.read<EligibilityService>();
    final digiLocker = context.read<DigiLockerService>();
    final appService = context.read<ApplicationService>();

    await eligibilityService.evaluateEligibility(
      instituteName: appService.instituteName,
      annualIncome: appService.annualIncome,
      umisId: appService.umisId,
      course: appService.course,
      documents: digiLocker.documents,
    );

    setState(() => _isEvaluating = false);
  }

  void _selectScholarship(String scholarshipId) {
    final eligibilityService = context.read<EligibilityService>();
    eligibilityService.selectScholarship(scholarshipId);
  }

  void _continueToConfirmation() {
    final eligibilityService = context.read<EligibilityService>();
    if (eligibilityService.selectedScholarshipId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a scholarship to continue'),
          backgroundColor: Color(AppColors.warning),
        ),
      );
      return;
    }
    Navigator.pushNamed(context, '/student/confirmation');
  }

  @override
  Widget build(BuildContext context) {
    final eligibilityService = context.watch<EligibilityService>();

    return Scaffold(
      backgroundColor: const Color(AppColors.backgroundLight),
      appBar: AppBar(
        title: const Text('Eligible Scholarships'),
        backgroundColor: const Color(AppColors.primaryStart),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Blue Header Extension
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              color: const Color(AppColors.primaryStart),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verification Step 3/6',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressIndicator(3),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(AppColors.backgroundLight),
                ),
                child: _isEvaluating
                    ? _buildEvaluatingState()
                    : _buildScholarshipsList(eligibilityService),
              ),
            ),

            // Bottom Action Bar
            if (!_isEvaluating && eligibilityService.eligibleScholarships.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (eligibilityService.selectedScholarshipId != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(AppColors.success).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(AppColors.success).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Color(AppColors.success),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Selected: ${eligibilityService.selectedScholarship?.name ?? ''}',
                                style: const TextStyle(
                                  color: Color(AppColors.success),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    GradientButton(
                      text: 'Proceed to Submit',
                      icon: Icons.arrow_forward,
                      onPressed: eligibilityService.selectedScholarshipId != null
                          ? _continueToConfirmation
                          : null,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluatingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AI Analysis Animation
          RotationTransition(
            turns: _animController,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: const Icon(
                Icons.psychology,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Evaluating Eligibility...',
            style: TextStyle(
              color: Color(AppColors.textDark),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our AI is analyzing your documents and profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 48),
          // Processing steps
          Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(AppColors.border)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildProcessingStep(Icons.document_scanner_outlined, 'Verifying documents', true),
                const SizedBox(height: 16),
                _buildProcessingStep(Icons.account_balance_outlined, 'Checking income criteria', true),
                const SizedBox(height: 16),
                _buildProcessingStep(Icons.school_outlined, 'Matching institutions', true),
                const SizedBox(height: 16),
                _buildProcessingStep(Icons.search, 'Finding eligible schemes', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingStep(IconData icon, String text, bool isComplete) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isComplete
                ? const Color(AppColors.success).withOpacity(0.1)
                : const Color(AppColors.primaryStart).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Icon(
            isComplete ? Icons.check : icon,
            color: isComplete
                ? const Color(AppColors.success)
                : const Color(AppColors.primaryStart),
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(
            color: isComplete
                ? const Color(AppColors.textDark)
                : const Color(AppColors.textMuted),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        if (!isComplete)
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(AppColors.primaryStart),
            ),
          ),
      ],
    );
  }

  Widget _buildScholarshipsList(EligibilityService eligibilityService) {
    final scholarships = eligibilityService.eligibleScholarships;

    if (scholarships.isEmpty) {
      return _buildNoScholarshipsState();
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(AppColors.success).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(AppColors.success).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified,
                  color: Color(AppColors.success),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Great News!',
                      style: TextStyle(
                        color: Color(AppColors.textDark),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'You\'re eligible for ${scholarships.length} scholarship(s)',
                      style: const TextStyle(
                        color: Color(AppColors.success),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Select ONE Scholarship',
          style: TextStyle(
            color: Color(AppColors.textDark),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Choose the scholarship you want to apply for',
          style: TextStyle(
            color: Color(AppColors.textMuted),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        // Scholarship cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scholarships.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final result = scholarships[index];
            return ScholarshipCard(
              scholarship: result.scholarship,
              eligibilityResult: result,
              isSelected: eligibilityService.selectedScholarshipId == result.scholarship.id,
              onTap: () => _selectScholarship(result.scholarship.id),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNoScholarshipsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(AppColors.warning).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: const Icon(
                Icons.search_off,
                size: 50,
                color: Color(AppColors.warning),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Eligible Scholarships Found',
              style: TextStyle(
                color: Color(AppColors.textDark),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Based on your profile and documents, we couldn\'t find matching scholarships. Please verify your information or contact support.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(AppColors.textMuted),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Go Back & Review',
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
              outlined: true,
            ),
          ],
        ),
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
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
