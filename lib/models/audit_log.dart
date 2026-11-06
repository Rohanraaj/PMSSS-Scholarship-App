// Audit Log Model for Compliance
enum AuditAction {
  login,
  logout,
  applicationCreated,
  applicationSubmitted,
  documentFetched,
  verificationStarted,
  applicationApproved,
  applicationRejected,
  clarificationRequested,
  paymentTriggered,
  paymentCompleted,
  schemeCreated,
  schemeUpdated,
  roleAssigned,
  permissionChanged,
}

class AuditLog {
  final String id;
  final String userId;
  final String userName;
  final AuditAction action;
  final String details;
  final String? targetId;
  final String? targetType;
  final String ipAddress;
  final String deviceInfo;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  AuditLog({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.details,
    this.targetId,
    this.targetType,
    required this.ipAddress,
    required this.deviceInfo,
    required this.timestamp,
    this.metadata,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) {
    return AuditLog(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      action: AuditAction.values.firstWhere(
        (e) => e.name == json['action'],
        orElse: () => AuditAction.login,
      ),
      details: json['details'],
      targetId: json['targetId'],
      targetType: json['targetType'],
      ipAddress: json['ipAddress'],
      deviceInfo: json['deviceInfo'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'action': action.name,
      'details': details,
      'targetId': targetId,
      'targetType': targetType,
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  String get actionDisplayName {
    switch (action) {
      case AuditAction.login:
        return 'User Login';
      case AuditAction.logout:
        return 'User Logout';
      case AuditAction.applicationCreated:
        return 'Application Created';
      case AuditAction.applicationSubmitted:
        return 'Application Submitted';
      case AuditAction.documentFetched:
        return 'Document Fetched';
      case AuditAction.verificationStarted:
        return 'Verification Started';
      case AuditAction.applicationApproved:
        return 'Application Approved';
      case AuditAction.applicationRejected:
        return 'Application Rejected';
      case AuditAction.clarificationRequested:
        return 'Clarification Requested';
      case AuditAction.paymentTriggered:
        return 'Payment Triggered';
      case AuditAction.paymentCompleted:
        return 'Payment Completed';
      case AuditAction.schemeCreated:
        return 'Scheme Created';
      case AuditAction.schemeUpdated:
        return 'Scheme Updated';
      case AuditAction.roleAssigned:
        return 'Role Assigned';
      case AuditAction.permissionChanged:
        return 'Permission Changed';
    }
  }
}
