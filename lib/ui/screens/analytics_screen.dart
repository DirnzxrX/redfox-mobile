import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

import 'profile_screen.dart';
import 'settings_screen.dart';
import 'dashboard_screen.dart';
import 'feed_screen.dart';
import 'geointel_screen.dart';
import 'threat_screen.dart'; // Import Threat ditambahkan

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

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
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
                    // --- 1. TOP STATS (4 Kolom) ---
                    Row(
                      children: [
                        Expanded(child: _buildTopStatCard('TOTAL MENTIONS', '15.765.388', '+134%', CyberTheme.green, 'vs yesterday')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTopStatCard('TOTAL REACH', '98.4M', '+134%', CyberTheme.green, '')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTopStatCard('ENGAGEMENT', '7.2M', '+126%', CyberTheme.cyan, '')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTopStatCardSentiment('AVG SENTIMENT', '+0.68', '+18%', CyberTheme.green)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 2. ROW: SENTIMENT OVER TIME & DISTRIBUTION ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildSentimentOverTime()),
                        const SizedBox(width: 10),
                        Expanded(flex: 4, child: _buildSentimentDistribution()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 3. ROW: WORD CLOUD & GENDER ESTIMATE ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildWordCloud()),
                        const SizedBox(width: 10),
                        Expanded(flex: 4, child: _buildGenderEstimate()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 4. ROW: ENGAGEMENT & REACH VS MENTIONS ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildEngagementOverTime()),
                        const SizedBox(width: 10),
                        Expanded(flex: 5, child: _buildReachVsMentions()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 5. ROW: HASHTAG ANALYTICS & SOURCE DISTRIBUTION ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: _buildHashtagAnalytics()),
                        const SizedBox(width: 10),
                        Expanded(flex: 4, child: _buildSourceDistribution()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 6. ROW: TREND ANALYSIS & RISING TOPICS ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildTrendAnalysis()),
                        const SizedBox(width: 10),
                        Expanded(flex: 4, child: _buildRisingTopics()),
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
    final tabs = ['Overview', 'Sentiment', 'Demographic', 'Engagement', 'Hashtag', 'Sources', 'Geo', 'Trends'];
    return SizedBox(
      height: 30,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse}),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final isActive = index == 0;
            return Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: isActive ? const BoxDecoration(border: Border(bottom: BorderSide(color: CyberTheme.cyan, width: 2))) : null,
              child: Center(
                child: Text(tabs[index], style: TextStyle(color: isActive ? CyberTheme.textMain : CyberTheme.textSec, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
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
                  Expanded(child: Text('13 Mei 26 - 13 Mei 26', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 4),
                  Icon(Icons.calendar_today, color: CyberTheme.textSec, size: 12),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: Container(
              height: 32, padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: CyberTheme.border)),
              child: const Row(
                children: [
                  Expanded(child: Text('24 Jam Terakhir', style: TextStyle(color: CyberTheme.textSec, fontSize: 8), overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: CyberTheme.textSec, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            height: 32, padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: CyberTheme.border)),
            child: const Row(
              children: [
                Icon(Icons.filter_alt_outlined, color: CyberTheme.cyan, size: 12),
                SizedBox(width: 4),
                Text('Filter', style: TextStyle(color: CyberTheme.cyan, fontSize: 8, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            height: 32, width: 32,
            decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: CyberTheme.border)),
            child: const Icon(Icons.file_download_outlined, color: CyberTheme.cyan, size: 14),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGET BUILDERS: CARDS & CHARTS
  // ===========================================================================

  Widget _buildTopStatCard(String title, String value, String percent, Color pColor, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: CyberTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              const Icon(Icons.more_vert, color: CyberTheme.textSec, size: 10),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis), 
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.arrow_drop_up, color: pColor, size: 10),
              Text(percent, style: TextStyle(color: pColor, fontSize: 7, fontWeight: FontWeight.bold)),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(width: 2),
                Expanded(child: Text(subtitle, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6), overflow: TextOverflow.ellipsis)),
              ] else ...[
                const SizedBox(width: 4),
                Expanded(child: SizedBox(height: 8, child: CustomPaint(painter: MiniLinePainter(color: CyberTheme.cyan)))),
              ]
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopStatCardSentiment(String title, String value, String percent, Color pColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(8), border: Border.all(color: CyberTheme.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              const Icon(Icons.more_vert, color: CyberTheme.textSec, size: 10),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 2),
              const Icon(Icons.sentiment_satisfied_alt, color: CyberTheme.green, size: 12),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.arrow_drop_up, color: pColor, size: 10),
              Text(percent, style: TextStyle(color: pColor, fontSize: 7, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Expanded(child: SizedBox(height: 8, child: CustomPaint(painter: MiniLinePainter(color: CyberTheme.green)))),
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

  Widget _buildSentimentOverTime() {
    return _buildCardBase(
      title: 'SENTIMENT OVER TIME',
      trailing: _buildDropdownTrailing('24 Jam'),
      height: 200,
      child: Column(
        children: [
          Row(
            children: [
              _legendDot('Positive', CyberTheme.green), const SizedBox(width: 8),
              _legendDot('Neutral', CyberTheme.textSec), const SizedBox(width: 8),
              _legendDot('Negative', CyberTheme.red),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: CustomPaint(painter: MultiLineChartPainter(), size: Size.infinite)),
        ],
      ),
    );
  }

  Widget _buildSentimentDistribution() {
    return _buildCardBase(
      title: 'SENTIMENT DISTRIBUTION',
      height: 200,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: DonutChartPainter(
                    data: [
                      {'val': 0.682, 'color': CyberTheme.green},
                      {'val': 0.122, 'color': CyberTheme.red},
                      {'val': 0.196, 'color': CyberTheme.darkBlue},
                    ]
                  ), 
                  size: const Size(80, 80)
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('15.7M', style: TextStyle(color: CyberTheme.textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('Total Mentions', style: TextStyle(color: CyberTheme.textSec, fontSize: 5)),
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
                _distLegendRow(CyberTheme.green, 'Positive', '68.2%', '10.7M'),
                _distLegendRow(CyberTheme.darkBlue, 'Neutral', '19.6%', '3.1M'),
                _distLegendRow(CyberTheme.red, 'Negative', '12.2%', '1.9M'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _distLegendRow(Color color, String label, String pct, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(Icons.circle, color: color, size: 6),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8)),
                const SizedBox(height: 2),
                Text(val, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7)),
              ],
            ),
          ),
          Text(pct, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWordCloud() {
    return _buildCardBase(
      title: 'WORD CLOUD',
      height: 180,
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 6,
          runSpacing: 2,
          children: [
            _word('Indonesia', 24, CyberTheme.cyan),
            _word('militer', 18, CyberTheme.green),
            _word('pertahanan', 16, Colors.blueAccent),
            _word('TNI', 14, CyberTheme.warning),
            _word('keamanan', 12, Colors.purpleAccent),
            _word('pesawat', 10, CyberTheme.red),
            _word('alutsista', 12, CyberTheme.green),
            _word('cyber', 14, CyberTheme.cyan),
            _word('operasi', 10, CyberTheme.textSec),
            _word('ancaman', 12, Colors.blueGrey),
            _word('dunia', 9, Colors.lightBlue),
            _word('strategis', 8, Colors.pinkAccent),
            _word('wilayah', 10, Colors.deepPurpleAccent),
            _word('maritime', 9, CyberTheme.cyan),
          ],
        ),
      ),
    );
  }

  Widget _word(String text, double size, Color color) {
    return Text(text, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold));
  }

  Widget _buildGenderEstimate() {
    return _buildCardBase(
      title: 'GENDER ESTIMATE',
      height: 180,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: DonutChartPainter(
                    data: [
                      {'val': 0.724, 'color': Colors.blue},
                      {'val': 0.276, 'color': Colors.pinkAccent},
                    ],
                    strokeWidth: 14
                  ), 
                  size: const Size(80, 80)
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.man, color: Colors.blue, size: 16),
                    Icon(Icons.woman, color: Colors.pinkAccent, size: 16),
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
                _distLegendRow(Colors.blue, 'Male', '72.4%', '11.4M'),
                _distLegendRow(Colors.pinkAccent, 'Female', '27.6%', '4.3M'),
                _distLegendRow(CyberTheme.textSec, 'Unknown', '0.0%', '0'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEngagementOverTime() {
    return _buildCardBase(
      title: 'ENGAGEMENT OVER TIME',
      trailing: _buildDropdownTrailing('7 Hari'),
      height: 160,
      child: CustomPaint(painter: SingleLineChartPainter(color: CyberTheme.cyan), size: Size.infinite),
    );
  }

  Widget _buildReachVsMentions() {
    return _buildCardBase(
      title: 'REACH VS MENTIONS',
      trailing: _buildDropdownTrailing('7 Hari'),
      height: 160,
      child: Column(
        children: [
          Row(
            children: [
              _legendDot('Reach', CyberTheme.cyan), const SizedBox(width: 8),
              _legendDot('Mentions', CyberTheme.green),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: CustomPaint(painter: DoubleLineChartPainter(), size: Size.infinite)),
        ],
      ),
    );
  }

  Widget _buildHashtagAnalytics() {
    return _buildCardBase(
      title: 'HASHTAG ANALYTICS',
      trailing: _buildDropdownTrailing('24 Jam'),
      height: 200,
      child: Column(
        children: [
          _hashtagRow('1', '#TNI', '12.5K'),
          _hashtagRow('2', '#Natuna', '8.2K'),
          _hashtagRow('3', '#Pertahanan', '6.8K'),
          _hashtagRow('4', '#CyberSecurity', '5.4K'),
          _hashtagRow('5', '#Indonesia', '4.3K'),
          _hashtagRow('6', '#Militer', '3.9K'),
          _hashtagRow('7', '#Alutsista', '3.2K'),
          _hashtagRow('8', '#Keamanan', '2.9K'),
        ],
      ),
    );
  }

  Widget _hashtagRow(String num, String tag, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(width: 12, child: Text(num, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8))),
          Expanded(flex: 3, child: Text(tag, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8))),
          Expanded(flex: 2, child: SizedBox(height: 8, child: CustomPaint(painter: MiniLinePainter(color: CyberTheme.cyan)))),
        ],
      ),
    );
  }

  Widget _buildSourceDistribution() {
    return _buildCardBase(
      title: 'SOURCE DISTRIBUTION',
      height: 200,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: DonutChartPainter(
                    data: [
                      {'val': 0.356, 'color': CyberTheme.cyan},
                      {'val': 0.228, 'color': Colors.pinkAccent},
                      {'val': 0.167, 'color': CyberTheme.red},
                      {'val': 0.102, 'color': CyberTheme.green},
                      {'val': 0.081, 'color': Colors.purpleAccent},
                      {'val': 0.043, 'color': Colors.pink},
                      {'val': 0.023, 'color': CyberTheme.textSec},
                    ],
                    strokeWidth: 16
                  ), 
                  size: const Size(80, 80)
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('247', style: TextStyle(color: CyberTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('Sources', style: TextStyle(color: CyberTheme.textSec, fontSize: 5)),
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
                _sourceLegendSmall(CyberTheme.cyan, 'X (Twitter)', '35.6%'),
                _sourceLegendSmall(Colors.pinkAccent, 'Instagram', '22.8%'),
                _sourceLegendSmall(CyberTheme.red, 'YouTube', '16.7%'),
                _sourceLegendSmall(CyberTheme.green, 'News Portal', '10.2%'),
                _sourceLegendSmall(Colors.purpleAccent, 'Telegram', '8.1%'),
                _sourceLegendSmall(Colors.pink, 'TikTok', '4.3%'),
                _sourceLegendSmall(CyberTheme.textSec, 'Lainnya', '2.3%'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _sourceLegendSmall(Color color, String label, String pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
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

  Widget _buildTrendAnalysis() {
    return _buildCardBase(
      title: 'TREND ANALYSIS',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Low', style: TextStyle(color: CyberTheme.textSec, fontSize: 6)),
          const SizedBox(width: 4),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), gradient: const LinearGradient(colors: [CyberTheme.darkBlue, CyberTheme.cyan, CyberTheme.green])),
          ),
          const SizedBox(width: 4),
          const Text('High', style: TextStyle(color: CyberTheme.textSec, fontSize: 6)),
        ],
      ),
      height: 180,
      child: Column(
        children: [
          Expanded(child: CustomPaint(painter: HeatmapPainter(), size: Size.infinite)),
        ],
      ),
    );
  }

  Widget _buildRisingTopics() {
    return _buildCardBase(
      title: 'RISING TOPICS',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.arrow_drop_up, color: CyberTheme.green, size: 12),
          Text('Rising', style: TextStyle(color: CyberTheme.green, fontSize: 7, fontWeight: FontWeight.bold)),
        ],
      ),
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _topicRow('1', 'Latihan Militer', '+320%'),
          _topicRow('2', 'Alutsista Baru', '+280%'),
          _topicRow('3', 'Keamanan Siber', '+210%'),
          _topicRow('4', 'Patroli Natuna', '+180%'),
          _topicRow('5', 'Teknologi Militer', '+150%'),
        ],
      ),
    );
  }

  Widget _topicRow(String num, String name, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 12, child: Text(num, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8))),
          Expanded(child: Text(name, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Icon(Icons.arrow_drop_up, color: CyberTheme.green, size: 10),
          Text(val, style: const TextStyle(color: CyberTheme.green, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 6, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7)),
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
          _navItem(Icons.dashboard, 'Dashboard', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
          }),
          _navItem(Icons.wifi_tethering, 'Feed', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FeedScreen()));
          }),
          _navItem(Icons.bar_chart, 'Analytics', isActive: true),
          _navItem(Icons.public, 'GeoIntel', onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GeoIntelScreen()));
          }),
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

