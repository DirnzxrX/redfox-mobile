import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // <-- Tambahan untuk deteksi mouse
import '../../core/theme.dart';
import '../widgets/dashboard_card.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'dart:math' as math;

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('A',
                  style: TextStyle(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('AIRA',
                      style: TextStyle(
                          color: AppColors.textMain,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                  Text('Advanced Intelligence Recon & Analysis',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 8),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
            onPressed: () {},
          ),
          // Indikator LIVE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.positive.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(color: AppColors.positive, shape: BoxShape.circle),
                ),
                const SizedBox(width: 4),
                const Text('LIVE', style: TextStyle(color: AppColors.positive, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            offset: const Offset(0, 45),
            color: AppColors.cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              } else if (value == 'settings') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
              }
            },
            itemBuilder: (BuildContext context) => [
              _buildPopupMenuItem('My Profile', Icons.person_outline, 'profile'),
              _buildPopupMenuItem('Settings', Icons.settings_outlined, 'settings'),
              const PopupMenuDivider(height: 1),
              _buildPopupMenuItem('Logout', Icons.logout, 'logout', isDestructive: true),
            ],
            child: const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white10,
              child: Icon(Icons.person_outline, size: 16, color: AppColors.textMain),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.textSecondary, size: 22),
                onPressed: () {},
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.negative, shape: BoxShape.circle),
                ),
              )
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Executive Overview'),
            const SizedBox(height: 12),

            // --- CAROUSEL: MENTIONS & ENGAGEMENT ---
            SizedBox(
              height: 165,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse, 
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  children: [
                    // Kartu 1: Mentions & Engagement
                    Container(
                      width: 280,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryAccent.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(color: AppColors.primaryAccent.withOpacity(0.1), blurRadius: 20, spreadRadius: -5)
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text('Mentions & Engagement', style: TextStyle(color: AppColors.textMain, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                              ),
                              Icon(Icons.more_horiz, color: AppColors.textSecondary.withOpacity(0.5)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildOverviewStat('Total Mentions', '1,890', AppColors.primaryAccent),
                              const SizedBox(width: 12),
                              _buildOverviewStat('Engagement', '41.2K', Colors.blueAccent),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Kartu 2: Neutral Analysis
                    _buildSimpleOverviewCard('Neutral Analysis', '52K', AppColors.warning),
                    const SizedBox(width: 12),

                    // Kartu 3: Sentiment
                    _buildSimpleOverviewCard('Sentiment', '20K', AppColors.positive),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Carousel Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 16, height: 4, decoration: BoxDecoration(color: AppColors.textSecondary, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Container(width: 4, height: 4, decoration: BoxDecoration(color: AppColors.textSecondary.withOpacity(0.3), shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Container(width: 4, height: 4, decoration: BoxDecoration(color: AppColors.textSecondary.withOpacity(0.3), shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Container(width: 4, height: 4, decoration: BoxDecoration(color: AppColors.textSecondary.withOpacity(0.3), shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Container(width: 4, height: 4, decoration: BoxDecoration(color: AppColors.textSecondary.withOpacity(0.3), shape: BoxShape.circle)),
              ],
            ),

            const SizedBox(height: 24),

            // --- ROW 2: SOURCES & TRENDING TAGS ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: DashboardCard(
                    title: 'Sources',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSourceRadial('YouTube', '90%', AppColors.youtube),
                            _buildSourceRadial('X/Twitter', '75%', AppColors.xTwitter),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSourceRadial('Instagram', '57%', AppColors.instagram),
                            _buildSourceRadial('TikTok', '12%', AppColors.tiktok),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DashboardCard(
                    title: 'Trending Tags',
                    child: Column(
                      children: [
                        _buildTagRow('#jakarta_ops', 50, AppColors.primaryAccent),
                        _buildTagRow('#tni_airforce', 13, Colors.blue),
                        _buildTagRow('#ai_alerts', 7, AppColors.warning),
                        _buildTagRow('#geo_intel', 2, AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- ROW 3: SENTIMENT CHART (FULL WIDTH, CLEAN) ---
            DashboardCard(
              title: 'Sentiment & Threats',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLegend(),
                  const SizedBox(height: 16),
                  const SizedBox(height: 220, child: NeonAreaChartWidget()),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- ROW 4: THREAT SCORE & AI INTEL SUMMARY ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PERBAIKAN: Flex diperbesar menjadi 3 agar kartu cukup lebar menampung Gauge
                Expanded(
                  flex: 3, 
                  child: DashboardCard(
                    title: 'Threat Score',
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
                        child: SizedBox(
                          width: 90, // Ukuran Gauge disesuaikan agar pas
                          height: 45,
                          child: CustomPaint(
                            painter: GaugePainter(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 4, // Kartu summary mengambil ruang sisanya
                  child: DashboardCard(
                    title: 'AI Intel Summary',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletPoint('AI Generated Issue Summary rais, kasel lagunya beneran menggambarkan kalula.'),
                        const SizedBox(height: 4),
                        _buildBulletPoint('Generated insight summary, insucrs risk assessment, sentimentisatability, and enterpreaomatic entists, trent lervality, and umartantisal cantions.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- HELPER WIDGETS ---

  PopupMenuItem<String> _buildPopupMenuItem(String title, IconData icon, String value, {bool isDestructive = false}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? AppColors.negative : AppColors.textSecondary, size: 18),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: isDestructive ? AppColors.negative : AppColors.textMain, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: const TextStyle(color: AppColors.textMain, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
        const Icon(Icons.more_horiz, color: AppColors.textSecondary),
      ],
    );
  }

  Widget _buildOverviewStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            SizedBox(
              height: 15, 
              width: double.infinity,
              child: CustomPaint(painter: SparklinePainter(color: color))
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleOverviewCard(String title, String value, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11), overflow: TextOverflow.ellipsis)),
              Icon(Icons.more_horiz, color: AppColors.textSecondary.withOpacity(0.5), size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: AppColors.textMain, fontSize: 20, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          SizedBox(
              height: 15,
              width: double.infinity,
              child: CustomPaint(painter: SparklinePainter(color: color))),
        ],
      ),
    );
  }

  Widget _buildSourceRadial(String label, String percent, Color color) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: double.parse(percent.replaceAll('%', '')) / 100,
                  strokeWidth: 4,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(percent, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10), overflow: TextOverflow.ellipsis, maxLines: 1),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6,
      children: [
        _legendDot('Positive', AppColors.positive),
        _legendDot('Negative', AppColors.negative),
        _legendDot('Neutral', AppColors.textSecondary),
      ],
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 6, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 9), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildTagRow(String tag, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(tag, style: const TextStyle(color: AppColors.textMain, fontSize: 11, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 4),
              Text('$count', style: const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: count / 60,
              minHeight: 3,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6.0),
          child: Icon(Icons.circle, size: 4, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, height: 1.4))),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 65,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.grid_view_rounded, 'Dashboard', isActive: true),
          _navItem(Icons.article_outlined, 'Feed'),
          _navItem(Icons.security, 'Threat Center'),
          _navItem(Icons.search, 'OSINT'),
          _navItem(Icons.description_outlined, 'Reports'),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? AppColors.primaryAccent : AppColors.textSecondary, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isActive ? AppColors.primaryAccent : AppColors.textSecondary, fontSize: 8), overflow: TextOverflow.ellipsis, maxLines: 1, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTERS ---

class NeonAreaChartWidget extends StatelessWidget {
  const NeonAreaChartWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: NeonAreaChartPainter(),
    );
  }
}

class NeonAreaChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    
    final posColor = AppColors.positive;
    final negColor = AppColors.negative;
    final neuColor = Colors.white54;

    final chartHeight = size.height - 24; 
    final chartWidth = size.width;

    // --- MENGGAMBAR GRID DAN Y-AXIS (0 - 120) ---
    final yLabels = ['120', '90', '60', '30', '0'];
    final gridPaint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 1;

    for (int i = 0; i < yLabels.length; i++) {
      final y = chartHeight * (i / (yLabels.length - 1));
      
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);

      final textPainter = TextPainter(
        text: TextSpan(text: yLabels[i], style: const TextStyle(color: Colors.white54, fontSize: 8)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(4, y - 12)); 
    }

    // --- MENGGAMBAR PATH GRAFIK ---
    final pathNeu = Path();
    pathNeu.moveTo(0, chartHeight * 0.8);
    pathNeu.quadraticBezierTo(chartWidth * 0.3, chartHeight * 0.7, chartWidth * 0.6, chartHeight * 0.9);
    pathNeu.quadraticBezierTo(chartWidth * 0.8, chartHeight * 0.8, chartWidth, chartHeight * 0.85);
    final pathNeuStroke = Path.from(pathNeu);
    pathNeu.lineTo(chartWidth, chartHeight);
    pathNeu.lineTo(0, chartHeight);
    pathNeu.close();

    final pathNeg = Path();
    pathNeg.moveTo(0, chartHeight * 0.6);
    pathNeg.quadraticBezierTo(chartWidth * 0.2, chartHeight * 0.4, chartWidth * 0.4, chartHeight * 0.7);
    pathNeg.quadraticBezierTo(chartWidth * 0.7, chartHeight * 0.3, chartWidth, chartHeight * 0.6);
    final pathNegStroke = Path.from(pathNeg);
    pathNeg.lineTo(chartWidth, chartHeight);
    pathNeg.lineTo(0, chartHeight);
    pathNeg.close();

    final pathPos = Path();
    pathPos.moveTo(0, chartHeight * 0.4);
    pathPos.quadraticBezierTo(chartWidth * 0.2, chartHeight * 0.1, chartWidth * 0.4, chartHeight * 0.3);
    pathPos.quadraticBezierTo(chartWidth * 0.6, chartHeight * 0.1, chartWidth * 0.8, chartHeight * 0.4);
    pathPos.lineTo(chartWidth, chartHeight * 0.2);
    final pathPosStroke = Path.from(pathPos);
    pathPos.lineTo(chartWidth, chartHeight);
    pathPos.lineTo(0, chartHeight);
    pathPos.close();

    // Render 
    canvas.drawPath(pathNeu, Paint()..shader = LinearGradient(colors: [neuColor.withOpacity(0.4), neuColor.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTRB(0, 0, 0, chartHeight)));
    canvas.drawPath(pathNeuStroke, Paint()..color = neuColor..style = PaintingStyle.stroke..strokeWidth = 2);

    canvas.drawPath(pathNeg, Paint()..shader = LinearGradient(colors: [negColor.withOpacity(0.5), negColor.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTRB(0, 0, 0, chartHeight)));
    canvas.drawPath(pathNegStroke, Paint()..color = negColor..style = PaintingStyle.stroke..strokeWidth = 2);

    canvas.drawPath(pathPos, Paint()..shader = LinearGradient(colors: [posColor.withOpacity(0.5), posColor.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTRB(0, 0, 0, chartHeight)));
    canvas.drawPath(pathPosStroke, Paint()..color = posColor..style = PaintingStyle.stroke..strokeWidth = 2);

    // --- MENGGAMBAR TANGGAL (X-AXIS) ---
    final xLabels = ['Jan 19', 'May 12', 'Sep 23', 'Nov 25'];
    for (int i = 0; i < xLabels.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(text: xLabels[i], style: const TextStyle(color: Colors.white54, fontSize: 8)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      double x = (chartWidth - textPainter.width) * (i / (xLabels.length - 1));
      if (i == 0) x = 4; 
      if (i == xLabels.length - 1) x = chartWidth - textPainter.width - 4; 
      
      textPainter.paint(canvas, Offset(x, chartHeight + 8)); 
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SparklinePainter extends CustomPainter {
  final Color color;
  SparklinePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.2, size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.1, size.width * 0.8, size.height * 0.7);
    path.lineTo(size.width, size.height * 0.3);

    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final strokeWidth = size.width * 0.15; // Ketebalan 3 segmen

    // Warna dari gambar lu: Kuning/Oranye, Oranye Tua, Coklat
    final paint1 = Paint()..color = const Color(0xFFF59E0B)..strokeWidth = strokeWidth..style = PaintingStyle.stroke..strokeCap = StrokeCap.butt;
    final paint2 = Paint()..color = const Color(0xFFD97706)..strokeWidth = strokeWidth..style = PaintingStyle.stroke..strokeCap = StrokeCap.butt;
    final paint3 = Paint()..color = const Color(0xFF92400E)..strokeWidth = strokeWidth..style = PaintingStyle.stroke..strokeCap = StrokeCap.butt;

    // Membagi setengah lingkaran (pi) menjadi 3 segmen dengan celah kecil (gap)
    const gap = 0.05;
    const segmentAngle = (math.pi - (2 * gap)) / 3;

    // Gambar 3 Segmen
    canvas.drawArc(rect, math.pi, segmentAngle, false, paint1);
    canvas.drawArc(rect, math.pi + segmentAngle + gap, segmentAngle, false, paint2);
    canvas.drawArc(rect, math.pi + 2 * (segmentAngle + gap), segmentAngle, false, paint3);
    
    // Gambar Jarum (Needle)
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
      
    // Arah jarum sedikit menunjuk ke tengah
    const needleAngle = math.pi + (math.pi / 2) - 0.2; 
    final needleEnd = Offset(
      center.dx + (radius * 0.8) * math.cos(needleAngle),
      center.dy + (radius * 0.8) * math.sin(needleAngle),
    );
    
    canvas.drawLine(center, needleEnd, needlePaint);
    
    // Lingkaran Putih di titik tumpu jarum
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}