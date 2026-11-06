// Scholarship Model
class Scholarship {
  final String id;
  final String name;
  final String description;
  final double maxIncomeLimit;
  final List<String> eligibleInstitutes;
  final List<String> eligibleCourses;
  final List<String> eligibleCategories;
  final double scholarshipAmount;
  final String duration;
  final DateTime applicationDeadline;
  final bool isActive;
  final String? iconPath;

  Scholarship({
    required this.id,
    required this.name,
    required this.description,
    required this.maxIncomeLimit,
    required this.eligibleInstitutes,
    required this.eligibleCourses,
    required this.eligibleCategories,
    required this.scholarshipAmount,
    required this.duration,
    required this.applicationDeadline,
    this.isActive = true,
    this.iconPath,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    return Scholarship(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      maxIncomeLimit: (json['maxIncomeLimit'] as num).toDouble(),
      eligibleInstitutes: List<String>.from(json['eligibleInstitutes'] ?? []),
      eligibleCourses: List<String>.from(json['eligibleCourses'] ?? []),
      eligibleCategories: List<String>.from(json['eligibleCategories'] ?? []),
      scholarshipAmount: (json['scholarshipAmount'] as num).toDouble(),
      duration: json['duration'],
      applicationDeadline: DateTime.parse(json['applicationDeadline']),
      isActive: json['isActive'] ?? true,
      iconPath: json['iconPath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'maxIncomeLimit': maxIncomeLimit,
      'eligibleInstitutes': eligibleInstitutes,
      'eligibleCourses': eligibleCourses,
      'eligibleCategories': eligibleCategories,
      'scholarshipAmount': scholarshipAmount,
      'duration': duration,
      'applicationDeadline': applicationDeadline.toIso8601String(),
      'isActive': isActive,
      'iconPath': iconPath,
    };
  }

  String get formattedAmount => '₹${scholarshipAmount.toStringAsFixed(0)}';
  
  bool get isExpired => DateTime.now().isAfter(applicationDeadline);
}