class MiniLinePainter extends CustomPainter {
  final Color color;
  MiniLinePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0) return;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.0;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.5);
    path.lineTo(size.width * 0.4, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.1);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MultiLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final h = size.height - 12;
    final w = size.width;

    // Y Axis labels
    final yLabels = ['100%', '75%', '50%', '25%', '0%'];
    final gridPaint = Paint()..color = CyberTheme.border..strokeWidth = 1;
    for (int i = 0; i < yLabels.length; i++) {
      final y = h * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      final tp = TextPainter(text: TextSpan(text: yLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, y - 8));
    }

    // X Axis labels
    final xLabels = ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'];
    for (int i = 0; i < xLabels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      double x = (w - tp.width) * (i / 5);
      if (i == 0) x = 16;
      tp.paint(canvas, Offset(x, h + 4));
    }

    // Data Points
    final posPts = [0.2, 0.3, 0.1, 0.4, 0.2, 0.3, 0.15, 0.25, 0.1, 0.3, 0.2]; 
    final neuPts = [0.5, 0.6, 0.55, 0.7, 0.6, 0.5, 0.65, 0.55, 0.6, 0.5, 0.6]; 
    final negPts = [0.8, 0.9, 0.85, 0.8, 0.9, 0.85, 0.9, 0.8, 0.85, 0.9, 0.85]; 

    _drawLine(canvas, w, h, posPts, CyberTheme.green, drawTooltip: true, tooltipIndex: 7);
    _drawLine(canvas, w, h, neuPts, Colors.blueGrey);
    _drawLine(canvas, w, h, negPts, CyberTheme.red);
  }

  void _drawLine(Canvas canvas, double w, double h, List<double> pts, Color color, {bool drawTooltip = false, int tooltipIndex = 0}) {
    final path = Path();
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5;
    for (int i = 0; i < pts.length; i++) {
      final x = w * (i / (pts.length - 1));
      final y = h * pts[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = color);
      
      if (drawTooltip && i == tooltipIndex) {
        _drawTooltip(canvas, x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  void _drawTooltip(Canvas canvas, double x, double y) {
    canvas.drawLine(Offset(x, y), Offset(x, y + 40), Paint()..color = Colors.white24..strokeWidth = 1);
    final rect = Rect.fromLTWH(x + 5, y - 10, 60, 36);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.cardBg);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.border..style = PaintingStyle.stroke);
    
    final tp = TextPainter(
      text: const TextSpan(text: '12 Mei 15.00\n● Pos 68.2%\n● Neu 19.6%\n● Neg 12.2%', style: TextStyle(color: Colors.white, fontSize: 5, height: 1.2)), 
      textAlign: TextAlign.center, 
      textDirection: TextDirection.ltr
    )..layout();
    tp.paint(canvas, Offset(x + 8, y - 6));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double strokeWidth;

  DonutChartPainter({required this.data, this.strokeWidth = 12.0});

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
      startAngle += sweepAngle;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SingleLineChartPainter extends CustomPainter {
  final Color color;
  SingleLineChartPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final h = size.height - 12;
    final w = size.width;

    for (int i = 0; i < 5; i++) {
      final y = h * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(w, y), Paint()..color = CyberTheme.border..strokeWidth = 1);
    }
    
    final xLabels = ['7 Mei', '8 Mei', '9 Mei', '10 Mei', '11 Mei', '12 Mei', '13 Mei'];
    for (int i = 0; i < xLabels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      double x = (w - tp.width) * (i / (xLabels.length - 1));
      tp.paint(canvas, Offset(x, h + 4));
    }

    final pts = [0.8, 0.9, 0.6, 0.7, 0.4, 0.6, 0.3, 0.2, 0.4, 0.1, 0.2];
    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = w * (i / (pts.length - 1));
      final y = h * pts[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = color);
      
      if (i == 7) {
        canvas.drawLine(Offset(x, y), Offset(x, h), Paint()..color = Colors.white24..strokeWidth = 1);
        final rect = Rect.fromCenter(center: Offset(x, y - 15), width: 50, height: 20);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.background);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.border..style = PaintingStyle.stroke);
        
        final tp = TextPainter(
          text: const TextSpan(text: '12 Mei\n7.2M Engagements', style: TextStyle(color: Colors.white, fontSize: 5)), 
          textAlign: TextAlign.center, 
          textDirection: TextDirection.ltr
        )..layout();
        tp.paint(canvas, Offset(x - tp.width/2, y - 20));
      }
    }
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DoubleLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0) return;
    final h = size.height - 12;
    final w = size.width;

    for (int i = 0; i < 5; i++) {
      final y = h * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(w, y), Paint()..color = CyberTheme.border..strokeWidth = 1);
    }
    
    final xLabels = ['7 Mei', '8 Mei', '9 Mei', '10 Mei', '11 Mei', '12 Mei', '13 Mei'];
    for (int i = 0; i < xLabels.length; i++) {
      final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      double x = (w - tp.width) * (i / (xLabels.length - 1));
      tp.paint(canvas, Offset(x, h + 4));
    }

    final reachPts = [0.9, 0.7, 0.8, 0.6, 0.5, 0.7, 0.4, 0.3, 0.5, 0.2, 0.1];
    final mentionPts = [0.95, 0.9, 0.85, 0.9, 0.8, 0.85, 0.75, 0.7, 0.8, 0.7, 0.6];

    _drawLine(canvas, w, h, reachPts, CyberTheme.cyan, true, 8);
    _drawLine(canvas, w, h, mentionPts, CyberTheme.green, false, 0);
  }

  void _drawLine(Canvas canvas, double w, double h, List<double> pts, Color color, bool drawTooltip, int tIndex) {
    final path = Path();
    for (int i = 0; i < pts.length; i++) {
      final x = w * (i / (pts.length - 1));
      final y = h * pts[i];
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = color);
      
      if (drawTooltip && i == tIndex) {
        canvas.drawLine(Offset(x, y), Offset(x, h), Paint()..color = Colors.white24..strokeWidth = 1);
        final rect = Rect.fromCenter(center: Offset(x-15, y - 20), width: 50, height: 24);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.background);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), Paint()..color = CyberTheme.border..style = PaintingStyle.stroke);
        final tp = TextPainter(text: const TextSpan(text: '12 Mei\n● Reach 98.4M\n● Mentions 15.7M', style: TextStyle(color: Colors.white, fontSize: 5)), textDirection: TextDirection.ltr)..layout();
        tp.paint(canvas, Offset(x - 35, y - 28));
      }
    }
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rows = 6;
    final cols = 20;
    
    final cellH = size.height / rows;

    final labels = ['TNI', 'Pertahanan', 'Natuna', 'Militer', 'Alutsista', 'Keamanan'];
    
    for (int r = 0; r < rows; r++) {
      final tp = TextPainter(text: TextSpan(text: labels[r], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(0, r * cellH + (cellH - tp.height)/2));
    }

    final xLabels = ['14 Apr', '19 Apr', '24 Apr', '29 Apr', '4 Mei', '9 Mei', '13 Mei'];
    for (int i = 0; i < xLabels.length; i++) {
       final tp = TextPainter(text: TextSpan(text: xLabels[i], style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)), textDirection: TextDirection.ltr)..layout();
       double x = 40 + ((size.width - 40) * (i / (xLabels.length - 1)));
       if (x > size.width - tp.width) x = size.width - tp.width;
       tp.paint(canvas, Offset(x, size.height - 10));
    }

    final startX = 40.0;
    final actualW = size.width - startX;
    final gridCellW = actualW / cols;
    final gridCellH = (size.height - 15) / rows;

    final rnd = math.Random(42); 
    final baseColors = [CyberTheme.darkBlue, CyberTheme.cyan, CyberTheme.green];

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        double intensity = rnd.nextDouble() * 0.5 + (r/rows)*0.3 + (c/cols)*0.2;
        if (r == 4 && c > 10) intensity = 0.9; 
        
        Color cellColor;
        if (intensity < 0.4) cellColor = baseColors[0].withOpacity(0.5);
        else if (intensity < 0.7) cellColor = baseColors[1].withOpacity(0.8);
        else cellColor = baseColors[2];

        final rect = Rect.fromLTWH(startX + c * gridCellW + 1, r * gridCellH + 1, gridCellW - 2, gridCellH - 2);
        canvas.drawRect(rect, Paint()..color = cellColor);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}