import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'ui/screens/dashboard_screen.dart';
import 'ui/screens/auth/login_screen.dart';
import 'data/api_service.dart';

void main() async {
  // Wajib dipanggil jika kita pakai 'await' di dalam main() sebelum runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ambil token dari memori perangkat (Shared Preferences)
  await ApiService.init();

  runApp(const AntasenaApp());
}

class AntasenaApp extends StatelessWidget {
  const AntasenaApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AIRA Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background, 
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryAccent,
          surface: AppColors.cardBg,
        ),
        fontFamily: 'Roboto', 
      ),
      // --- LOGIKA AUTO-LOGIN ---
      // Jika token ada di memori -> Langsung ke Dashboard
      // Jika token kosong (belum login / sudah di-logout) -> Ke LoginScreen
      home: ApiService.isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}