import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // 1. Keys and Controllers
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // 2. Simple Sign-Up Handler
  void _submitSignup() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Creating account for: ${_emailController.text}')),
      );
      // In a real app, you would call your registration service here.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🤝 SEAMLESS APPBAR (Same as Login Screen) 🤝
      appBar: AppBar(
        title: const Text(
          'Irvine Adventist School Gopalpur',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.w600,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Add a back button for navigation (implied since it's a separate screen)
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios, color: Colors.deepPurple),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32.0, 20.0, 32.0, 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 👤 BIG ICON (Theme Maintained) 👤
                  const Icon(
                    Icons
                        .how_to_reg_outlined, // A fitting icon for registration
                    size: 100,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill in your details to get started',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // 📝 NAME INPUT FIELD
                  _buildNameField(),
                  const SizedBox(height: 24),

                  // 📧 EMAIL INPUT FIELD (Same as Login)
                  _buildEmailField(),
                  const SizedBox(height: 24),

                  // 🔒 PASSWORD INPUT FIELD (Same as Login)
                  _buildPasswordField(),
                  const SizedBox(height: 24),

                  // 🔐 CONFIRM PASSWORD FIELD (NEW: Match Validation)
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 32),

                  // ✍️ SIGN UP BUTTON (Theme Maintained) ✍️
                  ElevatedButton(
                    onPressed: _submitSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Sign Up',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Already have an account? Link
                  // TextButton(
                  //   onPressed: () {
                  //     /* Handle navigation back to Login screen */
                  //   },
                  //   child: const Text(
                  //     'Already have an account? Login',
                  //     style: TextStyle(color: Colors.deepPurple),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Input Field Widgets and Validation Logic ---

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      decoration: _inputDecoration('Full Name', Icons.person_outline),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your full name.';
        }
        if (value.length < 3) {
          return 'Name must be at least 3 characters.';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Email Address', Icons.email_outlined),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email address.';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address.';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration:
          _inputDecoration('Password', Icons.lock_outline, isPassword: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password.';
        }
        if (value.length < 8) {
          // A slightly stronger length for sign up
          return 'Password must be at least 8 characters long.';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isPasswordVisible,
      decoration: _inputDecoration('Confirm Password', Icons.lock_reset,
          isPassword: true),
      // ⚠️ CRITICAL: Password Match Validation
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password.';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
  }

  // --- Modern Input Decoration Styling (Theme Maintained) ---

  InputDecoration _inputDecoration(String label, IconData icon,
      {bool isPassword = false}) {
    return InputDecoration(
      suffixIcon: isPassword
          ? IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              icon: Icon(_isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined))
          : null,
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
      filled: true,
      fillColor: Colors.deepPurple.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
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
    );
  }
}
