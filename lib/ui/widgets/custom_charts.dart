import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme.dart';

// ==========================================
// AREA CHART (TIMELINE ANALYTICS)
// ==========================================
class AreaChartWidget extends StatelessWidget {
  const AreaChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AreaChartPainter(),
    );
  }
}

class AreaChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient Hijau (Positive)
    final paintGreen = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.positive.withOpacity(0.5), AppColors.positive.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, 0, size.height))
      ..style = PaintingStyle.fill;

    // Garis Hijau Neon
    final strokeGreen = Paint()
      ..color = AppColors.positive
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Gradient Merah (Negative)
    final paintRed = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.negative.withOpacity(0.5), AppColors.negative.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, 0, size.height))
      ..style = PaintingStyle.fill;

    // Garis Merah Neon
    final strokeRed = Paint()
      ..color = AppColors.negative
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Path Hijau (Atas)
    final pathGreen = Path();
    pathGreen.moveTo(0, size.height * 0.5);
    pathGreen.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.4);
    pathGreen.quadraticBezierTo(size.width * 0.6, size.height * 0.6, size.width * 0.8, size.height * 0.3);
    pathGreen.quadraticBezierTo(size.width * 0.9, size.height * 0.15, size.width, size.height * 0.2);
    
    // Simpan path untuk garis sebelum ditutup
    final pathGreenStroke = Path.from(pathGreen);
    
    pathGreen.lineTo(size.width, size.height);
    pathGreen.lineTo(0, size.height);
    pathGreen.close();

    // Path Merah (Bawah)
    final pathRed = Path();
    pathRed.moveTo(0, size.height * 0.7);
    pathRed.quadraticBezierTo(size.width * 0.25, size.height * 0.6, size.width * 0.5, size.height * 0.8);
    pathRed.quadraticBezierTo(size.width * 0.75, size.height * 1.0, size.width, size.height * 0.6);
    
    // Simpan path untuk garis sebelum ditutup
    final pathRedStroke = Path.from(pathRed);

    pathRed.lineTo(size.width, size.height);
    pathRed.lineTo(0, size.height);
    pathRed.close();

    // Gambar area (fill) dan garis (stroke)
    canvas.drawPath(pathGreen, paintGreen);
    canvas.drawPath(pathGreenStroke, strokeGreen);
    
    canvas.drawPath(pathRed, paintRed);
    canvas.drawPath(pathRedStroke, strokeRed);

    // Garis sumbu X dan Y (halus/transparan)
    final axisPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint); // X
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), axisPaint); // Y
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ==========================================
// PIE CHART (RADIAL / SOURCE DISTRIBUTION)
// ==========================================
class GenderPieChart extends StatelessWidget {
  const GenderPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(120, 120),
        painter: PieChartPainter(),
        child: const SizedBox(
          width: 120,
          height: 120,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '1,662',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textMain),
                ),
                Text(
                  'Total',
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    // YouTube (Merah)
    final paint1 = Paint()..color = AppColors.youtube..style = PaintingStyle.fill;
    // Instagram (Ungu/Pink)
    final paint2 = Paint()..color = AppColors.instagram..style = PaintingStyle.fill;
    // X / Twitter (Biru Muda)
    final paint3 = Paint()..color = AppColors.xTwitter..style = PaintingStyle.fill;
    // News (Biru)
    final paint4 = Paint()..color = AppColors.news..style = PaintingStyle.fill;

    // Start angle is -pi/2 (top center)
    double startAngle = -math.pi / 2;
    
    // Potongan 1 (40%)
    double sweep1 = (40 / 100) * 2 * math.pi;
    canvas.drawArc(rect, startAngle, sweep1, true, paint1);
    
    // Potongan 2 (30%)
    double sweep2 = (30 / 100) * 2 * math.pi;
    canvas.drawArc(rect, startAngle + sweep1, sweep2, true, paint2);
    
    // Potongan 3 (20%)
    double sweep3 = (20 / 100) * 2 * math.pi;
    canvas.drawArc(rect, startAngle + sweep1 + sweep2, sweep3, true, paint3);

    // Potongan 4 (10%)
    double sweep4 = (10 / 100) * 2 * math.pi;
    canvas.drawArc(rect, startAngle + sweep1 + sweep2 + sweep3, sweep4, true, paint4);
    
    // Lubang di tengah untuk efek Donut chart (sesuai warna background card)
    final paintHole = Paint()..color = AppColors.background.withOpacity(0.5);
    canvas.drawCircle(center, radius * 0.75, paintHole);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}