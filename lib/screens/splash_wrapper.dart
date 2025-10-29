import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

/// SplashWrapper: The "Gatekeeper" - Handles app startup logic and routing
/// Checks authentication status and directs users to appropriate screens
class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final apiService = context.read<ApiService>();

      // Try to restore authentication
      await authProvider.initialize();

      if (!mounted) return;

      // Not authenticated -> Login screen
      if (!authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // Authenticated - check user role
      final user = authProvider.user!;

      // Teachers don't need enrollment
      if (user.role == 'teacher') {
        Navigator.pushReplacementNamed(context, '/home');
        return;
      }

      // Students need to be enrolled
      try {
        final enrollments = await apiService.getMyEnrollments();

        if (enrollments.isEmpty) {
          // Student is not enrolled -> Enrollment screen
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/enroll');
        } else {
          // Student is enrolled -> Home screen
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // If enrollment check fails, assume they need to enroll
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/enroll');
      }
    } catch (e) {
      // On any error, go to login
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // KIIT Logo
              Image.asset(
                'assets/KIIT.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              const Text(
                'KIIT SAP Portal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
