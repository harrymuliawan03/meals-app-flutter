// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:meals_app/screens/layout/layout.dart';
import 'package:meals_app/service/auth_service.dart';
import 'package:meals_app/service/local_storage_service.dart';
import 'package:meals_app/widgets/custom_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool valueCheck = false;
  bool isHidePassword = true;
  bool isLoading = false;
  final AuthService authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void postRegister(BuildContext context) async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      showCustomSnackbar(context, 'Field Email / Password wajib diisi');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await authService.registerService(name, email, password);
      if (response) {
        Navigator.pop(context);
      } else {
        showCustomSnackbar(context, 'Email sudah terdaftar');
      }
    } catch (e) {
      showCustomSnackbar(context, e.toString());
    }

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double appTopHeight = MediaQuery.of(context).padding.top;
    double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: (appTopHeight + appBarHeight)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Resepku !',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 30,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text('Register',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            const Text('Sign up to start your session',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                )),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: isHidePassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isHidePassword = !isHidePassword;
                    });
                  },
                  icon: Icon(
                      isHidePassword ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                isLoading ? null : postRegister(context);
              },
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 2,
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: isLoading ? Colors.grey : Colors.blue),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  SizedBox(width: isLoading ? 8 : 0),
                  const Text('Register')
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                "Already have account? Login now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
