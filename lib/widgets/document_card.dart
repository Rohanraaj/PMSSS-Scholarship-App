// Document Card Widget for DigiLocker Documents
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/document.dart';
import 'glassmorphic_card.dart';

class DocumentCard extends StatelessWidget {
  final DigiLockerDocument document;
  final VoidCallback? onTap;
  final VoidCallback? onNameTap;

  const DocumentCard({
    super.key,
    required this.document,
    this.onTap,
    this.onNameTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          // Document Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconBackground(),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              _getDocumentIcon(),
              color: _getIconColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          // Document Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onNameTap,
                  child: Text(
                    document.typeDisplayName,
                    style: TextStyle(
                      color: onNameTap != null ? const Color(AppColors.primaryStart) : const Color(AppColors.textDark),
                      fontSize: AppSizes.fontMd,
                      fontWeight: FontWeight.w600,
                      decoration: onNameTap != null ? TextDecoration.underline : null,
                      decorationColor: const Color(AppColors.primaryStart),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: const Color(AppColors.textMuted),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Fetched ${_formatTime(document.fetchedAt)}',
                      style: const TextStyle(
                        color: Color(AppColors.textMuted),
                        fontSize: AppSizes.fontXs,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Verification Status
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    if (document.isVerified) {
      bgColor = const Color(AppColors.success).withOpacity(0.1);
      textColor = const Color(AppColors.success);
      icon = Icons.verified;
      text = 'Verified';
    } else {
      switch (document.status) {
        case DocumentStatus.pending:
          bgColor = const Color(AppColors.warning).withOpacity(0.1);
          textColor = const Color(AppColors.warning);
          icon = Icons.pending;
          text = 'Pending';
          break;
        case DocumentStatus.fetched:
          bgColor = const Color(AppColors.info).withOpacity(0.1);
          textColor = const Color(AppColors.info);
          icon = Icons.cloud_done;
          text = 'Fetched';
          break;
        case DocumentStatus.verified:
          bgColor = const Color(AppColors.success).withOpacity(0.1);
          textColor = const Color(AppColors.success);
          icon = Icons.verified;
          text = 'Verified';
          break;
        case DocumentStatus.rejected:
          bgColor = const Color(AppColors.error).withOpacity(0.1);
          textColor = const Color(AppColors.error);
          icon = Icons.cancel;
          text = 'Rejected';
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: AppSizes.fontXs,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getDocumentIcon() {
    switch (document.type) {
      case DocumentType.aadhaar:
        return Icons.badge;
      case DocumentType.incomeCertificate:
        return Icons.receipt_long;
      case DocumentType.academicCertificate:
        return Icons.school;
      case DocumentType.casteCertificate:
        return Icons.article;
      case DocumentType.domicileCertificate:
        return Icons.home;
      case DocumentType.bankPassbook:
        return Icons.account_balance;
    }
  }

  Color _getIconBackground() {
    switch (document.type) {
      case DocumentType.aadhaar:
        return const Color(0xFF3B82F6).withOpacity(0.1);
      case DocumentType.incomeCertificate:
        return const Color(0xFF10B981).withOpacity(0.1);
      case DocumentType.academicCertificate:
        return const Color(0xFF8B5CF6).withOpacity(0.1);
      case DocumentType.casteCertificate:
        return const Color(0xFFF59E0B).withOpacity(0.1);
      case DocumentType.domicileCertificate:
        return const Color(0xFFEC4899).withOpacity(0.1);
      case DocumentType.bankPassbook:
        return const Color(0xFF06B6D4).withOpacity(0.1);
    }
  }

  Color _getIconColor() {
    switch (document.type) {
      case DocumentType.aadhaar:
        return const Color(0xFF3B82F6);
      case DocumentType.incomeCertificate:
        return const Color(0xFF10B981);
      case DocumentType.academicCertificate:
        return const Color(0xFF8B5CF6);
      case DocumentType.casteCertificate:
        return const Color(0xFFF59E0B);
      case DocumentType.domicileCertificate:
        return const Color(0xFFEC4899);
      case DocumentType.bankPassbook:
        return const Color(0xFF06B6D4);
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// Document Detail Card (expanded view)
class DocumentDetailCard extends StatelessWidget {
  final DigiLockerDocument document;

  const DocumentDetailCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(AppColors.primaryStart).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(AppColors.primaryStart),
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.typeDisplayName,
                      style: const TextStyle(
                        color: Color(AppColors.textDark),
                        fontSize: AppSizes.fontLg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'DigiLocker ID: ${document.digiLockerId}',
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
          const SizedBox(height: AppSizes.lg),
          const Divider(color: Color(AppColors.glassBorder)),
          const SizedBox(height: AppSizes.md),
          // Extracted Data
          if (document.extractedData != null) ...[
            const Text(
              'Extracted Information',
              style: TextStyle(
                color: Color(AppColors.textMuted),
                fontSize: AppSizes.fontSm,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            ...document.extractedData!.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      _formatKey(entry.key),
                      style: const TextStyle(
                        color: Color(AppColors.textMuted),
                        fontSize: AppSizes.fontSm,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        color: Color(AppColors.textDark),
                        fontSize: AppSizes.fontSm,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  String _formatKey(String key) {
    // Convert camelCase to Title Case
    final result = key.replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)} ${match.group(2)}',
    );
    return result[0].toUpperCase() + result.substring(1);
  }
}
