// Scholarship Application Model
import 'document.dart';

enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  approved,
  rejected,
  paymentTriggered,
  paymentCompleted,
}

class ScholarshipApplication {
  final String id;
  final String studentId;
  final String studentName;
  final String scholarshipId;
  final String scholarshipName;
  final String instituteName;
  final String umisId;
  final double annualFamilyIncome;
  final String? course;
  final ApplicationStatus status;
  final List<DigiLockerDocument> documents;
  final DateTime createdAt;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;
  final double? riskScore;
  final String? aiDecision;
  final String? aiExplanation;
  final Map<String, dynamic>? paymentDetails;

  ScholarshipApplication({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.scholarshipId,
    required this.scholarshipName,
    required this.instituteName,
    required this.umisId,
    required this.annualFamilyIncome,
    this.course,
    this.status = ApplicationStatus.draft,
    this.documents = const [],
    required this.createdAt,
    this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
    this.riskScore,
    this.aiDecision,
    this.aiExplanation,
    this.paymentDetails,
  });

  factory ScholarshipApplication.fromJson(Map<String, dynamic> json) {
    return ScholarshipApplication(
      id: json['id'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      scholarshipId: json['scholarshipId'],
      scholarshipName: json['scholarshipName'],
      instituteName: json['instituteName'],
      umisId: json['umisId'],
      annualFamilyIncome: (json['annualFamilyIncome'] as num).toDouble(),
      course: json['course'],
      status: ApplicationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ApplicationStatus.draft,
      ),
      documents: (json['documents'] as List?)
          ?.map((d) => DigiLockerDocument.fromJson(d))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      submittedAt: json['submittedAt'] != null 
          ? DateTime.parse(json['submittedAt']) 
          : null,
      reviewedAt: json['reviewedAt'] != null 
          ? DateTime.parse(json['reviewedAt']) 
          : null,
      reviewedBy: json['reviewedBy'],
      rejectionReason: json['rejectionReason'],
      riskScore: json['riskScore']?.toDouble(),
      aiDecision: json['aiDecision'],
      aiExplanation: json['aiExplanation'],
      paymentDetails: json['paymentDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'scholarshipId': scholarshipId,
      'scholarshipName': scholarshipName,
      'instituteName': instituteName,
      'umisId': umisId,
      'annualFamilyIncome': annualFamilyIncome,
      'course': course,
      'status': status.name,
      'documents': documents.map((d) => d.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'submittedAt': submittedAt?.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewedBy': reviewedBy,
      'rejectionReason': rejectionReason,
      'riskScore': riskScore,
      'aiDecision': aiDecision,
      'aiExplanation': aiExplanation,
      'paymentDetails': paymentDetails,
    };
  }

  ScholarshipApplication copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? scholarshipId,
    String? scholarshipName,
    String? instituteName,
    String? umisId,
    double? annualFamilyIncome,
    String? course,
    ApplicationStatus? status,
    List<DigiLockerDocument>? documents,
    DateTime? createdAt,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectionReason,
    double? riskScore,
    String? aiDecision,
    String? aiExplanation,
    Map<String, dynamic>? paymentDetails,
  }) {
    return ScholarshipApplication(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      scholarshipName: scholarshipName ?? this.scholarshipName,
      instituteName: instituteName ?? this.instituteName,
      umisId: umisId ?? this.umisId,
      annualFamilyIncome: annualFamilyIncome ?? this.annualFamilyIncome,
      course: course ?? this.course,
      status: status ?? this.status,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      riskScore: riskScore ?? this.riskScore,
      aiDecision: aiDecision ?? this.aiDecision,
      aiExplanation: aiExplanation ?? this.aiExplanation,
      paymentDetails: paymentDetails ?? this.paymentDetails,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case ApplicationStatus.draft:
        return 'Draft';
      case ApplicationStatus.submitted:
        return 'Submitted';
      case ApplicationStatus.underReview:
        return 'Under SAG Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.paymentTriggered:
        return 'Payment Processing';
      case ApplicationStatus.paymentCompleted:
        return 'Payment Completed';
    }
  }

  bool get canEdit => status == ApplicationStatus.draft;
  bool get isUnderReview => status == ApplicationStatus.underReview;
  bool get isApproved => status == ApplicationStatus.approved;
  bool get isRejected => status == ApplicationStatus.rejected;
}
