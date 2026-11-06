// DigiLocker Service - Simulated Document Fetch
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/document.dart';
import 'mock_data.dart';

enum DigiLockerStatus {
  idle,
  authenticating,
  fetchingDocuments,
  completed,
  error,
}

class DigiLockerService extends ChangeNotifier {
  DigiLockerStatus _status = DigiLockerStatus.idle;
  List<DigiLockerDocument> _documents = [];
  String? _consentId;
  String? _errorMessage;
  double _fetchProgress = 0.0;

  DigiLockerStatus get status => _status;
  List<DigiLockerDocument> get documents => _documents;
  String? get errorMessage => _errorMessage;
  double get fetchProgress => _fetchProgress;
  bool get isAuthenticated => _consentId != null;
  bool get hasDocuments => _documents.isNotEmpty;

  // Initiate DigiLocker OAuth consent flow
  Future<bool> initiateConsent() async {
    try {
      _status = DigiLockerStatus.authenticating;
      _errorMessage = null;
      notifyListeners();

      // Simulate OAuth redirect and consent
      await Future.delayed(const Duration(seconds: 2));

      // Generate mock consent ID
      _consentId = 'DGCONSENT_${DateTime.now().millisecondsSinceEpoch}';
      debugPrint('🔐 DigiLocker consent obtained: $_consentId');
      
      notifyListeners();
      return true;
    } catch (e) {
      _status = DigiLockerStatus.error;
      _errorMessage = 'Failed to authenticate with DigiLocker';
      notifyListeners();
      return false;
    }
  }

  // Fetch all documents from DigiLocker
  Future<bool> fetchDocuments(String studentId) async {
    if (_consentId == null) {
      await initiateConsent();
    }

    try {
      _status = DigiLockerStatus.fetchingDocuments;
      _documents = [];
      _fetchProgress = 0.0;
      notifyListeners();

      final documentTypes = [
        'Aadhaar Card',
        'Income Certificate',
        'Academic Certificate',
      ];

      // Simulate fetching each document with progress
      for (int i = 0; i < documentTypes.length; i++) {
        await Future.delayed(const Duration(milliseconds: 800));
        _fetchProgress = (i + 1) / documentTypes.length;
        debugPrint('📄 Fetched: ${documentTypes[i]} (${(_fetchProgress * 100).toInt()}%)');
        notifyListeners();
      }

      // Load mock documents
      _documents = MockData.getDocumentsForStudent(studentId);
      _status = DigiLockerStatus.completed;
      notifyListeners();

      debugPrint('✅ All documents fetched successfully');
      return true;
    } catch (e) {
      _status = DigiLockerStatus.error;
      _errorMessage = 'Failed to fetch documents from DigiLocker';
      notifyListeners();
      return false;
    }
  }

  // Get document by type
  DigiLockerDocument? getDocumentByType(DocumentType type) {
    try {
      return _documents.firstWhere((d) => d.type == type);
    } catch (_) {
      return null;
    }
  }

  // Verify document authenticity (mock)
  Future<bool> verifyDocument(String documentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final index = _documents.indexWhere((d) => d.id == documentId);
    if (index != -1) {
      _documents[index] = DigiLockerDocument(
        id: _documents[index].id,
        type: _documents[index].type,
        digiLockerId: _documents[index].digiLockerId,
        documentName: _documents[index].documentName,
        fetchedAt: _documents[index].fetchedAt,
        status: DocumentStatus.verified,
        extractedData: _documents[index].extractedData,
        isVerified: true,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Reset service state
  void reset() {
    _status = DigiLockerStatus.idle;
    _documents = [];
    _consentId = null;
    _errorMessage = null;
    _fetchProgress = 0.0;
    notifyListeners();
  }

  // Get extracted data from Aadhaar
  Map<String, dynamic>? getAadhaarData() {
    final aadhaar = getDocumentByType(DocumentType.aadhaar);
    return aadhaar?.extractedData;
  }

  // Get income from income certificate
  String? getIncomeFromCertificate() {
    final incomeCert = getDocumentByType(DocumentType.incomeCertificate);
    return incomeCert?.extractedData?['annualIncome'];
  }
}
