// SAG Officer Dashboard Screen
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
import '../../widgets/document_card.dart';
import '../../widgets/document_example_dialog.dart';

class SagDashboardScreen extends StatefulWidget {
  const SagDashboardScreen({super.key});

  @override
  State<SagDashboardScreen> createState() => _SagDashboardScreenState();
}

class _SagDashboardScreenState extends State<SagDashboardScreen> {
  String _sortBy = 'riskScore';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadApplications();
    });
  }

  Future<void> _loadApplications() async {
    final appService = context.read<ApplicationService>();
    await appService.loadPendingApplications();
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
    
    List<ScholarshipApplication> applications = List.from(appService.applications);
    
    // Sort applications
    if (_sortBy == 'riskScore') {
      applications.sort((a, b) => (b.riskScore ?? 0).compareTo(a.riskScore ?? 0));
    } else {
      applications.sort((a, b) => (b.submittedAt ?? DateTime.now())
          .compareTo(a.submittedAt ?? DateTime.now()));
    }

    return Scaffold(
      backgroundColor: const Color(AppColors.backgroundLight),
      body: Column(
        children: [
          // Blue Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: AppTheme.blueHeaderGradient,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.verified_user_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authService.currentUser?.name ?? 'SAG Officer',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Verification Officer',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Quick Stats Row inside header area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _buildHeaderStat('Pending', '${applications.length}'),
                      const SizedBox(width: 12),
                      _buildHeaderStat('High Risk', '${applications.where((a) => (a.riskScore ?? 0) > 50).length}'),
                      const SizedBox(width: 12),
                      _buildHeaderStat('Today', '12'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(AppColors.backgroundLight),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  // Sort & Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Queue for Review',
                          style: TextStyle(
                            color: Color(AppColors.textDark),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Text(
                              'Sort:',
                              style: TextStyle(
                                color: Color(AppColors.textMuted),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildSortChip('Risk', 'riskScore'),
                            const SizedBox(width: 4),
                            _buildSortChip('Date', 'date'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Applications List
                  Expanded(
                    child: appService.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : applications.isEmpty
                            ? _buildEmptyState()
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                itemCount: applications.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  return _buildApplicationCard(applications[index]);
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSizes.xs),
          Text(
            value,
            style: const TextStyle(
              color: Color(AppColors.textDark),
              fontSize: AppSizes.fontXl,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: AppSizes.fontXs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(AppColors.primaryStart).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(
            color: isSelected
                ? const Color(AppColors.primaryStart)
                : const Color(AppColors.glassBorder),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(AppColors.primaryStart)
                : const Color(AppColors.textMuted),
            fontSize: AppSizes.fontSm,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Color(AppColors.success)),
          SizedBox(height: AppSizes.md),
          Text(
            'All Caught Up!',
            style: TextStyle(
              color: Color(AppColors.textDark),
              fontSize: AppSizes.fontLg,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'No pending applications to review',
            style: TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: AppSizes.fontSm,
            ),
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.studentName,
                      style: const TextStyle(
                        color: Color(AppColors.textDark),
                        fontSize: AppSizes.fontMd,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      application.scholarshipName,
                      style: const TextStyle(
                        color: Color(AppColors.textMuted),
                        fontSize: AppSizes.fontSm,
                      ),
                    ),
                  ],
                ),
              ),
              if (application.riskScore != null)
                RiskChip(riskScore: application.riskScore!),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              _buildInfoChip(Icons.school, application.instituteName),
              const SizedBox(width: AppSizes.sm),
              _buildInfoChip(Icons.currency_rupee, '₹${application.annualFamilyIncome.toStringAsFixed(0)}'),
            ],
          ),
          if (application.aiDecision != null) ...[
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: _getAiDecisionColor(application.aiDecision!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.psychology,
                    size: 16,
                    color: _getAiDecisionColor(application.aiDecision!),
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Text(
                      'AI: ${application.aiDecision}',
                      style: TextStyle(
                        color: _getAiDecisionColor(application.aiDecision!),
                        fontSize: AppSizes.fontXs,
                        fontWeight: FontWeight.w500,
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

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: const Color(AppColors.glassBackground),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(AppColors.textMuted)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: AppSizes.fontXs,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getAiDecisionColor(String decision) {
    if (decision.contains('APPROVAL') || decision.contains('APPROVED')) {
      return const Color(AppColors.success);
    } else if (decision.contains('FLAGGED') || decision.contains('REJECTED')) {
      return const Color(AppColors.error);
    }
    return const Color(AppColors.warning);
  }

  void _showApplicationDetails(ScholarshipApplication application) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ApplicationDetailSheet(application: application),
    );
  }
}

// Application Detail Sheet for SAG Officer
class _ApplicationDetailSheet extends StatefulWidget {
  final ScholarshipApplication application;

  const _ApplicationDetailSheet({required this.application});

  @override
  State<_ApplicationDetailSheet> createState() => _ApplicationDetailSheetState();
}

class _ApplicationDetailSheetState extends State<_ApplicationDetailSheet> {
  final _rejectionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _rejectionController.dispose();
    super.dispose();
  }

  Future<void> _approveApplication() async {
    setState(() => _isLoading = true);
    
    final authService = context.read<AuthService>();
    final appService = context.read<ApplicationService>();
    
    await appService.approveApplication(
      widget.application.id,
      authService.currentUser?.id ?? 'SAG001',
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application approved! Payment workflow triggered.'),
          backgroundColor: Color(AppColors.success),
        ),
      );
    }
  }

  Future<void> _rejectApplication() async {
    if (_rejectionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a reason for rejection'),
          backgroundColor: Color(AppColors.error),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final authService = context.read<AuthService>();
    final appService = context.read<ApplicationService>();
    
    await appService.rejectApplication(
      widget.application.id,
      authService.currentUser?.id ?? 'SAG001',
      _rejectionController.text,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Application rejected.'),
          backgroundColor: Color(AppColors.error),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(AppColors.border),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.application.studentName,
                        style: const TextStyle(
                          color: Color(AppColors.textDark),
                          fontSize: AppSizes.fontXl,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.application.id,
                        style: const TextStyle(
                          color: Color(AppColors.textMuted),
                          fontSize: AppSizes.fontSm,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.application.riskScore != null)
                  RiskChip(riskScore: widget.application.riskScore!),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            // Application details
            GlassmorphicCard(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Details',
                    style: TextStyle(
                      color: Color(AppColors.textDark),
                      fontSize: AppSizes.fontMd,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  _buildDetailRow('Scholarship', widget.application.scholarshipName),
                  _buildDetailRow('Institute', widget.application.instituteName),
                  _buildDetailRow('Course', widget.application.course ?? '-'),
                  _buildDetailRow('UMIS ID', widget.application.umisId),
                  _buildDetailRow('Family Income', '₹${widget.application.annualFamilyIncome.toStringAsFixed(0)}'),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            // AI Analysis
            if (widget.application.aiExplanation != null)
              GlassmorphicCard(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology, color: Color(AppColors.primaryStart)),
                        const SizedBox(width: AppSizes.sm),
                        const Text(
                          'AI Analysis',
                          style: TextStyle(
                            color: Color(AppColors.textDark),
                            fontSize: AppSizes.fontMd,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(
                        color: _getAiDecisionColor(widget.application.aiDecision ?? '').withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        widget.application.aiDecision ?? '',
                        style: TextStyle(
                          color: _getAiDecisionColor(widget.application.aiDecision ?? ''),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      widget.application.aiExplanation!,
                      style: const TextStyle(
                        color: Color(AppColors.textMuted),
                        fontSize: AppSizes.fontSm,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSizes.md),
            // Documents
            const Text(
              'DigiLocker Documents',
              style: TextStyle(
                color: Color(AppColors.textDark),
                fontSize: AppSizes.fontMd,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            ...widget.application.documents.map((doc) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: DocumentCard(
                document: doc,
                onNameTap: () => _showDocumentExample(doc.documentName),
              ),
            )),
            const SizedBox(height: AppSizes.lg),
            // Rejection reason input
            const Text(
              'Rejection Reason (if rejecting)',
              style: TextStyle(
                color: Color(AppColors.textMuted),
                fontSize: AppSizes.fontSm,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(AppColors.border)),
              ),
              child: TextField(
                controller: _rejectionController,
                maxLines: 3,
                style: const TextStyle(color: Color(AppColors.textDark), fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Enter reason for rejection...',
                  hintStyle: TextStyle(color: Color(AppColors.textMuted)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'Reject',
                    icon: Icons.close,
                    onPressed: _isLoading ? null : _rejectApplication,
                    isLoading: _isLoading,
                    gradientColors: const [Color(AppColors.error), Color(0xFFB91C1C)],
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: GradientButton(
                    text: 'Approve',
                    icon: Icons.check,
                    onPressed: _isLoading ? null : _approveApplication,
                    isLoading: _isLoading,
                    gradientColors: const [Color(AppColors.success), Color(0xFF059669)],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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

  Color _getAiDecisionColor(String decision) {
    if (decision.contains('APPROVAL') || decision.contains('APPROVED')) {
      return const Color(AppColors.success);
    } else if (decision.contains('FLAGGED') || decision.contains('REJECTED')) {
      return const Color(AppColors.error);
    }
    return const Color(AppColors.warning);
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
}
