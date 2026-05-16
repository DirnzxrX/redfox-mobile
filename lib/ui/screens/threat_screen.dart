import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

import 'profile_screen.dart';
import 'settings_screen.dart';
import 'dashboard_screen.dart';
import 'feed_screen.dart';
import 'analytics_screen.dart';
import 'geointel_screen.dart';

// --- TEMA KHUSUS DESAIN BARU ---
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

class ThreatScreen extends StatefulWidget {
  const ThreatScreen({super.key});

  @override
  State<ThreatScreen> createState() => _ThreatScreenState();
}

class _ThreatScreenState extends State<ThreatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            _buildSubTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. TOP STATS CARDS (Horizontal Scroll to avoid overflow) ---
                    SizedBox(
                      height: 85,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildThreatGaugeCard(),
                            const SizedBox(width: 8),
                            _buildTopStatCardLine('ACTIVE THREATS', '128', '+28%', CyberTheme.green),
                            const SizedBox(width: 8),
                            _buildTopStatCardLine('CRITICAL ALERTS', '32', '+45%', CyberTheme.green),
                            const SizedBox(width: 8),
                            _buildTopStatCardLine('TOTAL ALERTS', '247', '+18%', CyberTheme.green),
                            const SizedBox(width: 8),
                            _buildThreatLevelCard(), // Diperbaiki pemanggilannya
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- 2. CYBER WARNING CENTER ---
                    _buildSectionHeader('CYBER WARNING CENTER', 'View All Alerts →'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 110,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildWarningCard(Icons.campaign, 'Disinformation\nCampaign', 'High Priority', CyberTheme.red, 'Peningkatan aktivitas propaganda terkait isu pertahanan di media sosial.', '2m ago'),
                            const SizedBox(width: 8),
                            _buildWarningCard(Icons.smart_toy, 'Bot Activity Spike', 'High Priority', CyberTheme.red, 'Lonjakan aktivitas bot terdeteksi di beberapa platform.', '5m ago'),
                            const SizedBox(width: 8),
                            _buildWarningCard(Icons.gps_fixed, 'Coordinated Attack', 'Critical', CyberTheme.red, 'Pola serangan terkoordinasi terhadap narasi nasional terdeteksi.', '8m ago'),
                            const SizedBox(width: 8),
                            _buildWarningCard(Icons.article, 'Fake News Surge', 'High Priority', CyberTheme.red, 'Peningkatan signifikan berita palsu terkait kebijakan pemerintah.', '12m ago'),
                            const SizedBox(width: 8),
                            _buildWarningCard(Icons.person, 'Influence Operation', 'Medium Priority', CyberTheme.warning, 'Aktivitas operasi pengaruh asing di beberapa kanal digital.', '18m ago'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- 3. ROW: ANOMALY DETECTION & THREAT CATEGORY ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildAnomalyDetection()),
                        const SizedBox(width: 8),
                        Expanded(child: _buildThreatCategoryDistribution()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 4. ROW: SUSPICIOUS ACTIVITY & BOT ACTIVITY ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildSuspiciousActivity()),
                        const SizedBox(width: 8),
                        Expanded(child: _buildBotActivityMonitoring()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 5. ROW: DISINFORMATION & TOP FALSE NARRATIVES ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildDisinformationAnalytics()),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTopFalseNarratives()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 6. ROW: THREAT TREND & AI RISK ASSESSMENT ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildThreatTrendAnalysis()),
                        const SizedBox(width: 8),
                        Expanded(child: _buildAIRiskAssessment()),
                      ],
                    ),

                    const SizedBox(height: 100), // Spacing for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: _buildCyberBottomNav(),
    );
  }

  // ===========================================================================
  // WIDGET BUILDERS: APP BAR & MENUS
  // ===========================================================================

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AIRA', style: TextStyle(color: CyberTheme.cyan, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('Advanced Intelligence\nRecon & Analytics', style: TextStyle(color: CyberTheme.textSec, fontSize: 6, height: 1.2)),
            ],
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            offset: const Offset(0, 45),
            color: CyberTheme.cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: CyberTheme.border)),
            onSelected: (value) {
              if (value == 'profile') Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              else if (value == 'settings') Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
            itemBuilder: (context) => [
              _buildPopupMenuItem('My Profile', Icons.person_outline, 'profile'),
              _buildPopupMenuItem('Settings', Icons.settings_outlined, 'settings'),
              const PopupMenuDivider(height: 1),
              _buildPopupMenuItem('Logout', Icons.logout, 'logout', isDestructive: true),
            ],
            child: Row(
              children: [
                const CircleAvatar(radius: 14, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=11')),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Analyst', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                    Row(
                      children: const [
                        Text('TNI AU', style: TextStyle(color: CyberTheme.textMain, fontSize: 10, fontWeight: FontWeight.bold)),
                        Icon(Icons.keyboard_arrow_down, color: CyberTheme.textSec, size: 12),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
          Expanded( 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Project', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Flexible(child: Text('TNI AU Monitoring', style: TextStyle(color: CyberTheme.textMain, fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                    SizedBox(width: 2),
                    Icon(Icons.keyboard_arrow_down, color: CyberTheme.textSec, size: 12),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              const Icon(Icons.notifications_none, color: CyberTheme.textSec, size: 24),
              Positioned(
                right: 0, top: 0,
                child: Container(padding: const EdgeInsets.all(2), decoration: const BoxDecoration(color: CyberTheme.red, shape: BoxShape.circle), child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold))),
              )
            ],
          )
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String title, IconData icon, String value, {bool isDestructive = false}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: isDestructive ? CyberTheme.red : CyberTheme.textSec, size: 18),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: isDestructive ? CyberTheme.red : CyberTheme.textMain, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSubTabs() {
    final tabs = ['Overview', 'Threat', 'Threat Feed', 'Anomaly Detection', 'Bot Activity', 'Disinformation', 'Reports'];
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 30,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: tabs.length,
                  itemBuilder: (context, index) {
                    final tabName = tabs[index];
                    final isActive = tabName == 'Threat'; // Set Threat aktif
                    
                    return InkWell(
                      onTap: () {
                        if (tabName == 'Overview') Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        decoration: isActive ? const BoxDecoration(border: Border(bottom: BorderSide(color: CyberTheme.cyan, width: 2))) : null,
                        child: Center(
                          child: Text(tabName, style: TextStyle(color: isActive ? CyberTheme.textMain : CyberTheme.textSec, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 24, padding: const EdgeInsets.symmetric(horizontal: 8), margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: CyberTheme.green, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LIVE', style: TextStyle(color: CyberTheme.green, fontSize: 8, fontWeight: FontWeight.bold)),
                    Text('Realtime', style: TextStyle(color: CyberTheme.green, fontSize: 5)),
                  ],
                ),
                const SizedBox(width: 6),
                const Icon(Icons.show_chart, color: CyberTheme.cyan, size: 12),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGET BUILDERS: CARDS & CHARTS
  // ===========================================================================

  Widget _buildThreatGaugeCard() {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: CyberTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: Text('THREAT SCORE', style: TextStyle(color: CyberTheme.textSec, fontSize: 6, fontWeight: FontWeight.bold))),
              Icon(Icons.more_vert, color: CyberTheme.textSec, size: 10),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45, height: 45,
                  child: CustomPaint(painter: ThreatGaugePainter(score: 78)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('78/100', style: TextStyle(color: CyberTheme.textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Row(
                        children: const [
                          Icon(Icons.shield, color: CyberTheme.cyan, size: 8),
                          SizedBox(width: 2),
                          Expanded(child: Text('High Risk', style: TextStyle(color: CyberTheme.textMain, fontSize: 7, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopStatCardLine(String title, String value, String percent, Color pColor) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: CyberTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              const Icon(Icons.more_vert, color: CyberTheme.textSec, size: 10),
            ],
          ),
          Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Row(
            children: [
              Icon(Icons.arrow_drop_up, color: pColor, size: 10),
              Text(percent, style: TextStyle(color: pColor, fontSize: 7, fontWeight: FontWeight.bold)),
              const SizedBox(width: 2),
              const Expanded(child: Text('vs yesterday', style: TextStyle(color: CyberTheme.textSec, fontSize: 5), overflow: TextOverflow.ellipsis)),
            ],
          ),
          SizedBox(height: 10, child: CustomPaint(painter: MiniSparklinePainter(color: CyberTheme.cyan), size: Size.infinite)),
        ],
      ),
    );
  }

  Widget _buildThreatLevelCard() {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: CyberTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(child: Text('THREAT LEVEL', style: TextStyle(color: CyberTheme.textSec, fontSize: 6, fontWeight: FontWeight.bold))),
              Icon(Icons.more_vert, color: CyberTheme.textSec, size: 10),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('HIGH', style: TextStyle(color: CyberTheme.cyan, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Elevated Risk\nDetected', style: TextStyle(color: CyberTheme.textSec, fontSize: 6, height: 1.2)),
                  ],
                ),
              ),
              const Icon(Icons.warning_amber_rounded, color: CyberTheme.cyan, size: 32),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        Text(actionText, style: const TextStyle(color: CyberTheme.cyan, fontSize: 8)),
      ],
    );
  }

  Widget _buildWarningCard(IconData icon, String title, String priority, Color pColor, String desc, String time) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: CyberTheme.cyan.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: CyberTheme.cyan, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                    Text(priority, style: TextStyle(color: pColor, fontSize: 6, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
          Text(desc, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis),
          Row(
            children: [
              const Icon(Icons.circle, color: CyberTheme.cyan, size: 4),
              const SizedBox(width: 4),
              Text(time, style: const TextStyle(color: CyberTheme.cyan, fontSize: 6)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCardBase({required String title, required Widget child, Widget? trailing, double height = 180}) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5), overflow: TextOverflow.ellipsis)),
              if (trailing != null) trailing else const Icon(Icons.more_vert, color: CyberTheme.textSec, size: 12),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildDropdownTrailing(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)),
          const Icon(Icons.arrow_drop_down, color: CyberTheme.textSec, size: 10)
        ],
      ),
    );
  }

  Widget _buildAnomalyDetection() {
    return _buildCardBase(
      title: 'ANOMALY DETECTION',
      trailing: _buildDropdownTrailing('24 Jam'),
      height: 160,
      child: CustomPaint(painter: SpikeLineChartPainter(color: CyberTheme.cyan), size: Size.infinite),
    );
  }

  Widget _buildThreatCategoryDistribution() {
    return _buildCardBase(
      title: 'THREAT CATEGORY DISTRIBUTION',
      height: 160,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: PlusDonutChartPainter(
                    data: [
                      {'val': 0.320, 'color': Colors.blueAccent},
                      {'val': 0.243, 'color': CyberTheme.red},
                      {'val': 0.182, 'color': CyberTheme.warning},
                      {'val': 0.121, 'color': CyberTheme.green},
                      {'val': 0.077, 'color': Colors.purple},
                      {'val': 0.057, 'color': CyberTheme.textSec},
                    ]
                  ), 
                  size: const Size(80, 80)
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('247', style: TextStyle(color: CyberTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Total Threats', style: TextStyle(color: CyberTheme.textSec, fontSize: 5)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _distLegendRowSmall(Colors.blueAccent, 'Disinformation', '32.0%'),
                _distLegendRowSmall(CyberTheme.red, 'Bot Activity', '24.3%'),
                _distLegendRowSmall(CyberTheme.warning, 'Fake News', '18.2%'),
                _distLegendRowSmall(CyberTheme.green, 'Propaganda', '12.1%'),
                _distLegendRowSmall(Colors.purple, 'Coordinated Attack', '7.7%'),
                _distLegendRowSmall(CyberTheme.textSec, 'Others', '5.7%'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _distLegendRowSmall(Color color, String label, String pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 5),
          const SizedBox(width: 4),
          Expanded(child: Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7), overflow: TextOverflow.ellipsis)),
          Text(pct, style: const TextStyle(color: CyberTheme.textMain, fontSize: 7, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSuspiciousActivity() {
    return _buildCardBase(
      title: 'SUSPICIOUS ACTIVITY FEED',
      height: 200,
      child: Column(
        children: [
          _suspiciousRowIcon(Icons.fingerprint, 'Akun @Garuda_update membagikan konten disinformasi tentang alutsista.', '1m ago', 'High', CyberTheme.red),
          _suspiciousRowIcon(Icons.alternate_email, 'Narasi negatif tentang TNI meningkat drastis @opposite_view • 185.22.0.XX.12', '3m ago', 'High', CyberTheme.red),
          _suspiciousRowIcon(Icons.language, 'Domain mencurigakan terdeteksi menyebarkan hoaks berita • hoax-news.id • 103.120.XX.77', '6m ago', 'Medium', CyberTheme.warning),
          _suspiciousRowIcon(Icons.hub, 'Koordinasi posting melalui jaringan akun palsu Network Cluster • 45 akun terlibat', '9m ago', 'High', CyberTheme.red),
          _suspiciousRowIcon(Icons.article, 'Peningkatan komentar provokatif di berita politik @america_today • 8.8.8.8', '12m ago', 'Medium', CyberTheme.warning),
          const Spacer(),
          const Align(alignment: Alignment.centerLeft, child: Text('View All Activities →', style: TextStyle(color: CyberTheme.cyan, fontSize: 7))),
        ],
      ),
    );
  }

  Widget _suspiciousRowIcon(IconData icon, String text, String time, String severity, Color sColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: CyberTheme.border.withOpacity(0.3), shape: BoxShape.circle),
            child: Icon(icon, color: CyberTheme.cyan, size: 10),
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(time, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(color: sColor.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
                child: Text(severity, style: TextStyle(color: sColor, fontSize: 5, fontWeight: FontWeight.bold)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBotActivityMonitoring() {
    return _buildCardBase(
      title: 'BOT ACTIVITY MONITORING',
      trailing: _buildDropdownTrailing('24 Jam'),
      height: 200,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 60, height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(value: 0.38, strokeWidth: 4, backgroundColor: CyberTheme.border, color: CyberTheme.cyan),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('38%', style: TextStyle(color: CyberTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('Bot Probability', style: TextStyle(color: CyberTheme.textSec, fontSize: 5)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _botStatRow('Total Accounts', '24.5K'),
                    _botStatRow('Bot Accounts', '9.3K'),
                    _botStatRow('Increase Rate', '▲ 27%', color: CyberTheme.green),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: CustomPaint(painter: SpikeLineChartPainter(color: CyberTheme.cyan, showArea: true), size: Size.infinite)),
        ],
      ),
    );
  }

  Widget _botStatRow(String label, String val, {Color color = CyberTheme.textMain}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
          Text(val, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDisinformationAnalytics() {
    return _buildCardBase(
      title: 'DISINFORMATION ANALYTICS',
      height: 140,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: CyberTheme.cyan, width: 2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('68', style: TextStyle(color: CyberTheme.textMain, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Disinformation\nIndex', style: TextStyle(color: CyberTheme.textSec, fontSize: 5), textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _disinfoRow('False Narrative', '128', CyberTheme.cyan),
                    _disinfoRow('Misleading Content', '247', CyberTheme.cyan),
                    _disinfoRow('Hoax Detected', '95', CyberTheme.cyan),
                    _disinfoRow('Fabricated Media', '36', CyberTheme.cyan),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          const Align(alignment: Alignment.centerLeft, child: Text('View Full Report →', style: TextStyle(color: CyberTheme.cyan, fontSize: 7))),
        ],
      ),
    );
  }

  Widget _disinfoRow(String label, String val, Color lineCol) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 1, child: Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 7, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: SizedBox(height: 8, child: CustomPaint(painter: MiniSparklinePainter(color: lineCol)))),
        ],
      ),
    );
  }

  Widget _buildTopFalseNarratives() {
    return _buildCardBase(
      title: 'TOP FALSE NARRATIVES',
      trailing: _buildDropdownTrailing('24 Jam'),
      height: 140,
      child: Column(
        children: [
          _narrativeRow('1', 'TNI terlibat dalam konflik politik', '12.4K Mentions', 'High', CyberTheme.red),
          _narrativeRow('2', 'Kebijakan pertahanan merugikan rakyat', '8.7K Mentions', 'High', CyberTheme.red),
          _narrativeRow('3', 'Pangkalan militer digunakan untuk asing', '6.3K Mentions', 'Medium', CyberTheme.warning),
          _narrativeRow('4', 'Peralatan militer bekas & tidak layak', '4.2K Mentions', 'Medium', CyberTheme.warning),
          _narrativeRow('5', 'Prajurit TNI tidak profesional', '3.1K Mentions', 'Low', CyberTheme.green),
          const Spacer(),
          const Align(alignment: Alignment.centerLeft, child: Text('View All Narratives →', style: TextStyle(color: CyberTheme.cyan, fontSize: 7))),
        ],
      ),
    );
  }

  Widget _narrativeRow(String num, String name, String ment, String sev, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(width: 12, child: Text(num, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7))),
          Expanded(child: Text(name, style: const TextStyle(color: CyberTheme.textMain, fontSize: 7), overflow: TextOverflow.ellipsis)),
          Text(ment, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)),
          const SizedBox(width: 8),
          SizedBox(width: 30, child: Text(sev, style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  // --- MENGEMBALIKAN FUNGSI YANG HILANG ---
  Widget _legendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 6, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
      ],
    );
  }

  Widget _buildThreatTrendAnalysis() {
    return _buildCardBase(
      title: 'THREAT TREND ANALYSIS',
      trailing: _buildDropdownTrailing('7 Hari'),
      height: 180,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _legendDot('Disinformation', CyberTheme.red), const SizedBox(width: 8),
                _legendDot('Bot Activity', CyberTheme.cyan), const SizedBox(width: 8),
                _legendDot('Fake News', CyberTheme.warning), const SizedBox(width: 8),
                _legendDot('Propaganda', CyberTheme.green),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: CustomPaint(painter: MultiLineChartPainterColors(), size: Size.infinite)),
        ],
      ),
    );
  }

  Widget _buildAIRiskAssessment() {
    return _buildCardBase(
      title: 'AI RISK ASSESSMENT',
      height: 180,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 90,
                  child: CustomPaint(painter: AICirclePainter(), size: Size.infinite),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _aiStatRow('Risk Level', 'High Risk', CyberTheme.red),
                    _aiStatRow('Confidence', '87%', CyberTheme.textMain),
                    _aiStatRow('Potential Impact', 'Severe', CyberTheme.textMain),
                    _aiStatRow('Recommendation', 'Immediate Action', CyberTheme.red),
                  ],
                ),
              )
            ],
          ),
          const Spacer(),
          const Align(alignment: Alignment.centerLeft, child: Text('View Assessment Details →', style: TextStyle(color: CyberTheme.cyan, fontSize: 7))),
        ],
      ),
    );
  }

  Widget _aiStatRow(String label, String val, Color valColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7)),
          Text(val, style: TextStyle(color: valColor, fontSize: 7, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- BOTTOM NAV ---
  Widget _buildCyberBottomNav() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: CyberTheme.cardBg,
        border: Border(top: BorderSide(color: CyberTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.dashboard, 'Dashboard', onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          }),
          _navItem(Icons.wifi_tethering, 'Feed', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FeedScreen()));
          }),
          _navItem(Icons.bar_chart, 'Analytics', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
          }),
          _navItem(Icons.public, 'GeoIntel', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GeoIntelScreen()));
          }),
          _navItem(Icons.shield_outlined, 'Threat', isActive: true),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool isActive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? CyberTheme.cyan : CyberTheme.textSec, size: 20),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isActive ? CyberTheme.cyan : CyberTheme.textSec, fontSize: 8)),
          if (isActive) Container(margin: const EdgeInsets.only(top: 4), width: 20, height: 2, color: CyberTheme.cyan)
        ],
      ),
    );
  }
}

