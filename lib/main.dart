// PMSSS Scholarship App - Main Entry Point
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'services/auth_service.dart';
import 'services/digilocker_service.dart';
import 'services/eligibility_service.dart';
import 'services/application_service.dart';
import 'screens/student/auth_screen.dart';
import 'screens/student/student_registration_screen.dart';
import 'screens/student/student_dashboard_screen.dart';
import 'screens/student/basic_details_screen.dart';
import 'screens/student/digilocker_screen.dart';
import 'screens/student/eligibility_screen.dart';
import 'screens/student/confirmation_screen.dart';
import 'screens/student/tracking_screen.dart';
import 'screens/sag_officer/sag_dashboard_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PMSSSScholarshipApp());
}

class PMSSSScholarshipApp extends StatelessWidget {
  const PMSSSScholarshipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => DigiLockerService()),
        ChangeNotifierProvider(create: (_) => EligibilityService()),
        ChangeNotifierProvider(create: (_) => ApplicationService()),
      ],
      child: MaterialApp(
        title: 'PMSSS Scholarship',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthScreen(),
          // Student routes
          '/student/register': (context) => const StudentRegistrationScreen(),
          '/student/dashboard': (context) => const StudentDashboardScreen(),
          '/student/basic-details': (context) => const BasicDetailsScreen(),
          '/student/digilocker': (context) => const DigiLockerScreen(),
          '/student/eligibility': (context) => const EligibilityScreen(),
          '/student/confirmation': (context) => const ConfirmationScreen(),
          '/student/tracking': (context) => const TrackingScreen(),
          // SAG Officer routes
          '/sag/dashboard': (context) => const SagDashboardScreen(),
          // Admin routes
          '/admin/dashboard': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}
