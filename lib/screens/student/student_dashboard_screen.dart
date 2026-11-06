// Student Dashboard Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/application_service.dart';
import '../../models/application.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _currentIndex = 0;

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
    return Scaffold(
      backgroundColor: const Color(AppColors.backgroundLight),
      body: SafeArea(
        child: _currentIndex == 0 
            ? _buildHomeTab() 
            : _currentIndex == 1 
                ? _buildApplyTab() 
                : _buildProfileTab(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHomeTab() {
    final authService = context.watch<AuthService>();
    final appService = context.watch<ApplicationService>();
    final applications = appService.applications;
    final submittedCount = applications.length;
    final approvedCount = applications.where((a) => a.isApproved).length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: const Color(AppColors.textMuted),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authService.currentUser?.name ?? 'Rohan Sharma',
                        style: const TextStyle(
                          color: Color(AppColors.textDark),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Notification Bell
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(AppColors.border)),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Color(AppColors.textDark),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(AppColors.error),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Scholarship Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scholarship 2024',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Applications are now open. Apply before 31st Dec.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/student/basic-details'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, size: 18, color: Color(AppColors.textDark)),
                          SizedBox(width: 6),
                          Text(
                            'Apply Now',
                            style: TextStyle(
                              color: Color(AppColors.textDark),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Stats Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.description_outlined,
                    iconColor: const Color(AppColors.primaryStart),
                    count: submittedCount.toString(),
                    label: 'Applications',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.currency_rupee,
                    iconColor: const Color(AppColors.secondary),
                    count: approvedCount.toString(),
                    label: 'Received',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Recent Applications
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Applications',
                  style: TextStyle(
                    color: Color(AppColors.textDark),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/student/tracking'),
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(AppColors.primaryStart),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Applications List
          if (appService.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (applications.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  'No applications yet. Start your first application!',
                  style: TextStyle(color: const Color(AppColors.textMuted)),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: applications.length > 3 ? 3 : applications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildApplicationCard(applications[index]);
              },
            ),
          const SizedBox(height: 20),
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: _logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(AppColors.primaryStart),
                  side: const BorderSide(color: Color(AppColors.border)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildApplyTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.description_outlined,
            size: 64,
            color: Color(AppColors.primaryStart),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start New Application',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textDark),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Apply for scholarships available to you',
            style: TextStyle(
              color: Color(AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/student/basic-details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(AppColors.primaryStart),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Application',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final authService = context.watch<AuthService>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                (authService.currentUser?.name ?? 'S')[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            authService.currentUser?.name ?? 'Rohan Sharma',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textDark),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            authService.currentUser?.email ?? 'student@example.com',
            style: const TextStyle(
              color: Color(AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 32),
          // Profile Options
          _buildProfileOption(Icons.person_outline, 'Edit Profile'),
          _buildProfileOption(Icons.lock_outline, 'Change Password'),
          _buildProfileOption(Icons.notifications_outlined, 'Notifications'),
          _buildProfileOption(Icons.help_outline, 'Help & Support'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _logout,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(AppColors.error),
                side: const BorderSide(color: Color(AppColors.error)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(AppColors.textDark)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(AppColors.textDark),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textDark),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(ScholarshipApplication application) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  application.scholarshipName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(AppColors.textDark),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(application.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(application.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getStatusText(application.status),
                  style: TextStyle(
                    color: _getStatusColor(application.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${application.id}',
            style: const TextStyle(
              color: Color(AppColors.textMuted),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                application.submittedAt != null 
                    ? 'Applied on ${_formatDate(application.submittedAt!)}'
                    : 'Draft',
                style: const TextStyle(
                  color: Color(AppColors.textMuted),
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/student/tracking'),
                child: Row(
                  children: const [
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(AppColors.primaryStart),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: Color(AppColors.primaryStart),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.submitted:
        return const Color(AppColors.info);
      case ApplicationStatus.underReview:
        return const Color(AppColors.warning);
      case ApplicationStatus.approved:
      case ApplicationStatus.paymentTriggered:
      case ApplicationStatus.paymentCompleted:
        return const Color(AppColors.success);
      case ApplicationStatus.rejected:
        return const Color(AppColors.error);
      case ApplicationStatus.draft:
        return const Color(AppColors.textMuted);
    }
  }

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.draft:
        return 'DRAFT';
      case ApplicationStatus.submitted:
        return 'SUBMITTED';
      case ApplicationStatus.underReview:
        return 'UNDER REVIEW';
      case ApplicationStatus.approved:
        return 'APPROVED';
      case ApplicationStatus.rejected:
        return 'REJECTED';
      case ApplicationStatus.paymentTriggered:
        return 'PAYMENT PROCESSING';
      case ApplicationStatus.paymentCompleted:
        return 'COMPLETED';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Widget _buildBottomNavBar() {
    return Container(
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(1, Icons.description_outlined, Icons.description, 'Apply'),
              _buildNavItem(2, Icons.person_outline, Icons.person, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive 
                  ? const Color(AppColors.primaryStart) 
                  : const Color(AppColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive 
                    ? const Color(AppColors.primaryStart) 
                    : const Color(AppColors.textMuted),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
