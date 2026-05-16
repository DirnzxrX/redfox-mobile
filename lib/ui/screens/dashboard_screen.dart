import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'profile_screen.dart';
import 'settings_screen.dart';
import 'feed_screen.dart';
import 'analytics_screen.dart';
import 'geointel_screen.dart';
import 'threat_screen.dart'; // Import GeoIntel ditambahkan

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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopAppBar(context),
            _buildSearchBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. TOP STATS GRID (2x4) ---
                    _buildTopStatsGrid(),
                    const SizedBox(height: 12),

                    // --- 2. ROW: TIMELINE & SOURCES ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildSentimentTimeline()),
                        const SizedBox(width: 10),
                        Expanded(flex: 4, child: _buildSourceDistribution()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 3. ROW: MENTIONS & ANOMALY ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: _buildMentionsOverTime()),
                        const SizedBox(width: 10),
                        Expanded(flex: 1, child: _buildAnomalyDetection()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 4. INDONESIA INTELLIGENCE MAP ---
                    _buildMapSection(),
                    const SizedBox(height: 12),

                    // --- 5. 4-COLUMN HIGHLIGHTS (Scrollable Horizontal biar gak pecah di HP) ---
                    SizedBox(
                      height: 180,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildInfoCardWide('AI INTELLIGENCE SUMMARY', _buildAiSummaryContent()),
                            const SizedBox(width: 10),
                            _buildInfoCard('THREAT ALERT CENTER', _buildAlertCenterContent()),
                            const SizedBox(width: 10),
                            _buildInfoCard('SUSPICIOUS ACTIVITY', _buildSuspiciousContent()),
                            const SizedBox(width: 10),
                            _buildInfoCard('BOT DETECTION', _buildBotContent()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- 6. 4-COLUMN BOTTOM (Scrollable) ---
                    SizedBox(
                      height: 140,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            _buildInfoCard('TRENDING HASHTAGS', _buildHashtagsContent()),
                            const SizedBox(width: 10),
                            _buildInfoCard('VIRAL CONTENT', _buildViralContent()),
                            const SizedBox(width: 10),
                            _buildInfoCard('TOP AUTHORS', _buildTopAuthorsContent()),
                            const SizedBox(width: 10),
                            _buildInfoCard('ENGAGEMENT RATE', _buildEngagementContent()),
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
  // WIDGET BUILDERS
  // ===========================================================================

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          // Logo AIRA
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('AIRA', style: TextStyle(color: CyberTheme.cyan, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('Advanced Intelligence\nRecon & Analytics', style: TextStyle(color: CyberTheme.textSec, fontSize: 6, height: 1.2)),
            ],
          ),
          const SizedBox(width: 16),
          // Profile
          PopupMenuButton<String>(
            offset: const Offset(0, 45),
            color: CyberTheme.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: CyberTheme.border),
            ),
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
            child: Row(
              children: [
                const CircleAvatar(radius: 14, backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=11')),
                const SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Analyst', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                    Row(
                      children: const [
                        Text('TNI AU', style: TextStyle(color: CyberTheme.textMain, fontSize: 10, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: CyberTheme.textSec, size: 12),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
          // Project Selector
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
          // Notification
          Stack(
            children: [
              const Icon(Icons.notifications_none, color: CyberTheme.textSec, size: 24),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: CyberTheme.red, shape: BoxShape.circle),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 6, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // --- ITEM MENU DROPDOWN ---
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: CyberTheme.border)),
              child: const Row(
                children: [
                  Icon(Icons.search, color: CyberTheme.textSec, size: 16),
                  SizedBox(width: 8),
                  Expanded(child: Text('Search intelligence, keywords, accounts, hashtags...', style: TextStyle(color: CyberTheme.textSec, fontSize: 10), overflow: TextOverflow.ellipsis)),
                  Icon(Icons.tune, color: CyberTheme.cyan, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(18), border: Border.all(color: CyberTheme.border)),
            child: Row(
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: CyberTheme.green, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LIVE', style: TextStyle(color: CyberTheme.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    Text('Realtime', style: TextStyle(color: CyberTheme.green, fontSize: 6)),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.show_chart, color: CyberTheme.cyan, size: 16),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.3, // Proporsi kartu agar pas di HP
      children: [
        _buildStatCard('TOTAL MENTIONS', '15.765.388', '+100%', CyberTheme.green, Icons.arrow_drop_up, miniChartMode: 1),
        _buildStatCard('THREAT SCORE', '78 /100', 'High', CyberTheme.red, Icons.warning_amber_rounded, miniChartMode: 2, isThreat: true),
        _buildStatCard('POSITIVE SENTIMENT', '68.2%', '', CyberTheme.green, Icons.sentiment_satisfied_alt, miniChartMode: 1, showSparklineOnly: true),
        _buildStatCard('NEGATIVE SENTIMENT', '21.6%', '', CyberTheme.red, Icons.sentiment_very_dissatisfied, miniChartMode: 2, showSparklineOnly: true),
        _buildStatCardIcon('ACTIVE SOURCES', '247', '+12%', CyberTheme.green, Icons.cell_tower, CyberTheme.cyan),
        _buildStatCardIcon('TRENDING TOPICS', '128', '+8%', CyberTheme.green, Icons.local_fire_department, CyberTheme.red),
        _buildStatCardIcon('ENGAGEMENT REACH', '98.4M', '+134%', CyberTheme.green, Icons.people_alt, CyberTheme.cyan),
        _buildStatCardIcon('ALERT COUNT', '32', '+18%', CyberTheme.green, Icons.warning_amber_rounded, CyberTheme.red),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, Color subColor, IconData subIcon, {int miniChartMode = 0, bool isThreat = false, bool showSparklineOnly = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              const Icon(Icons.more_horiz, color: CyberTheme.textSec, size: 12),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isThreat) const Padding(padding: EdgeInsets.only(bottom: 2, right: 4), child: Icon(Icons.shield, color: CyberTheme.warning, size: 14)),
              if (showSparklineOnly) Padding(padding: const EdgeInsets.only(bottom: 2, right: 4), child: Icon(subIcon, color: subColor, size: 14)),
              Expanded(child: Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
          Row(
            children: [
              if (!showSparklineOnly) ...[
                Icon(subIcon, color: subColor, size: 12),
                Text(subtitle, style: TextStyle(color: subColor, fontSize: 9)),
                const SizedBox(width: 8),
              ],
              if (miniChartMode > 0)
                Expanded(child: SizedBox(height: 12, child: CustomPaint(painter: MiniSparklinePainter(color: miniChartMode == 1 ? CyberTheme.green : CyberTheme.red)))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatCardIcon(String title, String value, String subtitle, Color subColor, IconData iconRight, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              const Icon(Icons.more_horiz, color: CyberTheme.textSec, size: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    Row(
                      children: [
                        Icon(Icons.arrow_drop_up, color: subColor, size: 12),
                        Text(subtitle, style: TextStyle(color: subColor, fontSize: 9)),
                      ],
                    )
                  ],
                ),
              ),
              Icon(iconRight, color: iconColor, size: 24),
            ],
          )
        ],
      ),
    );
  }

  // --- CARDS LAYOUT ---

  Widget _buildCardBase({required String title, required Widget child, Widget? trailing}) {
    return Container(
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 2, height: 10, color: CyberTheme.cyan),
                  const SizedBox(width: 6),
                  Text(title, style: const TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSentimentTimeline() {
    return SizedBox(
      height: 180,
      child: _buildCardBase(
        title: 'SENTIMENT TIMELINE',
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: const [Text('24 JAM', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)), Icon(Icons.arrow_drop_down, color: CyberTheme.textSec, size: 12)],
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                _legendDot('Positive', CyberTheme.green),
                const SizedBox(width: 8),
                _legendDot('Negative', CyberTheme.red),
                const SizedBox(width: 8),
                _legendDot('Neutral', CyberTheme.textSec),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(child: CustomPaint(painter: SentimentTimelinePainter(), size: Size.infinite)),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceDistribution() {
    return SizedBox(
      height: 180,
      child: _buildCardBase(
        title: 'SOURCE DISTRIBUTION',
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(painter: SourceDonutPainter(), size: const Size(90, 90)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('247', style: TextStyle(color: CyberTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('SOURCES', style: TextStyle(color: CyberTheme.textSec, fontSize: 6)),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _sourceLegendRow(CyberTheme.cyan, 'X (Twitter)', '35.6%'),
                  _sourceLegendRow(CyberTheme.red, 'Instagram', '22.8%'),
                  _sourceLegendRow(CyberTheme.warning, 'YouTube', '16.7%'),
                  _sourceLegendRow(CyberTheme.green, 'News Portal', '10.2%'),
                  _sourceLegendRow(Colors.purpleAccent, 'Telegram', '8.1%'),
                  _sourceLegendRow(Colors.pinkAccent, 'TikTok', '4.3%'),
                  _sourceLegendRow(CyberTheme.textSec, 'Lainnya', '2.3%'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sourceLegendRow(Color color, String label, String pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 6),
          const SizedBox(width: 4),
          Expanded(child: Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Text(pct, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMentionsOverTime() {
    return SizedBox(
      height: 160,
      child: _buildCardBase(
        title: 'MENTIONS OVER TIME',
        trailing: _buildTimeFilter('7 HARI'),
        child: CustomPaint(painter: MentionsAreaPainter(color: CyberTheme.cyan), size: Size.infinite),
      ),
    );
  }

  Widget _buildAnomalyDetection() {
    return SizedBox(
      height: 160,
      child: _buildCardBase(
        title: 'ANOMALY DETECTION',
        trailing: _buildTimeFilter('7 HARI'),
        child: CustomPaint(painter: AnomalyAreaPainter(color: CyberTheme.red), size: Size.infinite),
      ),
    );
  }

  Widget _buildTimeFilter(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 220,
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
                  Container(width: 2, height: 10, color: CyberTheme.cyan),
                  const SizedBox(width: 6),
                  const Text('INDONESIA INTELLIGENCE MAP', style: TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ],
              ),
              Row(
                children: [
                  const Text('Low', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                  const SizedBox(width: 4),
                  Container(
                    width: 60, height: 4,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), gradient: const LinearGradient(colors: [CyberTheme.cyan, CyberTheme.green, CyberTheme.warning, CyberTheme.red])),
                  ),
                  const SizedBox(width: 4),
                  const Text('High', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(4)),
                    child: Row(children: const [Text('Mentions', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)), Icon(Icons.arrow_drop_down, color: CyberTheme.textSec, size: 12)]),
                  ),
                ],
              )
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                // MAP PAINTER (Background and Dots)
                SizedBox(width: double.infinity, height: double.infinity, child: CustomPaint(painter: MapPainter())),
                
                // TOP PROVINCES OVERLAY
                Positioned(
                  left: 0, bottom: 0,
                  child: Container(
                    width: 120,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: CyberTheme.cardBg.withOpacity(0.8), border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('TOP PROVINCES', style: TextStyle(color: CyberTheme.textSec, fontSize: 7, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        _provRow('1', 'Jawa Barat', '2.5M'),
                        _provRow('2', 'Jawa Tengah', '1.8M'),
                        _provRow('3', 'Jawa Timur', '1.6M'),
                        _provRow('4', 'DKI Jakarta', '1.3M'),
                        _provRow('5', 'Sulawesi Selatan', '980K'),
                        const SizedBox(height: 6),
                        const Text('Lihat Semua →', style: TextStyle(color: CyberTheme.cyan, fontSize: 7)),
                      ],
                    ),
                  ),
                ),
                // LAST UPDATE OVERLAY
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: CyberTheme.cardBg.withOpacity(0.8), border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.my_location, color: CyberTheme.cyan, size: 16),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Last Update', style: TextStyle(color: CyberTheme.textSec, fontSize: 7)),
                            Text('13 Mei 2026 21:41', style: TextStyle(color: CyberTheme.textMain, fontSize: 8)),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Sources 247', style: TextStyle(color: CyberTheme.textSec, fontSize: 7)),
                            Text('Mentions 15.7M', style: TextStyle(color: CyberTheme.textSec, fontSize: 7)),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _provRow(String num, String name, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          SizedBox(width: 10, child: Text(num, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8))),
          Expanded(child: Text(name, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8))),
          Text(val, style: const TextStyle(color: CyberTheme.green, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // --- HORIZONTAL SCROLL CARDS ---

  Widget _buildInfoCard(String title, Widget content) {
    return Container(
      width: 200, // Fixed width for horizontal scrolling
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getIconForTitle(title), color: _getColorForTitle(title), size: 12),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(color: _getColorForTitle(title), fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: content),
          const SizedBox(height: 6),
          const Text('Lihat Semua >', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildInfoCardWide(String title, Widget content) {
    return Container(
      width: 280, 
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory, color: CyberTheme.cyan, size: 12),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: content),
          const SizedBox(height: 6),
          const Text('Lihat Ringkasan Lengkap >', style: TextStyle(color: CyberTheme.cyan, fontSize: 8)),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String t) {
    if (t.contains('THREAT')) return Icons.warning_amber;
    if (t.contains('SUSPICIOUS')) return Icons.remove_red_eye_outlined;
    if (t.contains('BOT')) return Icons.smart_toy_outlined;
    if (t.contains('TRENDING')) return Icons.tag;
    if (t.contains('VIRAL')) return Icons.play_circle_outline;
    if (t.contains('AUTHORS')) return Icons.people_outline;
    if (t.contains('ENGAGEMENT')) return Icons.show_chart;
    return Icons.info_outline;
  }

  Color _getColorForTitle(String t) {
    if (t.contains('THREAT')) return CyberTheme.red;
    if (t.contains('SUSPICIOUS')) return CyberTheme.cyan;
    if (t.contains('BOT')) return CyberTheme.cyan;
    return CyberTheme.textSec;
  }

  // Card Contents
  Widget _buildAiSummaryContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bulletText('Peningkatan percakapan signifikan terkait isu pengadaan alutsista dan militer TNI AU dalam 24 jam terakhir. Sentimen negatif meningkat di beberapa wilayah terkait potensi disinformasi.'),
      ],
    );
  }

  Widget _buildAlertCenterContent() {
    return Column(
      children: [
        _alertRow(Icons.warning, 'Disinformation Campaign', 'High', CyberTheme.red),
        _alertRow(Icons.campaign, 'Propaganda Activity', 'High', CyberTheme.red),
        _alertRow(Icons.hub, 'Suspicious Network', 'Medium', CyberTheme.warning),
        _alertRow(Icons.find_replace, 'Information Manipulation', 'Medium', CyberTheme.warning),
      ],
    );
  }

  Widget _alertRow(IconData icon, String label, String level, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: 4),
          Expanded(child: Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Text(level, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSuspiciousContent() {
    return Column(
      children: [
        _suspiciousRow('[Unusual Keyword Spike]', '14:32'),
        _suspiciousRow('Coordinated Narrative', '13:18'),
        _suspiciousRow('Mass Reporting Activity', '12:05'),
        _suspiciousRow('Abnormal Engagement', '10:47'),
      ],
    );
  }

  Widget _suspiciousRow(String label, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Text(time, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildBotContent() {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50, height: 50,
              child: CircularProgressIndicator(value: 0.38, strokeWidth: 4, backgroundColor: CyberTheme.border, color: CyberTheme.cyan),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('38%', style: TextStyle(color: CyberTheme.textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                Text('Bot Probability', style: TextStyle(color: CyberTheme.textSec, fontSize: 5)),
              ],
            )
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _botRow('High Risk', '124'),
              _botRow('Medium Risk', '245'),
              _botRow('Low Risk', '1,024'),
            ],
          ),
        )
      ],
    );
  }
  
  Widget _botRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
        Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHashtagsContent() {
    return Column(
      children: [
        _hashRow('#tni', '12.5K'),
        _hashRow('#natuna', '8.2K'),
        _hashRow('#alutsista', '6.1K'),
      ],
    );
  }

  Widget _hashRow(String tag, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(tag, style: const TextStyle(color: CyberTheme.textSec, fontSize: 9)),
          Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildViralContent() {
     return Column(
      children: [
        _viralRow(Icons.play_arrow, 'Video', '23'),
        _viralRow(Icons.image, 'Image', '18'),
        _viralRow(Icons.article, 'Article', '9'),
      ],
    );
  }

  Widget _viralRow(IconData icon, String type, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: CyberTheme.cyan, size: 10),
          const SizedBox(width: 6),
          Expanded(child: Text(type, style: const TextStyle(color: CyberTheme.textSec, fontSize: 9))),
          Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTopAuthorsContent() {
     return Column(
      children: [
        _authorRow(Icons.person, 'Influential', '128'),
        _authorRow(Icons.group, 'Active', '247'),
        _authorRow(Icons.person_add, 'New', '53'),
      ],
    );
  }

  Widget _authorRow(IconData icon, String type, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: CyberTheme.cyan, size: 10),
          const SizedBox(width: 6),
          Expanded(child: Text(type, style: const TextStyle(color: CyberTheme.textSec, fontSize: 9))),
          Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildEngagementContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Avg. Rate', style: TextStyle(color: CyberTheme.textSec, fontSize: 9)),
            Text('6.78%', style: TextStyle(color: CyberTheme.textMain, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Max. Rate', style: TextStyle(color: CyberTheme.textSec, fontSize: 9)),
            Text('24.12%', style: TextStyle(color: CyberTheme.textMain, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _bulletText(String text) {
    return Text(text, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8, height: 1.4), maxLines: 4, overflow: TextOverflow.ellipsis);
  }

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
          _navItem(Icons.dashboard, 'Dashboard', isActive: true),
          
          _navItem(Icons.wifi_tethering, 'Feed', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedScreen()));
          }),
          
          _navItem(Icons.bar_chart, 'Analytics', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
          }),
          
          _navItem(Icons.public, 'GeoIntel', onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const GeoIntelScreen()));
          }),
          
          _navItem(Icons.shield_outlined, 'Threat', onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (_) => const ThreatScreen()));
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
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SentimentTimelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final chartHeight = size.height - 16;
    final chartWidth = size.width;

    // Y Axis labels
    final yLabels = ['100%', '75%', '50%', '25%', '0%'];
    final gridPaint = Paint()..color = CyberTheme.border..strokeWidth = 1;
    for (int i = 0; i < yLabels.length; i++) {
      final y = chartHeight * (i / (yLabels.length - 1));
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), gridPaint);
      final tp = TextPainter(text: TextSpan(text: yLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, y - 8));
    }

    // X Axis labels
    final xLabels = ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'];
    for (int i = 0; i < xLabels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      double x = (chartWidth - tp.width) * (i / (xLabels.length - 1));
      if (i == 0) x = 16;
      tp.paint(canvas, Offset(x, chartHeight + 4));
    }

    // Draw Lines
    _drawLineWithDots(canvas, chartWidth, chartHeight, [0.3, 0.2, 0.4, 0.3, 0.5, 0.2, 0.4, 0.3, 0.2, 0.5, 0.3], CyberTheme.green);
    _drawLineWithDots(canvas, chartWidth, chartHeight, [0.6, 0.5, 0.7, 0.6, 0.8, 0.5, 0.7, 0.6, 0.5, 0.8, 0.6], CyberTheme.red);
    _drawLineWithDots(canvas, chartWidth, chartHeight, [0.8, 0.9, 0.85, 0.95, 0.9, 0.85, 0.95, 0.9, 0.8, 0.9, 0.85], CyberTheme.textSec);
  }

  void _drawLineWithDots(Canvas canvas, double w, double h, List<double> points, Color color) {
    final path = Path();
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final dotPaint = Paint()..color = color..style = PaintingStyle.fill;
    
    for (int i = 0; i < points.length; i++) {
      final x = w * (i / (points.length - 1));
      final y = h * points[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 2, dotPaint);
      canvas.drawCircle(Offset(x, y), 1, Paint()..color = CyberTheme.background); // Inner hole
    }
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MentionsAreaPainter extends CustomPainter {
  final Color color;
  MentionsAreaPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final chartHeight = size.height - 16;
    final chartWidth = size.width;

    // Grid
    for (int i = 0; i < 5; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), Paint()..color = CyberTheme.border..strokeWidth = 1);
    }

    List<double> points = [0.8, 0.7, 0.9, 0.8, 0.6, 0.5, 0.4, 0.3, 0.4, 0.2, 0.1];
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = chartWidth * (i / (points.length - 1));
      final y = chartHeight * points[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      
      canvas.drawCircle(Offset(x,y), 2, Paint()..color=color);
    }

    final fillPath = Path.from(path)..lineTo(chartWidth, chartHeight)..lineTo(0, chartHeight)..close();
    canvas.drawPath(fillPath, Paint()..shader = LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTRB(0, 0, 0, chartHeight)));
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5);
    
    // Label pop
    _drawPopupLabel(canvas, chartWidth * 0.5, chartHeight * 0.5 - 20, '12 Mei\n15.7M Mentions', color);
  }

  void _drawPopupLabel(Canvas canvas, double x, double y, String text, Color color) {
    final rect = Rect.fromCenter(center: Offset(x, y), width: 60, height: 24);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.background..style = PaintingStyle.fill);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.border..style = PaintingStyle.stroke);
    final tp = TextPainter(text: TextSpan(text: text, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textAlign: TextAlign.center, textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(x - tp.width/2, y - tp.height/2));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AnomalyAreaPainter extends CustomPainter {
  final Color color;
  AnomalyAreaPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final chartHeight = size.height - 16;
    final chartWidth = size.width;

    // Grid
    for (int i = 0; i < 5; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(chartWidth, y), Paint()..color = CyberTheme.border..strokeWidth = 1);
    }

    List<double> points = [0.8, 0.7, 0.8, 0.6, 0.7, 0.4, 0.7, 0.5, 0.2, 0.4, 0.1, 0.3];
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = chartWidth * (i / (points.length - 1));
      final y = chartHeight * points[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      canvas.drawCircle(Offset(x,y), 2, Paint()..color=color);
    }

    final fillPath = Path.from(path)..lineTo(chartWidth, chartHeight)..lineTo(0, chartHeight)..close();
    canvas.drawPath(fillPath, Paint()..shader = LinearGradient(colors: [color.withOpacity(0.3), color.withOpacity(0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(Rect.fromLTRB(0, 0, 0, chartHeight)));
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5);
    
    // Label pop
    _drawPopupLabel(canvas, chartWidth * 0.6, chartHeight * 0.4 - 20, 'Spike Detected\n12 Mei 14:00', color);
  }
  void _drawPopupLabel(Canvas canvas, double x, double y, String text, Color color) {
    final rect = Rect.fromCenter(center: Offset(x, y), width: 60, height: 24);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.background..style = PaintingStyle.fill);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.border..style = PaintingStyle.stroke);
    final tp = TextPainter(text: TextSpan(text: text, style: TextStyle(color: color, fontSize: 6)), textAlign: TextAlign.center, textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(x - tp.width/2, y - tp.height/2));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SourceDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = 16.0;

    final data = [
      {'val': 0.35, 'color': CyberTheme.cyan},
      {'val': 0.22, 'color': CyberTheme.red},
      {'val': 0.16, 'color': CyberTheme.warning},
      {'val': 0.10, 'color': CyberTheme.green},
      {'val': 0.08, 'color': Colors.purpleAccent},
      {'val': 0.09, 'color': CyberTheme.textSec},
    ];

    double startAngle = -math.pi / 2;
    for (var d in data) {
      final sweepAngle = (d['val'] as double) * 2 * math.pi;
      final paint = Paint()
        ..color = d['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      
      // Glow effect
      canvas.drawArc(rect, startAngle, sweepAngle - 0.05, false, Paint()..color = (d['color'] as Color).withOpacity(0.3)..style=PaintingStyle.stroke..strokeWidth=strokeWidth..maskFilter=const MaskFilter.blur(BlurStyle.normal, 5));
      canvas.drawArc(rect, startAngle, sweepAngle - 0.05, false, paint);
      
      startAngle += sweepAngle;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Simulating map with glowing dots roughly shaped like Indonesia
    final dotPaintCyan = Paint()..color = CyberTheme.cyan..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final dotPaintRed = Paint()..color = CyberTheme.red..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final dotPaintYellow = Paint()..color = CyberTheme.warning..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final dotPaintGreen = Paint()..color = CyberTheme.green..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final dots = [
      // Sumatera area
      Offset(size.width * 0.2, size.height * 0.4), Offset(size.width * 0.25, size.height * 0.5), Offset(size.width * 0.3, size.height * 0.6),
      // Java area (Red hot)
      Offset(size.width * 0.35, size.height * 0.75), Offset(size.width * 0.4, size.height * 0.78), Offset(size.width * 0.48, size.height * 0.76),
      // Kalimantan
      Offset(size.width * 0.45, size.height * 0.4), Offset(size.width * 0.5, size.height * 0.5), Offset(size.width * 0.55, size.height * 0.45),
      // Sulawesi
      Offset(size.width * 0.6, size.height * 0.5), Offset(size.width * 0.65, size.height * 0.6), Offset(size.width * 0.62, size.height * 0.7),
      // Papua area
      Offset(size.width * 0.8, size.height * 0.5), Offset(size.width * 0.85, size.height * 0.55), Offset(size.width * 0.9, size.height * 0.6),
    ];

    for (int i = 0; i < dots.length; i++) {
      Paint p = dotPaintCyan;
      double r = 4.0;
      if (i >= 3 && i <= 5) { p = dotPaintRed; r = 6.0; } // Java is hot
      else if (i == 7 || i == 11) { p = dotPaintYellow; r = 5.0; }
      else if (i == 1 || i == 13) { p = dotPaintGreen; r = 4.0; }
      
      canvas.drawCircle(dots[i], r, p);
      canvas.drawCircle(dots[i], r/2, Paint()..color=Colors.white); // bright center
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}