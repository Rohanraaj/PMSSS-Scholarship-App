// Student Basic Details Screen (Screen 2)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/application_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../widgets/common_widgets.dart';

class BasicDetailsScreen extends StatefulWidget {
  const BasicDetailsScreen({super.key});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _instituteController = TextEditingController();
  final _incomeController = TextEditingController();
  final _umisController = TextEditingController();
  final _courseController = TextEditingController();
  
  bool _isLoading = false;
  bool _isUmisValid = false;
  String? _umisError;

  @override
  void dispose() {
    _instituteController.dispose();
    _incomeController.dispose();
    _umisController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _validateUmis() async {
    if (_umisController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _umisError = null;
    });

    final appService = context.read<ApplicationService>();
    final isValid = await appService.validateUmisId(_umisController.text);

    setState(() {
      _isLoading = false;
      _isUmisValid = isValid;
      if (!isValid) {
        _umisError = 'Invalid UMIS ID format. Must start with "UMIS"';
      }
    });
  }

  void _saveAndContinue() {
    if (!_formKey.currentState!.validate()) return;
    if (!_isUmisValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your UMIS ID first'),
          backgroundColor: Color(AppColors.error),
        ),
      );
      return;
    }

    final appService = context.read<ApplicationService>();
    appService.setInstituteName(_instituteController.text);
    appService.setAnnualIncome(double.parse(_incomeController.text));
    appService.setUmisId(_umisController.text);
    appService.setCourse(_courseController.text);

    Navigator.pushNamed(context, '/student/digilocker');
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final userName = authService.currentUser?.name ?? 'Student';

    return Scaffold(
      backgroundColor: const Color(AppColors.backgroundLight),
      appBar: AppBar(
        title: const Text('Basic Details'),
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
                    'Application Step 1/6',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressIndicator(0),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  userName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, $userName!',
                                    style: const TextStyle(
                                      color: Color(AppColors.textDark),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    'Let\'s complete your profile',
                                    style: TextStyle(
                                      color: Color(AppColors.textMuted),
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

                      // Form fields card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(AppColors.border)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Academic & Financial Information',
                              style: TextStyle(
                                color: Color(AppColors.textDark),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Institute Name
                            _buildInputLabel('Institute Name'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _instituteController,
                              hint: 'e.g., Indian Institute of Technology, Delhi',
                              icon: Icons.school_outlined,
                            ),
                            const SizedBox(height: 20),

                            // Course
                            _buildInputLabel('Course / Program'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _courseController,
                              hint: 'e.g., B.Tech Computer Science',
                              icon: Icons.book_outlined,
                            ),
                            const SizedBox(height: 20),

                            // Annual Family Income
                            _buildInputLabel('Annual Family Income (₹)'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _incomeController,
                              hint: 'e.g., 450000',
                              icon: Icons.currency_rupee,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),

                            // UMIS ID with verification
                            _buildInputLabel('UMIS ID'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(AppColors.border)),
                                    ),
                                    child: TextFormField(
                                      controller: _umisController,
                                      style: const TextStyle(
                                        color: Color(AppColors.textDark),
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'e.g., UMIS2024123456',
                                        hintStyle: const TextStyle(color: Color(AppColors.textMuted)),
                                        prefixIcon: const Icon(
                                          Icons.badge_outlined,
                                          color: Color(AppColors.textMuted),
                                        ),
                                        suffixIcon: _isUmisValid
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Color(AppColors.success),
                                              )
                                            : null,
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        errorText: _umisError,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _validateUmis,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(AppColors.primaryStart),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text('Verify'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(AppColors.info).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(AppColors.info).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Icon(Icons.info_outline, color: Color(AppColors.info), size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Scholarship name will be determined based on your eligibility after document verification.',
                                style: TextStyle(
                                  color: Color(AppColors.info),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Action Bar
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
                text: 'Continue to DigiLocker',
                icon: Icons.arrow_forward,
                onPressed: _saveAndContinue,
                isLoading: _isLoading,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(AppColors.textDark),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(AppColors.textDark),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(AppColors.textMuted)),
          prefixIcon: Icon(icon, color: const Color(AppColors.textMuted)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
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
