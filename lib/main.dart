import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'ui/screens/dashboard_screen.dart';

void main() => runApp(const AntasenaApp());

class AntasenaApp extends StatelessWidget {
  const AntasenaApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antasena Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background, // Background gelap
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryAccent,
          surface: AppColors.cardBg,
        ),
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(), // Nah, ini yang manggil layar buatan lu!
    );
  }
}