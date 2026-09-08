import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ReasonsApp());
}

class ReasonsApp extends StatelessWidget {
  const ReasonsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '100 Reasons',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