// ===========================================================================
// CUSTOM PAINTERS 
// ===========================================================================

class ThreatGaugePainter extends CustomPainter {
  final int score;
  ThreatGaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = 6.0;

    // Background Arc
    canvas.drawArc(rect, math.pi * 0.8, math.pi * 1.4, false, Paint()..color = CyberTheme.border..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round);
    
    // Value Arc
    final sweepAngle = (score / 100) * (math.pi * 1.4);
    final paintVal = Paint()
      ..shader = const LinearGradient(colors: [CyberTheme.cyan, Colors.blueAccent]).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    // Glow
    canvas.drawArc(rect, math.pi * 0.8, sweepAngle, false, Paint()..color = CyberTheme.cyan.withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = strokeWidth..strokeCap = StrokeCap.round..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawArc(rect, math.pi * 0.8, sweepAngle, false, paintVal);

    // Text in center
    final tp = TextPainter(text: TextSpan(text: '$score', style: const TextStyle(color: CyberTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2 - 2));
    
    final tp2 = TextPainter(text: const TextSpan(text: '/100', style: TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(center.dx - tp2.width/2, center.dy + tp.height/2 - 2));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MiniSparklinePainter extends CustomPainter {
  final Color color;
  MiniSparklinePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0) return;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.0;
    
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.1);
    
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SpikeLineChartPainter extends CustomPainter {
  final Color color;
  final bool showArea;
  SpikeLineChartPainter({required this.color, this.showArea = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final h = size.height - 12;
    final w = size.width;

    // Y Axis labels (mock)
    final yLabels = ['1.5K', '1.25K', '1K', '750', '500', '250', '0'];
    final gridPaint = Paint()..color = CyberTheme.border..strokeWidth = 1;
    for (int i = 0; i < yLabels.length; i++) {
      final y = h * (i / (yLabels.length - 1));
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      final tp = TextPainter(text: TextSpan(text: yLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 5)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, y - 6));
    }

    // X Axis labels
    final xLabels = ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'];
    for (int i = 0; i < xLabels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 5)), textDirection: TextDirection.ltr)..layout();
      double x = (w - tp.width) * (i / (xLabels.length - 1));
      if (i == 0) x = 16;
      tp.paint(canvas, Offset(x, h + 4));
    }

    // Points with a spike
    final pts = [0.8, 0.75, 0.9, 0.85, 0.7, 0.65, 0.8, 0.7, 0.85, 0.2, 0.8, 0.6, 0.75]; 
    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = w * (i / (pts.length - 1));
      final y = h * pts[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 1.5, Paint()..color = color);
      
      // Spike Label
      if (!showArea && i == 9) { // Spike at 0.2 (high value)
        _drawPopupLabel(canvas, x, y - 15, 'Spike Detected\n14 Mei 14:23', color);
      }
    }
    
