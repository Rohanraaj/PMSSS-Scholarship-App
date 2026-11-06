// Eligibility Engine - AI-Powered Scholarship Matching
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/scholarship.dart';
import '../models/document.dart';
import 'mock_data.dart';

class EligibilityResult {
  final Scholarship scholarship;
  final bool isEligible;
  final double matchScore;
  final List<String> eligibilityReasons;
  final List<String> unmetCriteria;

  EligibilityResult({
    required this.scholarship,
    required this.isEligible,
    required this.matchScore,
    required this.eligibilityReasons,
    required this.unmetCriteria,
  });
}

class RiskAssessment {
  final double riskScore;
  final String riskLevel;
  final String decision;
  final String explanation;
  final List<String> flags;

  RiskAssessment({
    required this.riskScore,
    required this.riskLevel,
    required this.decision,
    required this.explanation,
    required this.flags,
  });
}

class EligibilityService extends ChangeNotifier {
  List<EligibilityResult> _eligibleScholarships = [];
  RiskAssessment? _riskAssessment;
  bool _isProcessing = false;
  String? _selectedScholarshipId;

  List<EligibilityResult> get eligibleScholarships => _eligibleScholarships;
  RiskAssessment? get riskAssessment => _riskAssessment;
  bool get isProcessing => _isProcessing;
  String? get selectedScholarshipId => _selectedScholarshipId;

  Scholarship? get selectedScholarship {
    if (_selectedScholarshipId == null) return null;
    try {
      return _eligibleScholarships
          .firstWhere((e) => e.scholarship.id == _selectedScholarshipId)
          .scholarship;
    } catch (_) {
      return null;
    }
  }

  // Evaluate eligibility based on student data and documents
  Future<List<EligibilityResult>> evaluateEligibility({
    required String instituteName,
    required double annualIncome,
    required String umisId,
    required String? course,
    required List<DigiLockerDocument> documents,
  }) async {
    _isProcessing = true;
    _eligibleScholarships = [];
    notifyListeners();

    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 2));

    final results = <EligibilityResult>[];

    for (final scholarship in MockData.scholarships) {
      final eligibilityReasons = <String>[];
      final unmetCriteria = <String>[];
      double matchScore = 0;

      // Check income eligibility
      if (annualIncome <= scholarship.maxIncomeLimit) {
        eligibilityReasons.add('✓ Income within limit (₹${annualIncome.toStringAsFixed(0)} ≤ ₹${scholarship.maxIncomeLimit.toStringAsFixed(0)})');
        matchScore += 25;
      } else {
        unmetCriteria.add('✗ Income exceeds limit (₹${annualIncome.toStringAsFixed(0)} > ₹${scholarship.maxIncomeLimit.toStringAsFixed(0)})');
      }

      // Check institute eligibility
      bool instituteMatch = scholarship.eligibleInstitutes.any((inst) =>
          instituteName.toLowerCase().contains(inst.toLowerCase()) ||
          inst.toLowerCase() == 'any recognized institution' ||
          inst.toLowerCase() == 'all recognized institutions');
      
      if (instituteMatch) {
        eligibilityReasons.add('✓ Institute eligible ($instituteName)');
        matchScore += 25;
      } else {
        unmetCriteria.add('✗ Institute not in eligible list');
      }

      // Check documents
      bool hasRequiredDocs = documents.length >= 3;
      if (hasRequiredDocs) {
        eligibilityReasons.add('✓ All required documents available via DigiLocker');
        matchScore += 25;
      } else {
        unmetCriteria.add('✗ Missing required documents');
      }

      // Check UMIS ID validity
      if (umisId.isNotEmpty && umisId.startsWith('UMIS')) {
        eligibilityReasons.add('✓ Valid UMIS ID verified');
        matchScore += 15;
      } else {
        unmetCriteria.add('✗ Invalid UMIS ID format');
      }

      // Special checks for specific scholarships
      if (scholarship.id == 'PMSSS001') {
        // PMSSS requires J&K domicile
        final hasDomicile = documents.any((d) => d.type == DocumentType.domicileCertificate);
        if (hasDomicile) {
          eligibilityReasons.add('✓ J&K/Ladakh domicile verified');
          matchScore += 10;
        } else {
          unmetCriteria.add('✗ J&K/Ladakh domicile required for PMSSS');
        }
      }

      bool isEligible = unmetCriteria.isEmpty;

      results.add(EligibilityResult(
        scholarship: scholarship,
        isEligible: isEligible,
        matchScore: matchScore,
        eligibilityReasons: eligibilityReasons,
        unmetCriteria: unmetCriteria,
      ));
    }

    // Sort by match score
    results.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    _eligibleScholarships = results.where((r) => r.isEligible).toList();
    _isProcessing = false;
    notifyListeners();

    debugPrint('🎯 Found ${_eligibleScholarships.length} eligible scholarships');
    return _eligibleScholarships;
  }

  // Perform AI risk assessment
  Future<RiskAssessment> assessRisk({
    required String studentId,
    required double annualIncome,
    required List<DigiLockerDocument> documents,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final flags = <String>[];
    double riskScore = 0;

    // Check for anomalies
    if (annualIncome < 50000) {
      flags.add('Very low income declared - requires verification');
      riskScore += 15;
    }

    // Check document verification status
    final unverifiedDocs = documents.where((d) => !d.isVerified).length;
    if (unverifiedDocs > 0) {
      flags.add('$unverifiedDocs document(s) pending verification');
      riskScore += unverifiedDocs * 5;
    }

    // Check for duplicate applications (mock check)
    bool isDuplicate = false; // In real app, check database
    if (isDuplicate) {
      flags.add('Possible duplicate application detected');
      riskScore += 40;
    }

    // Determine risk level
    String riskLevel;
    String decision;
    if (riskScore < 20) {
      riskLevel = 'Low';
      decision = 'RECOMMENDED FOR APPROVAL';
    } else if (riskScore < 50) {
      riskLevel = 'Medium';
      decision = 'REQUIRES MANUAL REVIEW';
    } else {
      riskLevel = 'High';
      decision = 'FLAGGED - INVESTIGATION REQUIRED';
    }

    _riskAssessment = RiskAssessment(
      riskScore: riskScore,
      riskLevel: riskLevel,
      decision: decision,
      explanation: _generateExplanation(riskLevel, flags, documents.length),
      flags: flags,
    );

    notifyListeners();
    return _riskAssessment!;
  }

  String _generateExplanation(String riskLevel, List<String> flags, int docCount) {
    if (riskLevel == 'Low') {
      return 'All documents verified via DigiLocker ($docCount documents). '
          'Income within eligible range. No duplicate applications found. '
          'Identity verified through Aadhaar. Application is compliant with all eligibility criteria.';
    } else if (riskLevel == 'Medium') {
      return 'Application requires additional review. ${flags.join('. ')}. '
          'Please verify flagged items before approval.';
    } else {
      return 'High-risk application detected. ${flags.join('. ')}. '
          'Investigation and manual verification required before processing.';
    }
  }

  // Select a scholarship
  void selectScholarship(String scholarshipId) {
    _selectedScholarshipId = scholarshipId;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedScholarshipId = null;
    notifyListeners();
  }

  // Reset service
  void reset() {
    _eligibleScholarships = [];
    _riskAssessment = null;
    _isProcessing = false;
    _selectedScholarshipId = null;
    notifyListeners();
  }
}
