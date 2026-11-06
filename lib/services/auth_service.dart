// Authentication Service with JWT and Biometric Support
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'mock_data.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _sessionToken;
  bool _isBiometricAvailable = true;
  String? _pendingOtpPhone;
  String _generatedOtp = '';

  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isBiometricAvailable => _isBiometricAvailable;
  String? get pendingOtpPhone => _pendingOtpPhone;

  // Send OTP to phone number
  Future<bool> sendOtp(String phoneOrEmail) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Check if user exists
      final user = MockData.getUserByPhoneOrEmail(phoneOrEmail);
      if (user != null) {
        _pendingOtpPhone = phoneOrEmail;
        // Generate a mock OTP (in real app, this would be sent via SMS)
        _generatedOtp = '123456'; // Mock OTP for demo
        debugPrint('📱 OTP sent to $phoneOrEmail: $_generatedOtp');
        notifyListeners();
        return true;
      }
      
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // Simulate API verification
      await Future.delayed(const Duration(milliseconds: 800));

      // For demo, accept '123456' as valid OTP
      if (otp == _generatedOtp || otp == '123456') {
        final user = MockData.getUserByPhoneOrEmail(_pendingOtpPhone ?? '');
        if (user != null) {
          _currentUser = user;
          _sessionToken = 'JWT_TOKEN_${DateTime.now().millisecondsSinceEpoch}';
          _status = AuthStatus.authenticated;
          _pendingOtpPhone = null;
          notifyListeners();
          return true;
        }
      }

      _status = AuthStatus.error;
      notifyListeners();
      return false;
    } catch (e) {
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Biometric authentication
  Future<bool> authenticateWithBiometric() async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      // Simulate biometric check
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo, auto-authenticate as last logged in user
      if (_currentUser != null && _currentUser!.biometricEnabled) {
        _sessionToken = 'JWT_BIOMETRIC_${DateTime.now().millisecondsSinceEpoch}';
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }

      // Default to student user for demo
      _currentUser = MockData.users.firstWhere(
        (u) => u.role == UserRole.student,
      );
      _sessionToken = 'JWT_BIOMETRIC_${DateTime.now().millisecondsSinceEpoch}';
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Login with role (for demo/testing)
  Future<bool> loginAsRole(UserRole role) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 500));

      _currentUser = MockData.users.firstWhere((u) => u.role == role);
      _sessionToken = 'JWT_DEMO_${DateTime.now().millisecondsSinceEpoch}';
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Enable biometric for current user
  Future<bool> enableBiometric() async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(biometricEnabled: true);
      notifyListeners();
      return true;
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    _currentUser = null;
    _sessionToken = null;
    _status = AuthStatus.unauthenticated;
    _pendingOtpPhone = null;
    notifyListeners();
  }

  // Check session validity
  bool isSessionValid() {
    return _sessionToken != null && _currentUser != null;
  }

  // Get authorization header
  Map<String, String> getAuthHeaders() {
    return {
      'Authorization': 'Bearer $_sessionToken',
      'Content-Type': 'application/json',
    };
  }
}
