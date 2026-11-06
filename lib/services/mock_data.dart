// Mock Data Service - Realistic Data for Presentations
import '../models/user.dart';
import '../models/scholarship.dart';
import '../models/document.dart';
import '../models/application.dart';
import '../models/audit_log.dart';

class MockData {
  // ============ USERS ============
  static final List<User> users = [
    // Student Users
    User(
      id: 'STU001',
      email: 'rahul.sharma@student.edu.in',
      phone: '+91 98765 43210',
      name: 'Rahul Sharma',
      role: UserRole.student,
      biometricEnabled: true,
      createdAt: DateTime(2024, 8, 15),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    User(
      id: 'STU002',
      email: 'priya.patel@student.edu.in',
      phone: '+91 87654 32109',
      name: 'Priya Patel',
      role: UserRole.student,
      biometricEnabled: false,
      createdAt: DateTime(2024, 9, 1),
      lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    User(
      id: 'STU003',
      email: 'amit.kumar@student.edu.in',
      phone: '+91 76543 21098',
      name: 'Amit Kumar',
      role: UserRole.student,
      biometricEnabled: true,
      createdAt: DateTime(2024, 7, 20),
    ),
    // SAG Officer
    User(
      id: 'SAG001',
      email: 'officer.verma@aicte.gov.in',
      phone: '+91 99887 76655',
      name: 'Dr. Sunita Verma',
      role: UserRole.sagOfficer,
      biometricEnabled: true,
      createdAt: DateTime(2023, 1, 10),
      lastLoginAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    User(
      id: 'SAG002',
      email: 'officer.singh@aicte.gov.in',
      phone: '+91 88776 65544',
      name: 'Rajesh Singh',
      role: UserRole.sagOfficer,
      biometricEnabled: true,
      createdAt: DateTime(2023, 3, 15),
    ),
    // Admin
    User(
      id: 'ADM001',
      email: 'admin@pmsss.gov.in',
      phone: '+91 97531 86420',
      name: 'System Administrator',
      role: UserRole.admin,
      biometricEnabled: true,
      createdAt: DateTime(2022, 6, 1),
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  // ============ SCHOLARSHIPS ============
  static final List<Scholarship> scholarships = [
    Scholarship(
      id: 'PMSSS001',
      name: 'Prime Minister\'s Special Scholarship Scheme (PMSSS)',
      description: 'For students from J&K and Ladakh pursuing undergraduate studies in recognized institutions across India. Covers tuition fees and provides maintenance allowance.',
      maxIncomeLimit: 800000,
      eligibleInstitutes: ['IIT', 'NIT', 'IIIT', 'Central University', 'State University', 'AICTE Approved'],
      eligibleCourses: ['B.Tech', 'MBBS', 'B.Arch', 'BBA', 'B.Sc', 'BA', 'B.Com'],
      eligibleCategories: ['General', 'OBC', 'SC', 'ST'],
      scholarshipAmount: 125000,
      duration: '4-5 years',
      applicationDeadline: DateTime(2026, 6, 30),
    ),
    Scholarship(
      id: 'NSP001',
      name: 'National Scholarship Portal - Central Sector Scheme',
      description: 'Merit-based scholarship for students from low-income families who have passed Class XII with good marks.',
      maxIncomeLimit: 600000,
      eligibleInstitutes: ['Any recognized institution'],
      eligibleCourses: ['All UG courses'],
      eligibleCategories: ['General', 'OBC', 'SC', 'ST', 'Minority'],
      scholarshipAmount: 36000,
      duration: '3-5 years',
      applicationDeadline: DateTime(2026, 5, 31),
    ),
    Scholarship(
      id: 'AICTE001',
      name: 'AICTE Pragati Scholarship',
      description: 'For girl students pursuing technical education in AICTE approved institutions.',
      maxIncomeLimit: 800000,
      eligibleInstitutes: ['AICTE Approved'],
      eligibleCourses: ['B.Tech', 'B.E', 'Diploma'],
      eligibleCategories: ['General', 'OBC', 'SC', 'ST'],
      scholarshipAmount: 50000,
      duration: '4 years',
      applicationDeadline: DateTime(2026, 4, 15),
    ),
    Scholarship(
      id: 'SC001',
      name: 'Post Matric Scholarship for SC Students',
      description: 'Financial assistance for SC students for post-matriculation studies.',
      maxIncomeLimit: 250000,
      eligibleInstitutes: ['All recognized institutions'],
      eligibleCourses: ['All courses'],
      eligibleCategories: ['SC'],
      scholarshipAmount: 75000,
      duration: 'Course duration',
      applicationDeadline: DateTime(2026, 7, 31),
    ),
    Scholarship(
      id: 'OBC001',
      name: 'Pre-Matric Scholarship for OBC Students',
      description: 'Support for OBC students from economically weaker sections.',
      maxIncomeLimit: 300000,
      eligibleInstitutes: ['All recognized institutions'],
      eligibleCourses: ['All courses'],
      eligibleCategories: ['OBC'],
      scholarshipAmount: 25000,
      duration: 'Course duration',
      applicationDeadline: DateTime(2026, 8, 15),
    ),
  ];

  // ============ DOCUMENTS (DigiLocker Mock) ============
  static List<DigiLockerDocument> getDocumentsForStudent(String studentId) {
    return [
      DigiLockerDocument(
        id: 'DOC${studentId}001',
        type: DocumentType.aadhaar,
        digiLockerId: 'DLAADHAAR${studentId}',
        documentName: 'Aadhaar Card',
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        status: DocumentStatus.verified,
        isVerified: true,
        extractedData: {
          'name': 'Rahul Sharma',
          'aadhaarNumber': 'XXXX XXXX 4532',
          'dob': '15-08-2002',
          'address': 'H.No 45, Sector 12, Jammu, J&K - 180001',
          'gender': 'Male',
        },
      ),
      DigiLockerDocument(
        id: 'DOC${studentId}002',
        type: DocumentType.incomeCertificate,
        digiLockerId: 'DLINCOME${studentId}',
        documentName: 'Income Certificate',
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 4)),
        status: DocumentStatus.verified,
        isVerified: true,
        extractedData: {
          'certificateNo': 'INC/JK/2024/78542',
          'issuedBy': 'Tehsildar, Jammu',
          'annualIncome': '₹4,50,000',
          'issuedDate': '10-01-2024',
          'validUntil': '09-01-2025',
        },
      ),
      DigiLockerDocument(
        id: 'DOC${studentId}003',
        type: DocumentType.academicCertificate,
        digiLockerId: 'DLACAD${studentId}',
        documentName: 'Class XII Marksheet',
        fetchedAt: DateTime.now().subtract(const Duration(minutes: 3)),
        status: DocumentStatus.verified,
        isVerified: true,
        extractedData: {
          'board': 'JKBOSE',
          'rollNo': '1234567',
          'year': '2024',
          'percentage': '89.2%',
          'grade': 'A+',
          'stream': 'Science',
        },
      ),
    ];
  }


  // ============ APPLICATIONS ============
  static List<ScholarshipApplication> applications = [
    ScholarshipApplication(
      id: 'APP2024001',
      studentId: 'STU001',
      studentName: 'Rahul Sharma',
      scholarshipId: 'PMSSS001',
      scholarshipName: 'PMSSS',
      instituteName: 'Indian Institute of Technology, Delhi',
      umisId: 'UMIS2024123456',
      annualFamilyIncome: 450000,
      course: 'B.Tech Computer Science',
      status: ApplicationStatus.submitted,
      documents: getDocumentsForStudent('STU001'),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      submittedAt: DateTime.now().subtract(const Duration(days: 4)),
      riskScore: 12.5,
      aiDecision: 'RECOMMENDED FOR APPROVAL',
      aiExplanation: 'All documents verified via DigiLocker. Income within limit (₹4.5L < ₹8L). Academic performance excellent (89.2%). Domicile verified for J&K. No duplicate applications found. Low risk score.',
    ),
    ScholarshipApplication(
      id: 'APP2024002',
      studentId: 'STU002',
      studentName: 'Priya Patel',
      scholarshipId: 'AICTE001',
      scholarshipName: 'AICTE Pragati Scholarship',
      instituteName: 'NIT Srinagar',
      umisId: 'UMIS2024789012',
      annualFamilyIncome: 380000,
      course: 'B.Tech Electronics',
      status: ApplicationStatus.underReview,
      documents: getDocumentsForStudent('STU002'),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      riskScore: 8.2,
      aiDecision: 'RECOMMENDED FOR APPROVAL',
      aiExplanation: 'Female candidate eligible for Pragati scheme. All documents authentic. Income verified (₹3.8L). Academic record strong. Institute is AICTE approved.',
    ),
    ScholarshipApplication(
      id: 'APP2024003',
      studentId: 'STU003',
      studentName: 'Amit Kumar',
      scholarshipId: 'PMSSS001',
      scholarshipName: 'PMSSS',
      instituteName: 'Central University of Jammu',
      umisId: 'UMIS2024345678',
      annualFamilyIncome: 520000,
      course: 'BA English Literature',
      status: ApplicationStatus.approved,
      documents: getDocumentsForStudent('STU003'),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      submittedAt: DateTime.now().subtract(const Duration(days: 9)),
      reviewedAt: DateTime.now().subtract(const Duration(days: 2)),
      reviewedBy: 'SAG001',
      riskScore: 5.0,
      aiDecision: 'APPROVED',
      aiExplanation: 'Application fully compliant. Approved by SAG Officer on 06-02-2026.',
    ),
    ScholarshipApplication(
      id: 'APP2024004',
      studentId: 'STU004',
      studentName: 'Neha Singh',
      scholarshipId: 'NSP001',
      scholarshipName: 'NSP Central Sector',
      instituteName: 'Delhi University',
      umisId: 'UMIS2024567890',
      annualFamilyIncome: 750000,
      course: 'B.Com Honours',
      status: ApplicationStatus.rejected,
      documents: [],
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      submittedAt: DateTime.now().subtract(const Duration(days: 14)),
      reviewedAt: DateTime.now().subtract(const Duration(days: 7)),
      reviewedBy: 'SAG002',
      rejectionReason: 'Income exceeds the maximum limit for NSP Central Sector Scheme (₹7.5L > ₹6L limit).',
      riskScore: 65.0,
      aiDecision: 'FLAGGED - INCOME MISMATCH',
      aiExplanation: 'Income certificate shows ₹7,50,000 which exceeds the scheme limit of ₹6,00,000. Application cannot be approved under this scheme.',
    ),
    ScholarshipApplication(
      id: 'APP2024005',
      studentId: 'STU005',
      studentName: 'Mohammed Farooq',
      scholarshipId: 'PMSSS001',
      scholarshipName: 'PMSSS',
      instituteName: 'AIIMS Delhi',
      umisId: 'UMIS2024901234',
      annualFamilyIncome: 280000,
      course: 'MBBS',
      status: ApplicationStatus.paymentTriggered,
      documents: getDocumentsForStudent('STU005'),
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      submittedAt: DateTime.now().subtract(const Duration(days: 19)),
      reviewedAt: DateTime.now().subtract(const Duration(days: 5)),
      reviewedBy: 'SAG001',
      riskScore: 3.2,
      aiDecision: 'APPROVED',
      aiExplanation: 'Excellent application. Top medical institute. Low income family. All documents verified.',
      paymentDetails: {
        'transactionId': 'TXN2024PMSSS00125',
        'amount': 125000,
        'initiatedAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'status': 'Processing',
        'bankRef': 'NEFT/2024/87654321',
      },
    ),
  ];

  // ============ AUDIT LOGS ============
  static List<AuditLog> auditLogs = [
    AuditLog(
      id: 'LOG001',
      userId: 'STU001',
      userName: 'Rahul Sharma',
      action: AuditAction.login,
      details: 'User logged in via OTP',
      ipAddress: '192.168.1.45',
      deviceInfo: 'Android 14, Samsung Galaxy S23',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AuditLog(
      id: 'LOG002',
      userId: 'STU001',
      userName: 'Rahul Sharma',
      action: AuditAction.documentFetched,
      details: 'Fetched 4 documents from DigiLocker',
      targetId: 'APP2024001',
      targetType: 'Application',
      ipAddress: '192.168.1.45',
      deviceInfo: 'Android 14, Samsung Galaxy S23',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
    ),
    AuditLog(
      id: 'LOG003',
      userId: 'STU001',
      userName: 'Rahul Sharma',
      action: AuditAction.applicationSubmitted,
      details: 'Submitted application for PMSSS scholarship',
      targetId: 'APP2024001',
      targetType: 'Application',
      ipAddress: '192.168.1.45',
      deviceInfo: 'Android 14, Samsung Galaxy S23',
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    AuditLog(
      id: 'LOG004',
      userId: 'SAG001',
      userName: 'Dr. Sunita Verma',
      action: AuditAction.login,
      details: 'SAG Officer logged in via MFA',
      ipAddress: '10.20.30.40',
      deviceInfo: 'Windows 11, Chrome 121',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    AuditLog(
      id: 'LOG005',
      userId: 'SAG001',
      userName: 'Dr. Sunita Verma',
      action: AuditAction.verificationStarted,
      details: 'Started verification of application APP2024002',
      targetId: 'APP2024002',
      targetType: 'Application',
      ipAddress: '10.20.30.40',
      deviceInfo: 'Windows 11, Chrome 121',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    AuditLog(
      id: 'LOG006',
      userId: 'SAG001',
      userName: 'Dr. Sunita Verma',
      action: AuditAction.applicationApproved,
      details: 'Approved application APP2024003 for PMSSS',
      targetId: 'APP2024003',
      targetType: 'Application',
      ipAddress: '10.20.30.40',
      deviceInfo: 'Windows 11, Chrome 121',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AuditLog(
      id: 'LOG007',
      userId: 'SAG001',
      userName: 'Dr. Sunita Verma',
      action: AuditAction.paymentTriggered,
      details: 'Payment workflow initiated for APP2024005',
      targetId: 'APP2024005',
      targetType: 'Application',
      ipAddress: '10.20.30.40',
      deviceInfo: 'Windows 11, Chrome 121',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      metadata: {
        'amount': 125000,
        'transactionId': 'TXN2024PMSSS00125',
      },
    ),
    AuditLog(
      id: 'LOG008',
      userId: 'ADM001',
      userName: 'System Administrator',
      action: AuditAction.schemeUpdated,
      details: 'Updated PMSSS scholarship deadline to 30-06-2026',
      targetId: 'PMSSS001',
      targetType: 'Scholarship',
      ipAddress: '10.0.0.1',
      deviceInfo: 'Windows 11, Edge 121',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // ============ ANALYTICS DATA ============
  static Map<String, dynamic> analyticsData = {
    'totalApplications': 1247,
    'pendingReview': 89,
    'approved': 856,
    'rejected': 145,
    'paymentProcessing': 157,
    'totalDisbursed': 9875000,
    'thisMonthApplications': 234,
    'lastMonthApplications': 198,
    'averageProcessingDays': 4.5,
    'eligibilityRate': 0.78,
    'applicationsByScheme': {
      'PMSSS': 623,
      'NSP Central': 312,
      'AICTE Pragati': 187,
      'SC Post Matric': 89,
      'OBC Pre Matric': 36,
    },
    'applicationsByStatus': {
      'Submitted': 89,
      'Under Review': 45,
      'Approved': 856,
      'Rejected': 145,
      'Payment Processing': 112,
    },
    'monthlyTrend': [
      {'month': 'Sep', 'count': 145},
      {'month': 'Oct', 'count': 178},
      {'month': 'Nov', 'count': 198},
      {'month': 'Dec', 'count': 189},
      {'month': 'Jan', 'count': 234},
      {'month': 'Feb', 'count': 156},
    ],
    'riskDistribution': {
      'Low (0-20)': 892,
      'Medium (21-50)': 267,
      'High (51-100)': 88,
    },
  };

  // Helper method to get user by phone/email
  static User? getUserByPhoneOrEmail(String input) {
    return users.firstWhere(
      (u) => u.phone.replaceAll(' ', '').contains(input.replaceAll(' ', '')) || 
             u.email.toLowerCase() == input.toLowerCase(),
      orElse: () => users.first,
    );
  }

  // Helper method to get applications for a student
  static List<ScholarshipApplication> getApplicationsForStudent(String studentId) {
    return applications.where((a) => a.studentId == studentId).toList();
  }

  // Helper method to get pending applications for SAG review
  static List<ScholarshipApplication> getPendingApplications() {
    return applications.where((a) => 
      a.status == ApplicationStatus.submitted || 
      a.status == ApplicationStatus.underReview
    ).toList();
  }
}
