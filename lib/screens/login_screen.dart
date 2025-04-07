import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';
import 'register_screen.dart';
import 'admin_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;
  bool _passwordVisible = false;
  bool _isAdminLogin = false;

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  // Updated login persistence in login_screen.dart
  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('rememberMe') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final isAdmin = prefs.getBool('isAdmin') ?? false;

    if (remember && isLoggedIn) {
      if (isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
      } else {
        final email = prefs.getString('email') ?? '';
        final rollNumber = email.split('@')[0];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(rollNumber: rollNumber)),
        );
      }
    } else {
      setState(() {
        _rememberMe = remember;
        if (_rememberMe) {
          _emailController.text = prefs.getString('email') ?? '';
        }
      });
    }
  }


  bool _isValidKiitEmail(String email) {
    return email.toLowerCase().endsWith('@kiit.ac.in');
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      if (_isAdminLogin) {
        final adminEmail = _adminEmailController.text.trim();
        final adminPassword = _adminPasswordController.text.trim();

        if (adminEmail == 'admin@gmail.com' && adminPassword == 'kiit123') {
          if (_rememberMe) {
            await prefs.setBool('rememberMe', true);
            await prefs.setBool('isLoggedIn', true);
            await prefs.setBool('isAdmin', true);
          } else {
            await prefs.clear();
          }

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                (route) => false,
          );
        } else {
          throw Exception('Invalid admin credentials');
        }
      } else {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        if (!_isValidKiitEmail(email)) {
          throw Exception('Only for Lovable KIITIANS');
        }

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (_rememberMe) {
          await prefs.setString('email', email);
          await prefs.setBool('rememberMe', true);
          await prefs.setBool('isLoggedIn', true);
          await prefs.setBool('isAdmin', false);
        } else {
          await prefs.clear();
        }

        final rollNumber = email.split('@')[0];

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(rollNumber: rollNumber)),
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('Lovable KIITIANS')
                ? 'Only for Lovable KIITIANS'
                : 'Login failed: ${e.toString().replaceAll('Exception:', '').trim()}',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/KIIT.png', width: 80, height: 80),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Student Login'),
                          Switch(
                            value: _isAdminLogin,
                            onChanged: (val) => setState(() => _isAdminLogin = val),
                          ),
                          const Text('Admin Login'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      if (!_isAdminLogin) ...[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'KIIT Email',
                            prefixIcon: const Icon(Icons.email),
                            helperText: 'Use your @kiit.ac.in email',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Please enter your email';
                            if (!_isValidKiitEmail(val)) return 'Invalid KIIT email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (val) =>
                          val == null || val.isEmpty ? 'Please enter your password' : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (val) => setState(() => _rememberMe = val!),
                            ),
                            const Text('Remember Me'),
                          ],
                        ),
                      ],

                      if (_isAdminLogin) ...[
                        TextFormField(
                          controller: _adminEmailController,
                          decoration: InputDecoration(
                            labelText: 'Admin Email',
                            prefixIcon: const Icon(Icons.admin_panel_settings),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (val) =>
                          val == null || val.isEmpty ? 'Enter admin email' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _adminPasswordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Admin Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (val) =>
                          val == null || val.isEmpty ? 'Enter admin password' : null,
                        ),
                      ],

                      const SizedBox(height: 18),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(_isAdminLogin ? 'Login as Admin' : 'Login'),
                      ),
                      const SizedBox(height: 12),
                      if (!_isAdminLogin)
                        TextButton(
                          onPressed: _navigateToRegister,
                          child: const Text("Don't have an account? Register"),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
