import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isVisible = true;
  // 1. Key for Form Validation
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 2. Simple Login Handler
  void _submitLogin() {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a message (or navigate/authenticate).
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Processing Login for: ${_emailController.text}')),
      );
      // In a real app, you would call your authentication service here.
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🚀 APPBAR MODIFICATION START 🚀
      appBar: AppBar(
        title: const Text(
          'Irvine Adventist School Gopalpur',
          style: TextStyle(
            color: Colors.deepPurple, // Use the accent color for the title
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        centerTitle: true, // Centers the title for better modern aesthetics
        backgroundColor:
            Colors.transparent, // Makes the AppBar background invisible
        elevation: 0, // Removes the shadow for a seamless blend
      ),
      // Ensure the keyboard doesn't push the screen content
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 3. Title/Logo Section
                  Icon(
                    Icons
                        .person_pin_circle_outlined, // A friendly, modern login icon
                    size: 100, // Make it big!
                    color: Colors.deepPurple, // Use our accent color
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to continue',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 4. Email Input Field (with Validation)
                  _buildEmailField(),
                  const SizedBox(height: 24),

                  // 5. Password Input Field (with Validation)
                  _buildPasswordField(),
                  const SizedBox(height: 32),

                  // 6. Login Button
                  ElevatedButton(
                    onPressed: _submitLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Modern rounded corners
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 7. Forgot Password / Register Link
                  TextButton(
                    onPressed: () {
                      /* Handle navigation to Forgot Password screen */
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Input Field Widgets and Validation Logic ---

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Email Address', Icons.email_outlined),
      // ⚠️ VALIDATION LOGIC 1: Email
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email address.';
        }
        // Simple regex check for email format
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
        return null; // Return null if the input is valid
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      onTap: () {
        setState(() {
          _isVisible = !_isVisible;
        });
      },
      controller: _passwordController,
      obscureText: !_isVisible,
      decoration:
          _inputDecoration('Password', Icons.lock_outline, isPassword: true),
      // ⚠️ VALIDATION LOGIC 2: Password
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password.';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long.';
        }
        return null; // Return null if the input is valid
      },
    );
  }

  // --- Modern Input Decoration Styling ---

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool isPassword = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
      // Modern styling with filled color and clean borders
      filled: true,
      fillColor: Colors.deepPurple.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide.none, // Hide the default border for a cleaner look
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              icon: Icon(_isVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined))
          : null,
    );
  }
}
