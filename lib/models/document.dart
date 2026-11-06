// DigiLocker Document Model
enum DocumentType {
  aadhaar,
  incomeCertificate,
  academicCertificate,
  casteCertificate,
  domicileCertificate,
  bankPassbook,
}

enum DocumentStatus {
  pending,
  fetched,
  verified,
  rejected,
}

class DigiLockerDocument {
  final String id;
  final DocumentType type;
  final String digiLockerId;
  final String documentName;
  final DateTime fetchedAt;
  final DocumentStatus status;
  final String? thumbnailUrl;
  final Map<String, dynamic>? extractedData;
  final bool isVerified;

  DigiLockerDocument({
    required this.id,
    required this.type,
    required this.digiLockerId,
    required this.documentName,
    required this.fetchedAt,
    this.status = DocumentStatus.fetched,
    this.thumbnailUrl,
    this.extractedData,
    this.isVerified = false,
  });

  factory DigiLockerDocument.fromJson(Map<String, dynamic> json) {
    return DigiLockerDocument(
      id: json['id'],
      type: DocumentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DocumentType.aadhaar,
      ),
      digiLockerId: json['digiLockerId'],
      documentName: json['documentName'],
      fetchedAt: DateTime.parse(json['fetchedAt']),
      status: DocumentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DocumentStatus.pending,
      ),
      thumbnailUrl: json['thumbnailUrl'],
      extractedData: json['extractedData'],
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'digiLockerId': digiLockerId,
      'documentName': documentName,
      'fetchedAt': fetchedAt.toIso8601String(),
      'status': status.name,
      'thumbnailUrl': thumbnailUrl,
      'extractedData': extractedData,
      'isVerified': isVerified,
    };
  }

  String get typeDisplayName {
    switch (type) {
      case DocumentType.aadhaar:
        return 'Aadhaar Card';
      case DocumentType.incomeCertificate:
        return 'Income Certificate';
      case DocumentType.academicCertificate:
        return 'Academic Certificate';
      case DocumentType.casteCertificate:
        return 'Caste Certificate';
      case DocumentType.domicileCertificate:
        return 'Domicile Certificate';
      case DocumentType.bankPassbook:
        return 'Bank Passbook';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case DocumentStatus.pending:
        return 'Pending';
      case DocumentStatus.fetched:
        return 'Fetched';
      case DocumentStatus.verified:
        return 'Verified';
      case DocumentStatus.rejected:
        return 'Rejected';
    }
  }
}
