import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meals_app/screens/layout/layout.dart';
import 'package:meals_app/screens/login_screen.dart';
import 'package:meals_app/service/local_storage_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = LocalStorage.getStringData('role');

    return AnimatedSplashScreen(
      splash: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const Text(
              'Resepku',
              style: TextStyle(
                color: Color(0xFF8A94DB),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: Center(
                child: LottieBuilder.network(
                    'https://lottie.host/1805edd2-fa95-485c-90b5-1ac8ef3b9659/vzghrk8AcX.json'),
              ),
            ),
          ],
        ),
      ),
      nextScreen: role != null ? const Layout() : const LoginScreen(),
      splashIconSize: 400,
      // backgroundColor: Theme.of(context).colorScheme.onPrimary,
    );
  }
}
