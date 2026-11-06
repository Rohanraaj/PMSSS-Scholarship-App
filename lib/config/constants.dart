// PMSSS Scholarship App - Constants
// App-wide configuration values

class AppConstants {
  // App Info
  static const String appName = 'PMSSS Scholarship';
  static const String appVersion = '1.0.0';
  
  // API Endpoints (Mock)
  static const String baseUrl = 'https://api.pmsss.gov.in/v1';
  static const String digiLockerUrl = 'https://digilocker.gov.in';
  
  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // OTP Settings
  static const int otpLength = 6;
  static const int otpExpirySeconds = 120;
  
  // Session
  static const int sessionTimeoutMinutes = 30;
  
  // Pagination
  static const int defaultPageSize = 20;
}

class AppColors {
  // Primary Blue Professional Palette
  static const int primaryStart = 0xFF2563EB;  // Professional Blue
  static const int primaryEnd = 0xFF1D4ED8;    // Darker Blue
  static const int primaryLight = 0xFF3B82F6;  // Light Blue
  
  // Secondary
  static const int secondary = 0xFF10B981;     // Emerald
  static const int secondaryLight = 0xFF34D399;
  
  // Status Colors
  static const int success = 0xFF22C55E;
  static const int warning = 0xFFF59E0B;
  static const int error = 0xFFEF4444;
  static const int info = 0xFF3B82F6;
  
  // Light Theme Colors (Professional White/Blue)
  static const int backgroundDark = 0xFF0F172A;
  static const int backgroundLight = 0xFFFFFFFF;    // Pure white background
  static const int surfaceDark = 0xFF1E293B;
  static const int surfaceLight = 0xFFFFFFFF;       // White surface
  static const int textDark = 0xFF1E293B;           // Dark text for light theme
  static const int textLight = 0xFFF1F5F9;          // Light text for dark areas
  static const int textMuted = 0xFF64748B;          // Muted gray text
  static const int textSecondary = 0xFF94A3B8;      // Secondary text
  
  // Card & Border Colors
  static const int cardWhite = 0xFFFFFFFF;
  static const int border = 0xFFE2E8F0;             // Light border
  static const int divider = 0xFFE5E7EB;
  
  // Role Selection Colors
  static const int roleSelected = 0xFF2563EB;
  static const int roleUnselected = 0xFFFFFFFF;
  static const int roleBorder = 0xFFE2E8F0;
  
  // Glassmorphism (for blue header areas)
  static const int glassBackground = 0x1AFFFFFF;
  static const int glassBorder = 0x33FFFFFF;
}

class AppSizes {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 100.0;
  
  // Font Sizes
  static const double fontXs = 12.0;
  static const double fontSm = 14.0;
  static const double fontMd = 16.0;
  static const double fontLg = 18.0;
  static const double fontXl = 24.0;
  static const double fontXxl = 32.0;
  static const double fontDisplay = 48.0;
  
  // Icon Sizes
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
}

class AssetPaths {
  static const String logo = 'assets/images/logo.png';
  static const String digilockerLogo = 'assets/images/digilocker.png';
  static const String scholarshipBg = 'assets/images/scholarship_bg.png';
}
