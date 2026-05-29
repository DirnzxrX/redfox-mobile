import 'package:flutter/material.dart';
import 'dart:ui' as ui;

// Import ApiService yang memanggil HTTP POST
import '../../../data/api_service.dart';
import '../dashboard_screen.dart'; 

// --- TEMA KHUSUS CYBER DASHBOARD ---
class CyberTheme {
  static const Color background = Color(0xFF040A15);
  static const Color cardBg = Color(0xFF0A1326);
  static const Color border = Color(0xFF162545);
  static const Color cyan = Color(0xFF00D2FF);
  static const Color green = Color(0xFF00E676);
  static const Color red = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  static const Color textMain = Colors.white;
  static const Color textSec = Color(0xFF7A8Baa);
  static const Color darkBlue = Color(0xFF1A365D);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Controller kosong, user harus ngetik manual "admin" dan "password"
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // --- FUNGSI LOGIN REAL API ---
  Future<void> _handleLogin() async {
    final username = _idController.text.trim();
    final password = _passController.text.trim();

    // 1. Cek apakah ada kolom yang kosong
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: CyberTheme.red.withOpacity(0.9),
          content: const Text('SYSTEM ERROR: Credentials required.', style: TextStyle(color: Colors.white, fontFamily: 'monospace')),
        ),
      );
      return;
    }

    // 2. Mulai animasi loading
    setState(() {
      _isLoading = true;
    });

    // 3. Panggil API beneran lewat ApiService
    final result = await ApiService.login(username, password);

    // Pastikan widget masih ada sebelum pindah layar
    if (!mounted) return;

    // 4. Cek hasil dari server
    if (result['success'] == true) {
      // Login sukses! Pindah ke Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      // Login gagal (salah password atau server mati)
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: CyberTheme.red.withOpacity(0.9),
          content: Text(result['message'], style: const TextStyle(color: Colors.white, fontFamily: 'monospace')),
        ),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      body: Stack(
        children: [
          // --- BACKGROUND GLOW EFFECTS ---
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(shape: BoxShape.circle, color: CyberTheme.cyan.withOpacity(0.1)),
              child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container()),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(shape: BoxShape.circle, color: CyberTheme.darkBlue.withOpacity(0.3)),
              child: BackdropFilter(filter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 100), child: Container()),
            ),
          ),
          
          // --- GRID PATTERN OVERLAY ---
          Positioned.fill(
            child: CustomPaint(painter: GridPainter()),
          ),

          // --- MAIN CONTENT ---
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LOGO & SYSTEM NAME
                    const Icon(Icons.public, color: CyberTheme.cyan, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'AIRA',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CyberTheme.cyan, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 4.0),
                    ),
                    const Text(
                      'Advanced Intelligence\nRecon & Analytics',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CyberTheme.textSec, fontSize: 12, height: 1.5, letterSpacing: 2.0),
                    ),
                    const SizedBox(height: 48),

                    // STATUS TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: CyberTheme.warning, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Text('[ SYSTEM LOCKED : AWAITING CREDENTIALS ]', style: TextStyle(color: CyberTheme.warning, fontSize: 10, fontFamily: 'monospace', letterSpacing: 1.0)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // INPUT FIELD: USERNAME
                    _buildTextField(
                      controller: _idController,
                      label: 'Username / Analyst ID',
                      icon: Icons.badge_outlined,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),

                    // INPUT FIELD: PASSWORD
                    _buildTextField(
                      controller: _passController,
                      label: 'Security Passcode',
                      icon: Icons.lock_outline,
                      obscureText: !_isPasswordVisible,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),

                    // FORGOT PASSWORD
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Request Access Override?', style: TextStyle(color: CyberTheme.textSec, fontSize: 10)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // AUTHENTICATE BUTTON
                    InkWell(
                      onTap: _isLoading ? null : _handleLogin,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: CyberTheme.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: CyberTheme.cyan),
                          boxShadow: [
                            BoxShadow(color: CyberTheme.cyan.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)
                          ]
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(color: CyberTheme.cyan, strokeWidth: 2),
                                )
                              : const Text(
                                  'AUTHENTICATE',
                                  style: TextStyle(color: CyberTheme.cyan, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // FOOTER DISCLAIMER
                    const Text(
                      'WARNING: UNAUTHORIZED ACCESS TO THIS SYSTEM IS STRICTLY PROHIBITED AND MONITORED BY TNI AU CYBER COMMAND.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: CyberTheme.red, fontSize: 8, fontFamily: 'monospace', height: 1.5),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: CyberTheme.textMain, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: CyberTheme.cardBg,
        labelText: label,
        labelStyle: const TextStyle(color: CyberTheme.textSec, fontSize: 12),
        prefixIcon: Icon(icon, color: CyberTheme.cyan, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: CyberTheme.textSec,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CyberTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: CyberTheme.cyan),
        ),
      ),
    );
  }
}

// --- BACKGROUND GRID PAINTER ---
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double spacing = 30.0;
    
    // Vertical lines
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    // Horizontal lines
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}