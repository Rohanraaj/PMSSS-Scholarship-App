// Admin Dashboard Screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/constants.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../services/mock_data.dart';
import '../../widgets/glassmorphic_card.dart';
import '../../widgets/gradient_button.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab = 0;

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
    final analytics = MockData.analyticsData;

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
                          Icons.admin_panel_settings_outlined,
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
                              authService.currentUser?.name ?? 'Administrator',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'System Administrator',
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
                // Tab bar inside header area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildTab('Overview', 0),
                        _buildTab('Schemes', 1),
                        _buildTab('Audit Logs', 2),
                      ],
                    ),
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
              child: _selectedTab == 0
                  ? _buildOverviewTab(analytics)
                  : _selectedTab == 1
                      ? _buildSchemesTab()
                      : _buildAuditLogsTab(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
         onTap: () => setState(() => _selectedTab = index),
         child: Container(
           decoration: BoxDecoration(
             color: isSelected ? Colors.white : Colors.transparent,
             borderRadius: BorderRadius.circular(8),
           ),
           child: Center(
             child: Text(
               label,
               style: TextStyle(
                 color: isSelected
                     ? const Color(AppColors.primaryStart)
                     : Colors.white.withOpacity(0.9),
                 fontSize: 13,
                 fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
               ),
             ),
           ),
         ),
       ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> analytics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Total Applications', '${analytics['totalApplications']}', Icons.description, const Color(AppColors.primaryStart))),
              const SizedBox(width: AppSizes.sm),
              Expanded(child: _buildSummaryCard('Approved', '${analytics['approved']}', Icons.check_circle, const Color(AppColors.success))),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Pending', '${analytics['pendingReview']}', Icons.pending, const Color(AppColors.warning))),
              const SizedBox(width: AppSizes.sm),
              Expanded(child: _buildSummaryCard('Rejected', '${analytics['rejected']}', Icons.cancel, const Color(AppColors.error))),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          // Disbursement
          GlassmorphicCard(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(AppColors.success).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Icon(Icons.payments, color: Color(AppColors.success), size: 28),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Disbursed',
                        style: TextStyle(
                          color: Color(AppColors.textMuted),
                          fontSize: AppSizes.fontSm,
                        ),
                      ),
                      Text(
                        '₹${(analytics['totalDisbursed'] / 100000).toStringAsFixed(2)}L',
                        style: const TextStyle(
                          color: Color(AppColors.success),
                          fontSize: AppSizes.fontXxl,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Chart
          const Text(
            'Monthly Applications',
            style: TextStyle(
              color: Color(AppColors.textDark),
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          GlassmorphicCard(
            padding: const EdgeInsets.all(AppSizes.md),
            child: SizedBox(
              height: 200,
              child: _buildBarChart(analytics['monthlyTrend']),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Applications by scheme
          const Text(
            'Applications by Scheme',
            style: TextStyle(
              color: Color(AppColors.textDark),
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          ...(analytics['applicationsByScheme'] as Map<String, dynamic>).entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: _buildSchemeRow(e.key, e.value, analytics['totalApplications']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSizes.sm),
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

  Widget _buildBarChart(List<dynamic> data) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 250,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= data.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    data[value.toInt()]['month'],
                    style: const TextStyle(
                      color: Color(AppColors.textMuted),
                      fontSize: 10,
                    ),
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: (entry.value['count'] as int).toDouble(),
                gradient: AppTheme.primaryGradient,
                width: 20,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSchemeRow(String name, int count, int total) {
    final percentage = (count / total) * 100;
    return GlassmorphicCard(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(AppColors.textDark),
                    fontSize: AppSizes.fontSm,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: const Color(AppColors.glassBorder),
                  valueColor: const AlwaysStoppedAnimation(Color(AppColors.primaryStart)),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Text(
            '$count',
            style: const TextStyle(
              color: Color(AppColors.textDark),
              fontSize: AppSizes.fontMd,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemesTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.lg),
      itemCount: MockData.scholarships.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
      itemBuilder: (context, index) {
        final scheme = MockData.scholarships[index];
        return GlassmorphicCard(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: const Icon(Icons.school, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Text(
                      scheme.name,
                      style: const TextStyle(
                        color: Color(AppColors.textDark),
                        fontSize: AppSizes.fontSm,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
                    decoration: BoxDecoration(
                      color: const Color(AppColors.success).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Color(AppColors.success),
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Row(
                children: [
                  _buildSchemeChip('Max Income: ₹${(scheme.maxIncomeLimit / 100000).toStringAsFixed(1)}L'),
                  const SizedBox(width: AppSizes.sm),
                  _buildSchemeChip('Amount: ${scheme.formattedAmount}'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSchemeChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: const Color(AppColors.glassBackground),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(AppColors.textMuted),
          fontSize: AppSizes.fontXs,
        ),
      ),
    );
  }

  Widget _buildAuditLogsTab() {
    final logs = MockData.auditLogs;
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.lg),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.xs),
      itemBuilder: (context, index) {
        final log = logs[index];
        return GlassmorphicCard(
          padding: const EdgeInsets.all(AppSizes.sm),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _getLogColor(log.action).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Icon(
                  _getLogIcon(log.action),
                  color: _getLogColor(log.action),
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.actionDisplayName,
                      style: const TextStyle(
                        color: Color(AppColors.textDark),
                        fontSize: AppSizes.fontSm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${log.userName} • ${_formatTime(log.timestamp)}',
                      style: const TextStyle(
                        color: Color(AppColors.textMuted),
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getLogColor(action) {
    switch (action.toString()) {
      case 'AuditAction.login':
      case 'AuditAction.logout':
        return const Color(AppColors.info);
      case 'AuditAction.applicationApproved':
      case 'AuditAction.paymentCompleted':
        return const Color(AppColors.success);
      case 'AuditAction.applicationRejected':
        return const Color(AppColors.error);
      default:
        return const Color(AppColors.primaryStart);
    }
  }

  IconData _getLogIcon(action) {
    switch (action.toString()) {
      case 'AuditAction.login':
        return Icons.login;
      case 'AuditAction.logout':
        return Icons.logout;
      case 'AuditAction.applicationApproved':
        return Icons.check_circle;
      case 'AuditAction.applicationRejected':
        return Icons.cancel;
      case 'AuditAction.paymentTriggered':
        return Icons.payment;
      default:
        return Icons.history;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
