// User Model with Role-Based Access
import 'package:flutter/foundation.dart';

enum UserRole { student, admin, sagOfficer }

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class User {
  final String id;
  final String email;
  final String phone;
  final String name;
  final UserRole role;
  final bool biometricEnabled;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.name,
    required this.role,
    this.biometricEnabled = false,
    this.profileImageUrl,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.student,
      ),
      biometricEnabled: json['biometricEnabled'] ?? false,
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'role': role.name,
      'biometricEnabled': biometricEnabled,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    UserRole? role,
    bool? biometricEnabled,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  String get roleDisplayName {
    switch (role) {
      case UserRole.student:
        return 'Student';
      case UserRole.admin:
        return 'Administrator';
      case UserRole.sagOfficer:
        return 'SAG Officer';
    }
  }
}
