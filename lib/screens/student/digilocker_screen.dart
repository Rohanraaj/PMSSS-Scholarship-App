// DigiLocker Document Fetch Screen (Screen 3)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/digilocker_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../widgets/document_card.dart';
import '../../widgets/document_example_dialog.dart';

class DigiLockerScreen extends StatefulWidget {
  const DigiLockerScreen({super.key});

  @override
  State<DigiLockerScreen> createState() => _DigiLockerScreenState();
}

class _DigiLockerScreenState extends State<DigiLockerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isConsenting = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _initiateDigiLocker() async {
    setState(() => _isConsenting = true);

    final digiLocker = context.read<DigiLockerService>();
    await digiLocker.initiateConsent();

    if (digiLocker.isAuthenticated) {
      final authService = context.read<AuthService>();
      await digiLocker.fetchDocuments(authService.currentUser?.id ?? 'STU001');
    }

    setState(() => _isConsenting = false);
  }

  void _continueToEligibility() {
    Navigator.pushNamed(context, '/student/eligibility');
  }

  @override
  Widget build(BuildContext context) {
    final digiLocker = context.watch<DigiLockerService>();

    return Scaffold(
      backgroundColor: const Color(AppColors.backgroundLight),
      appBar: AppBar(
        title: const Text('DigiLocker Documents'),
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
                    'Verification Step 2/6',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressIndicator(2),
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
                child: digiLocker.hasDocuments
                    ? _buildDocumentsList(digiLocker)
                    : _buildInitialState(digiLocker),
              ),
            ),
            
            // Bottom Action Bar
            if (digiLocker.hasDocuments)
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
                child: GradientButton(
                  text: 'Continue to Eligibility Check',
                  icon: Icons.arrow_forward,
                  onPressed: _continueToEligibility,
                  width: double.infinity,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(DigiLockerService digiLocker) {
    if (digiLocker.status == DigiLockerStatus.fetchingDocuments) {
      return _buildFetchingState(digiLocker);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // DigiLocker Logo/Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF0066B3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF0066B3).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.folder_shared,
              size: 50,
              color: Color(0xFF0066B3),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Connect DigiLocker',
            style: TextStyle(
              color: Color(AppColors.textDark),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ll automatically fetch your documents from DigiLocker to verify your eligibility.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          // Documents to fetch
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(AppColors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Documents to be fetched:',
                  style: TextStyle(
                    color: Color(AppColors.textDark),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDocumentItem(Icons.badge_outlined, 'Aadhaar Card'),
                const Divider(height: 24),
                _buildDocumentItem(Icons.receipt_long_outlined, 'Income Certificate'),
                const Divider(height: 24),
                _buildDocumentItem(Icons.school_outlined, 'Academic Certificates'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Connect button
          GradientButton(
            text: 'Authorize & Fetch Documents',
            icon: Icons.lock_open,
            onPressed: _initiateDigiLocker,
            isLoading: _isConsenting,
            width: double.infinity,
            gradientColors: const [Color(0xFF0066B3), Color(0xFF004C8C)],
          ),
          const SizedBox(height: 16),
          // Security note
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.security,
                size: 14,
                color: Color(AppColors.textMuted),
              ),
              const SizedBox(width: 4),
              const Text(
                'Secured by Government of India',
                style: TextStyle(
                  color: Color(AppColors.textMuted),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFetchingState(DigiLockerService digiLocker) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loader
          RotationTransition(
            turns: _animController,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: const Icon(
                Icons.sync,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Fetching Documents...',
            style: TextStyle(
              color: Color(AppColors.textDark),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(digiLocker.fetchProgress * 100).toInt()}% Complete',
            style: const TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          // Progress bar
          Container(
            width: 200,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(AppColors.border),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: digiLocker.fetchProgress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(DigiLockerService digiLocker) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Success banner
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
              const Icon(Icons.check_circle, color: Color(AppColors.success)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Documents Fetched Successfully',
                      style: TextStyle(
                        color: Color(AppColors.success),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${digiLocker.documents.length} documents retrieved from DigiLocker',
                      style: TextStyle(
                        color: const Color(AppColors.success).withOpacity(0.8),
                        fontSize: 12,
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
          'Your Documents',
          style: TextStyle(
            color: Color(AppColors.textDark),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'These documents will be used for eligibility verification (Read-only)',
          style: TextStyle(
            color: Color(AppColors.textMuted),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        // Document cards
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: digiLocker.documents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final doc = digiLocker.documents[index];
            return DocumentCard(
              document: doc,
              onTap: () => _showDocumentDetails(doc),
              onNameTap: () => _showDocumentExample(doc.documentName),
            );
          },
        ),
        const SizedBox(height: 24),
        // Warning about no upload
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(AppColors.warning).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(AppColors.warning), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Manual document upload is not allowed. All documents are fetched directly from DigiLocker.',
                  style: TextStyle(
                    color: Color(AppColors.warning),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(IconData icon, String name) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(AppColors.primaryStart).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(AppColors.primaryStart), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => _showDocumentExample(name),
            child: Text(
              name,
              style: const TextStyle(
                color: Color(AppColors.primaryStart),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        const Icon(
          Icons.lock_outline,
          color: Color(AppColors.textMuted),
          size: 16,
        ),
      ],
    );
  }

  void _showDocumentExample(String docName) {
    String imagePath;
    if (docName.contains('Aadhaar')) {
      imagePath = 'assets/images/examples/aadhaar_example.png';
    } else if (docName.contains('Income')) {
      imagePath = 'assets/images/examples/income_example.png';
    } else if (docName.contains('Caste')) {
      imagePath = 'assets/images/examples/caste_example.png';
    } else if (docName.contains('Academic') || docName.contains('Marksheet')) {
      imagePath = 'assets/images/examples/academic_example.png';
    } else {
      imagePath = 'assets/images/examples/default_example.png';
    }

    showDialog(
      context: context,
      builder: (context) => DocumentExampleDialog(
        title: docName,
        imagePath: imagePath,
      ),
    );
  }

  void _showDocumentDetails(document) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: DocumentDetailCard(document: document),
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
