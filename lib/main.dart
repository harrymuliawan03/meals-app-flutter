import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:meals_app/screens/layout/layout.dart';
import 'package:meals_app/screens/login_screen.dart';
import 'package:meals_app/service/local_storage_service.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color.fromARGB(255, 167, 49, 147),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

// initilization storage

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final role = LocalStorage.getStringData('role');
    return MaterialApp(
      theme: theme,
      home: role != null ? const Layout() : const LoginScreen(),
    );
  }
}
