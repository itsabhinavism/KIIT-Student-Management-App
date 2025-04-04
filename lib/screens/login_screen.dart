import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart'; // Student Home
import 'register_screen.dart'; // Registration screen
import 'admin_home_screen.dart'; // Admin Home

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
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
      }
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isAdminLogin) {
        if (_adminEmailController.text.trim() == 'admin@gmail.com' &&
            _adminPasswordController.text.trim() == 'kiit123') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
          );
        } else {
          throw Exception('Invalid admin credentials');
        }
      } else {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          await prefs.setBool('rememberMe', _rememberMe);
          await prefs.setBool('isLoggedIn', true);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                      Image.asset(
                          'assets/KIIT.png',
                          width: 80,
                          height: 80,
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Student Login'),
                          Switch(
                            value: _isAdminLogin,
                            onChanged: (value) => setState(() => _isAdminLogin = value),
                          ),
                          const Text('Admin Login'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (!_isAdminLogin) ...[
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your email' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter your password' : null,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (val) => setState(() => _rememberMe = val!),
                            ),
                            const Text('Remember Me'),
                          ],
                        ),
                      ] else ...[
                        TextFormField(
                          controller: _adminEmailController,
                          decoration: InputDecoration(
                            labelText: 'Admin Email',
                            prefixIcon: const Icon(Icons.admin_panel_settings),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter admin email' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _adminPasswordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Admin Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter admin password'
                              : null,
                        ),
                      ],
                      const SizedBox(height: 24),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                        onPressed: _login,
                        child: Text(_isAdminLogin ? 'Login as Admin' : 'Login'),
                      ),
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
