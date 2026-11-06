// Application Management Service
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/application.dart';
import '../models/document.dart';
import '../models/scholarship.dart';
import 'mock_data.dart';

class ApplicationService extends ChangeNotifier {
  ScholarshipApplication? _currentApplication;
  List<ScholarshipApplication> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Form data for new application
  String _instituteName = '';
  String _umisId = '';
  double _annualIncome = 0;
  String _course = '';

  ScholarshipApplication? get currentApplication => _currentApplication;
  List<ScholarshipApplication> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get instituteName => _instituteName;
  String get umisId => _umisId;
  double get annualIncome => _annualIncome;
  String get course => _course;

  // Update form fields
  void setInstituteName(String value) {
    _instituteName = value;
    notifyListeners();
  }

  void setUmisId(String value) {
    _umisId = value;
    notifyListeners();
  }

  void setAnnualIncome(double value) {
    _annualIncome = value;
    notifyListeners();
  }

  void setCourse(String value) {
    _course = value;
    notifyListeners();
  }

  // Validate UMIS ID
  Future<bool> validateUmisId(String umisId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock validation - accept IDs starting with UMIS
    return umisId.isNotEmpty && umisId.toUpperCase().startsWith('UMIS');
  }

  // Create new application
  Future<ScholarshipApplication> createApplication({
    required String studentId,
    required String studentName,
    required String scholarshipId,
    required String scholarshipName,
    required List<DigiLockerDocument> documents,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final application = ScholarshipApplication(
      id: 'APP${DateTime.now().millisecondsSinceEpoch}',
      studentId: studentId,
      studentName: studentName,
      scholarshipId: scholarshipId,
      scholarshipName: scholarshipName,
      instituteName: _instituteName,
      umisId: _umisId,
      annualFamilyIncome: _annualIncome,
      course: _course,
      status: ApplicationStatus.draft,
      documents: documents,
      createdAt: DateTime.now(),
    );

    _currentApplication = application;
    _applications.add(application);
    _isLoading = false;
    notifyListeners();

    return application;
  }

  // Submit application
  Future<bool> submitApplication() async {
    if (_currentApplication == null) return false;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _currentApplication = _currentApplication!.copyWith(
      status: ApplicationStatus.submitted,
      submittedAt: DateTime.now(),
      riskScore: 12.5, // Mock risk score
      aiDecision: 'RECOMMENDED FOR APPROVAL',
      aiExplanation: 'All documents verified via DigiLocker. Income within limit. '
          'Academic performance verified. Domicile confirmed. No duplicates found.',
    );

    // Update in list
    final index = _applications.indexWhere((a) => a.id == _currentApplication!.id);
    if (index != -1) {
      _applications[index] = _currentApplication!;
    }

    _isLoading = false;
    notifyListeners();

    debugPrint('✅ Application ${_currentApplication!.id} submitted successfully');
    return true;
  }

  // Load student's applications
  Future<void> loadApplicationsForStudent(String studentId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _applications = MockData.getApplicationsForStudent(studentId);
    if (_applications.isNotEmpty) {
      _currentApplication = _applications.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load pending applications (for SAG Officer)
  Future<void> loadPendingApplications() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _applications = MockData.getPendingApplications();
    _isLoading = false;
    notifyListeners();
  }

  // Load all applications (for Admin)
  Future<void> loadAllApplications() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _applications = MockData.applications;
    _isLoading = false;
    notifyListeners();
  }

  // Approve application (SAG Officer)
  Future<bool> approveApplication(String applicationId, String officerId) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(
        status: ApplicationStatus.approved,
        reviewedAt: DateTime.now(),
        reviewedBy: officerId,
        aiDecision: 'APPROVED',
      );
      notifyListeners();
      
      // Auto-trigger payment
      await _triggerPayment(applicationId);
      
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Reject application (SAG Officer)
  Future<bool> rejectApplication(String applicationId, String officerId, String reason) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(
        status: ApplicationStatus.rejected,
        reviewedAt: DateTime.now(),
        reviewedBy: officerId,
        rejectionReason: reason,
        aiDecision: 'REJECTED',
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Trigger payment workflow
  Future<void> _triggerPayment(String applicationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _applications.indexWhere((a) => a.id == applicationId);
    if (index != -1) {
      _applications[index] = _applications[index].copyWith(
        status: ApplicationStatus.paymentTriggered,
        paymentDetails: {
          'transactionId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
          'amount': 125000,
          'initiatedAt': DateTime.now().toIso8601String(),
          'status': 'Processing',
        },
      );
      notifyListeners();
    }
  }

  // Get application by ID
  ScholarshipApplication? getApplicationById(String id) {
    try {
      return _applications.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  // Reset form
  void resetForm() {
    _instituteName = '';
    _umisId = '';
    _annualIncome = 0;
    _course = '';
    _currentApplication = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