    if (showArea) {
      final fillPath = Path.from(path)..lineTo(w, h)..lineTo(0, h)..close();
      canvas.drawPath(fillPath, Paint()..shader = LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTRB(0, 0, 0, h)));
    }
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }

  void _drawPopupLabel(Canvas canvas, double x, double y, String text, Color color) {
    final rect = Rect.fromCenter(center: Offset(x, y), width: 50, height: 20);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.background..style = PaintingStyle.fill);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.border..style = PaintingStyle.stroke);
    final tp = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: CyberTheme.textSec, fontSize: 5)), textAlign: TextAlign.center, textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(x - tp.width/2, y - tp.height/2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlusDonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  PlusDonutChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = 14.0;
    final radius = size.width / 2 - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;
    for (var d in data) {
      final sweepAngle = (d['val'] as double) * 2 * math.pi;
      final paint = Paint()
        ..color = d['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      
      canvas.drawArc(rect, startAngle, sweepAngle - 0.05, false, paint);
      
      // Draw '+' inside segment
      final midAngle = startAngle + (sweepAngle / 2);
      final plusX = center.dx + radius * math.cos(midAngle);
      final plusY = center.dy + radius * math.sin(midAngle);
      _drawPlus(canvas, Offset(plusX, plusY));
      
      startAngle += sweepAngle;
    }
  }

  void _drawPlus(Canvas canvas, Offset center) {
    final paint = Paint()..color = Colors.white54..strokeWidth = 1;
    canvas.drawLine(Offset(center.dx - 3, center.dy), Offset(center.dx + 3, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - 3), Offset(center.dx, center.dy + 3), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MultiLineChartPainterColors extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final h = size.height - 12;
    final w = size.width;

    // Y Axis labels
    final yLabels = ['20K', '15K', '10K', '5K', '0'];
    final gridPaint = Paint()..color = CyberTheme.border..strokeWidth = 1;
    for (int i = 0; i < yLabels.length; i++) {
      final y = h * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      final tp = TextPainter(text: TextSpan(text: yLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, y - 8));
    }

    // X Axis labels
    final xLabels = ['7 Mei', '8 Mei', '9 Mei', '10 Mei', '11 Mei', '12 Mei', '13 Mei'];
    for (int i = 0; i < xLabels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      double x = (w - tp.width) * (i / 6);
      if (i == 0) x = 16;
      tp.paint(canvas, Offset(x, h + 4));
    }

    // Lines 
    _drawLine(canvas, w, h, [0.1, 0.2, 0.15, 0.3, 0.1, 0.2, 0.15], CyberTheme.red);     // Disinformation
    _drawLine(canvas, w, h, [0.3, 0.4, 0.5, 0.35, 0.6, 0.45, 0.4], CyberTheme.cyan);    // Bot
    _drawLine(canvas, w, h, [0.6, 0.5, 0.65, 0.7, 0.5, 0.6, 0.55], CyberTheme.warning); // Fake News
    _drawLine(canvas, w, h, [0.8, 0.85, 0.7, 0.8, 0.85, 0.8, 0.75], CyberTheme.green);  // Propaganda
  }

  void _drawLine(Canvas canvas, double w, double h, List<double> pts, Color color) {
    final path = Path();
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5;
    for (int i = 0; i < pts.length; i++) {
      final x = w * (i / (pts.length - 1));
      final y = h * pts[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = color);
    }
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AICirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - 4;

    // Glowing cyan base
    final glowPaint = Paint()..color = CyberTheme.cyan.withOpacity(0.2)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, radius, glowPaint);

    // Inner Circle filled
    canvas.drawCircle(center, radius * 0.6, Paint()..color = CyberTheme.cardBg..style = PaintingStyle.fill);
    
    // Borders
    canvas.drawCircle(center, radius * 0.6, Paint()..color = CyberTheme.cyan..style = PaintingStyle.stroke..strokeWidth = 1);
    canvas.drawCircle(center, radius * 0.8, Paint()..color = CyberTheme.cyan.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 1);

    // Dashed outer ring
    final dashPaint = Paint()..color = CyberTheme.cyan..style = PaintingStyle.stroke..strokeWidth = 1.5;
    double dashWidth = 0.1;
    double dashSpace = 0.15;
    double currentAngle = 0;
    while (currentAngle < 2 * math.pi) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), currentAngle, dashWidth, false, dashPaint);
      currentAngle += dashWidth + dashSpace;
    }

    // AI Text
    final tp = TextPainter(text: const TextSpan(text: 'AI', style: TextStyle(color: CyberTheme.cyan, fontSize: 16, fontWeight: FontWeight.bold, shadows: [Shadow(color: CyberTheme.cyan, blurRadius: 4)])), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(center.dx - tp.width/2, center.dy - tp.height/2));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}