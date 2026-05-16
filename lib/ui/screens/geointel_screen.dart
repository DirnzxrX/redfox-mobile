import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

import 'profile_screen.dart';
import 'settings_screen.dart';
import 'dashboard_screen.dart';
import 'feed_screen.dart';
import 'analytics_screen.dart';
import 'threat_screen.dart'; // <-- 1. Tambahkan import ini

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

class GeoIntelScreen extends StatefulWidget {
  const GeoIntelScreen({super.key});

  @override
  State<GeoIntelScreen> createState() => _GeoIntelScreenState();
}

class _GeoIntelScreenState extends State<GeoIntelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            _buildSubTabs(),
            _buildFilters(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. INDONESIA INTELLIGENCE MAP ---
                    _buildMapSection(),
                    const SizedBox(height: 12),

                    // --- 2. 5 STATS CARDS (Horizontal Scroll) ---
                    SizedBox(
                      height: 70,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildTopStatCard('TOTAL MENTIONS', '15.7M', '+134%', CyberTheme.green),
                            const SizedBox(width: 8),
                            _buildTopStatCardLine('ENGAGEMENT', '98.4M', '+126%', CyberTheme.green),
                            const SizedBox(width: 8),
                            _buildTopStatCardLine('REACH', '212.7M', '+118%', CyberTheme.green),
                            const SizedBox(width: 8),
                            _buildTopStatCardSentiment('AVG SENTIMENT', '+0.68', '+18%', CyberTheme.green),
                            const SizedBox(width: 8),
                            _buildTopStatCardIcon('ALERT COUNT', '32', '+18%', CyberTheme.green, Icons.warning_amber_rounded, CyberTheme.red),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- 3. PROVINCE INTELLIGENCE OVERVIEW (Table) ---
                    _buildProvinceOverview(),
                    const SizedBox(height: 12),

                    // --- 4. 3 CARDS ROW: TOP CITIES, SENTIMENT RATIO, THREAT LEVEL (Horizontal Scroll) ---
                    SizedBox(
                      height: 180,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildTopCitiesCard(),
                            const SizedBox(width: 10),
                            _buildSentimentRatioCard(),
                            const SizedBox(width: 10),
                            _buildThreatLevelCard(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- 5. 2 CARDS ROW: MENTIONS TREND & HEATMAP (Horizontal Scroll) ---
                    SizedBox(
                      height: 200,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildMentionsTrendCard(),
                            const SizedBox(width: 10),
                            _buildEngagementHeatmapCard(),
                          ],
                        ),
                      ),
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
    final tabs = ['Overview', 'Feed', 'Analytics', 'GeoIntel', 'Threat', 'Sources', 'Reports'];
    return SizedBox(
      height: 30,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final tabName = tabs[index];
            final isActive = tabName == 'GeoIntel'; // Set GeoIntel aktif
            
            // --- PERBAIKAN: Menambahkan fungsi navigasi di Sub-Tabs ---
            return InkWell(
              onTap: () {
                if (tabName == 'Overview') {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                } else if (tabName == 'Feed') {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FeedScreen()));
                } else if (tabName == 'Analytics') {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
                }
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
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              height: 32, padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: CyberTheme.border)),
              child: const Row(
                children: [
                  Expanded(child: Text('24 Jam Terakhir', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 4),
                  Icon(Icons.calendar_today, color: CyberTheme.textSec, size: 12),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            height: 32, padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: CyberTheme.border)),
            child: const Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: CyberTheme.cyan, size: 12),
                SizedBox(width: 4),
                Text('Filter', style: TextStyle(color: CyberTheme.cyan, fontSize: 8, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: CyberTheme.cyan, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGET BUILDERS: MAIN SECTIONS
  // ===========================================================================

  Widget _buildMapSection() {
    return Container(
      height: 280, // Dibuat lebih tinggi untuk menampung Peta dan Legend
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.public, color: CyberTheme.cyan, size: 14),
                  const SizedBox(width: 6),
                  const Text('INDONESIA INTELLIGENCE MAP', style: TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
              const Icon(Icons.more_horiz, color: CyberTheme.textSec, size: 16),
            ],
          ),
          const SizedBox(height: 2),
          const Text('Realtime Mention Distribution', style: TextStyle(color: CyberTheme.textSec, fontSize: 7)),
          const SizedBox(height: 12),
          Expanded(
            child: Stack(
              children: [
                // MAP PAINTER (Background and Dots)
                SizedBox(width: double.infinity, height: double.infinity, child: CustomPaint(painter: GeoMapPainter())),
                
                // MOCKUP LABELS
                _mapLabel(0.18, 0.42, 'Sumatera Utara\n2.8K'),
                _mapLabel(0.30, 0.58, 'Riau\n1.6K'),
                _mapLabel(0.28, 0.72, 'Sumatera Selatan\n1.9K'),
                _mapLabel(0.38, 0.88, 'DKI Jakarta\n12.4K', color: CyberTheme.red),
                _mapLabel(0.50, 0.92, 'Jawa Barat\n8.7K', color: CyberTheme.warning),
                _mapLabel(0.58, 0.86, 'Jawa Tengah\n6.3K', color: CyberTheme.warning),
                _mapLabel(0.68, 0.94, 'Jawa Timur\n9.1K', color: CyberTheme.warning),
                _mapLabel(0.62, 0.50, 'Kalimantan Timur\n1.4K'),
                _mapLabel(0.72, 0.62, 'Sulawesi Selatan\n2.2K'),
                _mapLabel(0.78, 0.84, 'Bali\n2.6K'),
                _mapLabel(0.85, 0.94, 'Nusa Tenggara Timur\n1.1K'),
                _mapLabel(0.88, 0.72, 'Maluku\n899'),
                _mapLabel(0.92, 0.64, 'Papua\n1.2K'),

                // Controls
                Positioned(
                  right: 0, top: 20,
                  child: Container(
                    decoration: BoxDecoration(color: CyberTheme.border.withOpacity(0.5), borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.add, color: CyberTheme.textSec, size: 14)),
                        Container(height: 1, width: 14, color: CyberTheme.background),
                        const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.remove, color: CyberTheme.textSec, size: 14)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0, bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: CyberTheme.cyan.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.my_location, color: CyberTheme.cyan, size: 14),
                  ),
                ),
              ],
            ),
          ),
          
          // MAP LEGEND SCROLLABLE
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Text('Intensity', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                const SizedBox(width: 4),
                const Text('Low', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                const SizedBox(width: 4),
                Container(
                  width: 60, height: 4,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), gradient: const LinearGradient(colors: [CyberTheme.cyan, CyberTheme.green, CyberTheme.warning, CyberTheme.red])),
                ),
                const SizedBox(width: 4),
                const Text('High', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                const SizedBox(width: 16),
                _legendIconText(Icons.analytics_outlined, 'Mention Volume'),
                const SizedBox(width: 12),
                _legendIconText(Icons.star_border, 'Engagement'),
                const SizedBox(width: 12),
                _legendIconText(Icons.warning_amber, 'Threat Level', color: CyberTheme.red),
                const SizedBox(width: 12),
                _legendIconText(Icons.sentiment_satisfied_alt, 'Sentiment', color: CyberTheme.green),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _mapLabel(double xFactor, double yFactor, String text, {Color color = CyberTheme.cyan}) {
    return Positioned(
      left: MediaQuery.of(context).size.width * xFactor - 30, // Rough calculation for text center
      top: 180 * yFactor + 10, // 180 is approx height of the map stack
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 6, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _legendIconText(IconData icon, String text, {Color color = CyberTheme.textSec}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 10),
        const SizedBox(width: 2),
        Text(text, style: TextStyle(color: color, fontSize: 8)),
      ],
    );
  }

  Widget _buildTopStatCard(String title, String value, String percent, Color pColor) {
    return Container(
      width: 120,
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
              Icon(Icons.arrow_drop_up, color: pColor, size: 12),
              Text(percent, style: TextStyle(color: pColor, fontSize: 8, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopStatCardLine(String title, String value, String percent, Color pColor) {
    return Container(
      width: 120,
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
              Icon(Icons.arrow_drop_up, color: pColor, size: 12),
              Text(percent, style: TextStyle(color: pColor, fontSize: 8, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Expanded(child: SizedBox(height: 10, child: CustomPaint(painter: MiniSparklinePainter(color: pColor)))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopStatCardSentiment(String title, String value, String percent, Color pColor) {
    return Container(
      width: 120,
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
          Row(
            children: [
              Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1),
              const SizedBox(width: 2),
              const Icon(Icons.sentiment_satisfied_alt, color: CyberTheme.green, size: 14),
            ],
          ),
          Row(
            children: [
              Icon(Icons.arrow_drop_up, color: pColor, size: 12),
              Text(percent, style: TextStyle(color: pColor, fontSize: 8, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopStatCardIcon(String title, String value, String percent, Color pColor, IconData icon, Color iconColor) {
    return Container(
      width: 120,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Row(
                    children: [
                      Icon(Icons.arrow_drop_up, color: pColor, size: 12),
                      Text(percent, style: TextStyle(color: pColor, fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildProvinceOverview() {
    return Container(
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.public, color: CyberTheme.cyan, size: 14),
                  const SizedBox(width: 6),
                  const Text('PROVINCE INTELLIGENCE OVERVIEW', style: TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
              const Text('Lihat Semua →', style: TextStyle(color: CyberTheme.cyan, fontSize: 8)),
            ],
          ),
          const SizedBox(height: 12),
          // HEADER TABEL
          Row(
            children: const [
              Expanded(flex: 3, child: Text('Province', style: TextStyle(color: CyberTheme.textSec, fontSize: 8))),
              Expanded(flex: 2, child: Text('Mentions', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), textAlign: TextAlign.right)),
              Expanded(flex: 2, child: Text('Engagement', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), textAlign: TextAlign.right)),
              Expanded(flex: 2, child: Text('Reach', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), textAlign: TextAlign.right)),
              Expanded(flex: 2, child: Text('Sentiment', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('Threat Level', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), textAlign: TextAlign.right)),
            ],
          ),
          const Divider(color: CyberTheme.border, height: 16),
          // DATA ROWS
          _provTableRow('DKI Jakarta', '12.4K', '45.2M', '98.7M', '+0.74', 'High', CyberTheme.red, isShield: true),
          _provTableRow('Jawa Timur', '9.1K', '28.6M', '61.3M', '+0.62', 'Medium', CyberTheme.warning),
          _provTableRow('Jawa Barat', '8.7K', '24.1M', '53.6M', '+0.66', 'Medium', CyberTheme.warning, icon: Icons.shield_outlined),
          _provTableRow('Jawa Tengah', '6.3K', '17.8M', '37.2M', '+0.58', 'Medium', CyberTheme.warning, icon: Icons.shield_outlined),
          _provTableRow('Sumatera Utara', '2.8K', '8.2M', '18.7M', '+0.48', 'Low', CyberTheme.green, icon: Icons.shield_outlined),
        ],
      ),
    );
  }

  Widget _provTableRow(String prov, String ment, String eng, String reach, String sent, String threat, Color tColor, {bool isShield = false, IconData icon = Icons.security}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(flex: 3, child: Row(
            children: [
              Icon(icon, color: tColor, size: 10),
              const SizedBox(width: 4),
              Expanded(child: Text(prov, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), overflow: TextOverflow.ellipsis)),
            ],
          )),
          Expanded(flex: 2, child: Text(ment, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text(eng, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text(reach, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), textAlign: TextAlign.right)),
          Expanded(flex: 2, child: Text(sent, style: const TextStyle(color: CyberTheme.green, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(threat, style: TextStyle(color: tColor, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildCardBase({required String title, required Widget child, Widget? trailing, double width = 240}) {
    return Container(
      width: width,
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5), overflow: TextOverflow.ellipsis)),
              if (trailing != null) trailing else const Icon(Icons.more_horiz, color: CyberTheme.textSec, size: 12),
            ],
          ),
          const SizedBox(height: 12),
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

  Widget _buildTopCitiesCard() {
    return _buildCardBase(
      title: 'TOP CITIES',
      trailing: _buildDropdownTrailing('24 Jam'),
      width: 250,
      child: Column(
        children: [
          _cityRow('1', 'Jakarta', '8.9K', '34.6M', CyberTheme.green),
          _cityRow('2', 'Surabaya', '5.8K', '19.7M', CyberTheme.green),
          _cityRow('3', 'Bandung', '3.9K', '14.2M', CyberTheme.green),
          _cityRow('4', 'Medan', '2.8K', '9.1M', CyberTheme.green),
          _cityRow('5', 'Makassar', '2.4K', '8.6M', CyberTheme.green),
        ],
      ),
    );
  }

  Widget _cityRow(String num, String name, String ment, String reach, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 12, child: Text(num, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8))),
          Expanded(flex: 3, child: Text(name, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Text(ment, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8))),
          Expanded(flex: 2, child: SizedBox(height: 8, child: CustomPaint(painter: MiniSparklinePainter(color: color)))),
          const SizedBox(width: 4),
          Expanded(flex: 2, child: Text(reach, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8), textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _buildSentimentRatioCard() {
    return _buildCardBase(
      title: 'SENTIMENT RATIO',
      width: 220,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: CustomPaint(
              painter: SimpleDonutPainter(
                data: [
                  {'val': 0.682, 'color': CyberTheme.green},
                  {'val': 0.196, 'color': CyberTheme.darkBlue},
                  {'val': 0.122, 'color': CyberTheme.red},
                ],
                strokeWidth: 14,
                drawStar: true
              ), 
              size: const Size(80, 80)
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _distLegendRowVertical(CyberTheme.green, 'Positive', '68.2%', '10.7M'),
                _distLegendRowVertical(CyberTheme.darkBlue, 'Neutral', '19.6%', '3.1M'),
                _distLegendRowVertical(CyberTheme.red, 'Negative', '12.2%', '1.9M'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildThreatLevelCard() {
    return _buildCardBase(
      title: 'THREAT LEVEL DISTRIBUTION',
      width: 220,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: SimpleDonutPainter(
                    data: [
                      {'val': 0.25, 'color': CyberTheme.red},
                      {'val': 0.47, 'color': CyberTheme.warning},
                      {'val': 0.28, 'color': CyberTheme.green},
                    ],
                    strokeWidth: 14,
                  ), 
                  size: const Size(80, 80)
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('32', style: TextStyle(color: CyberTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Total Alerts', style: TextStyle(color: CyberTheme.textSec, fontSize: 5)),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _distLegendRowVertical(CyberTheme.red, 'High', '8 (25%)', ''),
                _distLegendRowVertical(CyberTheme.warning, 'Medium', '15 (47%)', ''),
                _distLegendRowVertical(CyberTheme.green, 'Low', '9 (28%)', ''),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _distLegendRowVertical(Color color, String label, String pct, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(Icons.circle, color: color, size: 6),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                    const SizedBox(width: 4),
                    Text(pct, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold)),
                  ],
                ),
                if (val.isNotEmpty) Text(val, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentionsTrendCard() {
    return _buildCardBase(
      title: 'MENTIONS TREND BY LOCATION',
      trailing: _buildDropdownTrailing('7 Hari'),
      width: 350,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _legendDot('Java', CyberTheme.warning), const SizedBox(width: 8),
                _legendDot('Sumatera', CyberTheme.cyan), const SizedBox(width: 8),
                _legendDot('Kalimantan', CyberTheme.green), const SizedBox(width: 8),
                _legendDot('Sulawesi', Colors.blue), const SizedBox(width: 8),
                _legendDot('Papua', CyberTheme.red),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: CustomPaint(painter: LocationLineChartPainter(), size: Size.infinite)),
        ],
      ),
    );
  }

  Widget _buildEngagementHeatmapCard() {
    return _buildCardBase(
      title: 'ENGAGEMENT HEATMAP',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropdownTrailing('7 Hari'),
          const SizedBox(width: 8),
          const Text('Low', style: TextStyle(color: CyberTheme.textSec, fontSize: 6)),
          const SizedBox(width: 4),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), gradient: const LinearGradient(colors: [CyberTheme.darkBlue, CyberTheme.cyan, CyberTheme.green, CyberTheme.warning])),
          ),
          const SizedBox(width: 4),
          const Text('High', style: TextStyle(color: CyberTheme.textSec, fontSize: 6)),
        ],
      ),
      width: 300,
      child: CustomPaint(painter: GeoHeatmapPainter(), size: Size.infinite),
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: color, size: 6),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7)),
      ],
    );
  }

  // --- PERBAIKAN: Fungsi Navigasi Diperbarui di Sini ---
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
          }),
          _navItem(Icons.wifi_tethering, 'Feed', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FeedScreen()));
          }),
          _navItem(Icons.bar_chart, 'Analytics', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
          }),
          _navItem(Icons.public, 'GeoIntel', isActive: true),
          
          // <-- 2. Update tombol Threat
          _navItem(Icons.shield_outlined, 'Threat', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ThreatScreen()));
          }),
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

class GeoMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simulasi rupa pulau-pulau Indonesia menggunakan dots & blur
    final paintBase = Paint()..color = CyberTheme.border.withOpacity(0.3)..style = PaintingStyle.fill;
    
    // Titik-titik panas (Heat glow)
    final glowGreen = Paint()..color = CyberTheme.green.withOpacity(0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final glowRed = Paint()..color = CyberTheme.red.withOpacity(0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    final glowYellow = Paint()..color = CyberTheme.warning.withOpacity(0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    final glowCyan = Paint()..color = CyberTheme.cyan.withOpacity(0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final w = size.width;
    final h = size.height;

    // Draw some grid lines in background
    final grid = Paint()..color = Colors.white.withOpacity(0.02)..strokeWidth=1;
    for (double i=0; i<h; i+=20) canvas.drawLine(Offset(0,i), Offset(w,i), grid);
    for (double i=0; i<w; i+=20) canvas.drawLine(Offset(i,0), Offset(i,h), grid);

    final pointsData = [
      {'pos': Offset(w*0.18, h*0.42), 'paint': glowGreen, 'r': 15.0}, // Sumatera Utara
      {'pos': Offset(w*0.30, h*0.58), 'paint': glowCyan, 'r': 12.0}, // Riau
      {'pos': Offset(w*0.28, h*0.72), 'paint': glowYellow, 'r': 14.0}, // Sumsel
      {'pos': Offset(w*0.38, h*0.88), 'paint': glowRed, 'r': 20.0}, // Jakarta (Hot)
      {'pos': Offset(w*0.50, h*0.92), 'paint': glowYellow, 'r': 16.0}, // Jabar
      {'pos': Offset(w*0.58, h*0.86), 'paint': glowYellow, 'r': 14.0}, // Jateng
      {'pos': Offset(w*0.68, h*0.94), 'paint': glowYellow, 'r': 15.0}, // Jatim
      {'pos': Offset(w*0.62, h*0.50), 'paint': glowCyan, 'r': 12.0}, // Kaltim
      {'pos': Offset(w*0.72, h*0.62), 'paint': glowYellow, 'r': 14.0}, // Sulsel
      {'pos': Offset(w*0.78, h*0.84), 'paint': glowGreen, 'r': 12.0}, // Bali
      {'pos': Offset(w*0.85, h*0.94), 'paint': glowCyan, 'r': 10.0}, // NTT
      {'pos': Offset(w*0.88, h*0.72), 'paint': glowCyan, 'r': 10.0}, // Maluku
      {'pos': Offset(w*0.92, h*0.64), 'paint': glowGreen, 'r': 10.0}, // Papua
    ];

    // Gambar lingkaran penghubung map (hanya simulasi)
    for (var d in pointsData) {
      final pos = d['pos'] as Offset;
      // Glow
      canvas.drawCircle(pos, d['r'] as double, d['paint'] as Paint);
      // Radar rings
      canvas.drawCircle(pos, (d['r'] as double) * 1.5, Paint()..color=Colors.white24..style=PaintingStyle.stroke..strokeWidth=0.5);
      // Center dot
      canvas.drawCircle(pos, 3, Paint()..color=Colors.white);
      canvas.drawCircle(pos, 1, Paint()..color=CyberTheme.background);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SimpleDonutPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double strokeWidth;
  final bool drawStar;

  SimpleDonutPainter({required this.data, this.strokeWidth = 12.0, this.drawStar = false});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
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
      
      // Draw star in first segment
      if (drawStar && d['color'] == CyberTheme.green) {
        final midAngle = startAngle + (sweepAngle / 2);
        final starX = center.dx + radius * math.cos(midAngle);
        final starY = center.dy + radius * math.sin(midAngle);
        _drawStar(canvas, Offset(starX, starY), 3, Colors.white);
      }
      
      startAngle += sweepAngle;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()..color = color;
    canvas.drawCircle(center, size, paint); // Simplify as circle instead of star for now
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LocationLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final h = size.height - 12;
    final w = size.width;

    // Y Axis
    final yLabels = ['12K', '8K', '4K', '0'];
    final gridPaint = Paint()..color = CyberTheme.border..strokeWidth = 1;
    for (int i = 0; i < yLabels.length; i++) {
      final y = h * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      final tp = TextPainter(text: TextSpan(text: yLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, y - 8));
    }

    // X Axis
    final xLabels = ['7 Mei', '8 Mei', '9 Mei', '10 Mei', '11 Mei', '12 Mei', '13 Mei'];
    for (int i = 0; i < xLabels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      double x = (w - tp.width) * (i / 6);
      if (i == 0) x = 16;
      tp.paint(canvas, Offset(x, h + 4));
    }

    // Lines (Java, Sumatera, Kalimantan, Sulawesi, Papua)
    _drawLine(canvas, w, h, [0.1, 0.2, 0.15, 0.3, 0.2, 0.1, 0.15], CyberTheme.warning); // Java (Top)
    _drawLine(canvas, w, h, [0.3, 0.4, 0.5, 0.4, 0.6, 0.5, 0.4], CyberTheme.cyan);     // Sumatera
    _drawLine(canvas, w, h, [0.6, 0.5, 0.6, 0.7, 0.6, 0.7, 0.55], CyberTheme.green);   // Kalimantan
    _drawLine(canvas, w, h, [0.8, 0.85, 0.7, 0.8, 0.85, 0.8, 0.75], Colors.blue);      // Sulawesi
    _drawLine(canvas, w, h, [0.9, 0.95, 0.9, 0.85, 0.9, 0.95, 0.9], CyberTheme.red);   // Papua (Bottom)
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

class GeoHeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rows = 4;
    final cols = 15;
    
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    final labels = ['00:00', '06:00', '12:00', '18:00'];
    for (int r = 0; r < rows; r++) {
      final tp = TextPainter(text: TextSpan(text: labels[r], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, r * cellH + (cellH - tp.height)/2));
    }

    final xLabels = ['7 Mei', '8 Mei', '9 Mei', '10 Mei', '11 Mei', '12 Mei', '13 Mei'];
    for (int i = 0; i < xLabels.length; i++) {
       final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
       double x = 20 + ((size.width - 20) * (i / (xLabels.length - 1)));
       if (x > size.width - tp.width) x = size.width - tp.width;
       tp.paint(canvas, Offset(x, size.height - 10));
    }

    final startX = 20.0;
    final actualW = size.width - startX;
    final gridCellW = actualW / cols;
    final gridCellH = (size.height - 15) / rows;

    final rnd = math.Random(10); 
    final baseColors = [CyberTheme.darkBlue, CyberTheme.cyan, CyberTheme.green, CyberTheme.warning];

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        double intensity = rnd.nextDouble() * 0.6 + (c/cols)*0.4;
        if (r == 2 && c > 8) intensity = 0.9; 
        
        Color cellColor;
        if (intensity < 0.3) cellColor = baseColors[0].withOpacity(0.5);
        else if (intensity < 0.6) cellColor = baseColors[1].withOpacity(0.8);
        else if (intensity < 0.85) cellColor = baseColors[2];
        else cellColor = baseColors[3];

        final rect = Rect.fromLTWH(startX + c * gridCellW + 1, r * gridCellH + 1, gridCellW - 2, gridCellH - 2);
        canvas.drawRect(rect, Paint()..color = cellColor);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}