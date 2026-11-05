import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/enhanced_splash_screen.dart';
import 'screens/auth/enhanced_login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/dashboard/enhanced_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARE Construction & Builders',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const EnhancedSplashScreen(),
        '/login': (context) => const EnhancedLoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/dashboard': (context) => const EnhancedDashboardScreen(),

        // Placeholder routes for other modules (to be implemented)
        '/projects': (context) => const PlaceholderScreen(title: 'Projects'),
        '/add-project': (context) => const PlaceholderScreen(title: 'Add Project'),
        '/labour': (context) => const PlaceholderScreen(title: 'Labour'),
        '/add-labour': (context) => const PlaceholderScreen(title: 'Add Labour'),
        '/attendance': (context) => const PlaceholderScreen(title: 'Attendance'),
        '/inventory': (context) => const PlaceholderScreen(title: 'Inventory'),
        '/purchases': (context) => const PlaceholderScreen(title: 'Purchases'),
        '/income': (context) => const PlaceholderScreen(title: 'Income'),
        '/expenses': (context) => const PlaceholderScreen(title: 'Expenses'),
        '/reports': (context) => const PlaceholderScreen(title: 'Reports'),
        '/notifications': (context) => const PlaceholderScreen(title: 'Notifications'),
        '/settings': (context) => const PlaceholderScreen(title: 'Settings'),
      },
    );
  }
}

// Placeholder screen for routes not yet implemented
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              '$title Module',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'This module is under construction and will be available soon.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
