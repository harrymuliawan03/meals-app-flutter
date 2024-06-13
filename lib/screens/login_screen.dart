// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:meals_app/screens/layout/layout.dart';
import 'package:meals_app/screens/register_screen.dart';
import 'package:meals_app/service/auth_service.dart';
import 'package:meals_app/service/local_storage_service.dart';
import 'package:meals_app/widgets/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool valueCheck = false;
  bool isHidePassword = true;
  bool isLoading = false;
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void fetchLogin(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar(context, 'Field Email / Password wajib diisi');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var response = await authService.loginService(email, password);
      if (response.valid) {
        await LocalStorage.saveData<String>('role', response.role!);
        await LocalStorage.saveData<String>('user_name', response.name!);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Layout(),
          ),
        );
      } else {
        showCustomSnackbar(context, 'Email / Password salah');
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: (appTopHeight + appBarHeight)),
            // title
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
            const Text('Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            const Text('Sign in to start your session',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                )),
            const SizedBox(height: 40),
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
                isLoading ? null : fetchLogin(context);
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
                  const Text('Login')
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () async {
                final res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));

                if (res) {
                  showCustomSuccessSnackbar(
                      context, 'Register Succes, silahkan login');
                }
              },
              child: const Text(
                "Don't have account? Register now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
