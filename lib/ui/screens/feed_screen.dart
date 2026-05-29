import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;

import 'profile_screen.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';
import 'analytics_screen.dart'; 
import 'geointel_screen.dart';
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

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 1. TOP STATS (Diubah jadi 2 Baris agar tidak overflow di HP) ---
                    Row(
                      children: [
                        Expanded(child: _buildTopStatCard('TOTAL MENTIONS', '15.765.388', '+134%', CyberTheme.green, 'vs yesterday')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTopStatCardIcon('ACTIVE SOURCES', '247', '+12%', CyberTheme.green, Icons.cell_tower, CyberTheme.cyan)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildTopStatCardLine('ENGAGEMENT', '98.4M', '+134%', CyberTheme.green)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTopStatCardIcon('ALERT COUNT', '32', '+18%', CyberTheme.green, Icons.warning_amber_rounded, CyberTheme.red)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // --- 2. FILTER TABS (SCROLLABLE) ---
                    SizedBox(
                      height: 28,
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildFilterTab('ALL FEED', isActive: true),
                            _buildFilterTab('X (TWITTER)', icon: Icons.close), 
                            _buildFilterTab('INSTAGRAM', icon: Icons.camera_alt_outlined),
                            _buildFilterTab('YOUTUBE', icon: Icons.play_circle_outline),
                            _buildFilterTab('TELEGRAM', icon: Icons.send_outlined),
                            _buildFilterTab('NEWS', icon: Icons.article_outlined),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- 3. MAIN CONTENT (2 KOLOM: KIRI FEED, KANAN SIDEBAR) ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // KOLOM KIRI: REALTIME FEED (Lebih Lebar)
                        Expanded(
                          flex: 13,
                          child: Container(
                            decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(width: 6, height: 6, decoration: const BoxDecoration(color: CyberTheme.green, shape: BoxShape.circle)),
                                          const SizedBox(width: 6),
                                          const Expanded(child: Text('REALTIME INTELLIGENCE FEED', style: TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5), overflow: TextOverflow.ellipsis)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(4)),
                                      child: const Row(children: [Text('Newest First', style: TextStyle(color: CyberTheme.textSec, fontSize: 7)), Icon(Icons.arrow_drop_down, color: CyberTheme.textSec, size: 10)]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                
                                // DAFTAR FEED
                                _buildFeedItem(
                                  platform: 'X', platformColor: Colors.white,
                                  avatarUrl: 'https://i.pravatar.cc/100?img=12', 
                                  username: '@defenseupdatess', time: '2m ago', location: 'Jakarta, Indonesia',
                                  sentiment: 'Positive', sentimentColor: CyberTheme.green,
                                  threat: 'Medium', threatColor: CyberTheme.warning,
                                  content: 'Peningkatan aktivitas pesawat militer di wilayah Natuna terpantau sejak dini hari.',
                                  tags: '#Natuna #TNI #Militer #Pertahanan',
                                  views: '12.4K', retweets: '1.2K', likes: '3.7K', comments: '420', mentions: '56'
                                ),
                                const Divider(color: CyberTheme.border, height: 20),

                                _buildFeedItem(
                                  platform: 'Ig', platformColor: Colors.pinkAccent,
                                  avatarUrl: 'https://i.pravatar.cc/100?img=13', 
                                  username: '@indonesia.update', time: '5m ago', location: 'Surabaya, Indonesia',
                                  sentiment: 'Negative', sentimentColor: CyberTheme.red,
                                  threat: 'High', threatColor: CyberTheme.red,
                                  content: 'Kondisi terkini di Surabaya setelah hujan deras mengakibatkan beberapa titik banjir.',
                                  tags: '#Surabaya #Banjir #CuacaEkstrem',
                                  views: '8.9K', retweets: '2.1K', likes: '312', comments: '87', mentions: '34'
                                ),
                                const Divider(color: CyberTheme.border, height: 20),

                                _buildFeedItem(
                                  platform: 'Yt', platformColor: CyberTheme.red,
                                  avatarUrl: 'https://i.pravatar.cc/100?img=14', 
                                  username: 'CNN Indonesia', time: '8m ago', location: 'Jakarta, Indonesia',
                                  sentiment: 'Positive', sentimentColor: CyberTheme.green,
                                  threat: 'Medium', threatColor: CyberTheme.warning,
                                  content: 'BREAKING NEWS: Pemerintah umumkan kebijakan baru terkait pertahanan siber nasional.',
                                  tags: '#CyberSecurity #Pemerintah #BreakingNews',
                                  views: '45.7K', retweets: '5.3K', likes: '1.1K', comments: '623', mentions: '128'
                                ),
                                const Divider(color: CyberTheme.border, height: 20),
                                
                                _buildFeedItem(
                                  platform: 'Tg', platformColor: CyberTheme.cyan,
                                  avatarUrl: 'https://i.pravatar.cc/100?img=15', 
                                  username: 'Intel_Reporter', time: '12m ago', location: 'Batam, Indonesia',
                                  sentiment: 'Negative', sentimentColor: CyberTheme.red,
                                  threat: 'High', threatColor: CyberTheme.red,
                                  content: 'Informasi intelijen: Terjadi peningkatan aktivitas kapal asing di perairan sekitar Batam.',
                                  tags: '#Intel #Batam #Maritime #Security',
                                  views: '6.2K', retweets: '942', likes: '215', comments: '54', mentions: '27'
                                ),
                                const Divider(color: CyberTheme.border, height: 20),

                                _buildFeedItem(
                                  platform: 'Nw', platformColor: Colors.blueAccent,
                                  avatarUrl: 'https://i.pravatar.cc/100?img=16', 
                                  username: 'Kompas.com', time: '15m ago', location: 'Bandung, Indonesia',
                                  sentiment: 'Neutral', sentimentColor: CyberTheme.textSec,
                                  threat: 'Medium', threatColor: CyberTheme.warning,
                                  content: 'BMKG: Masyarakat diimbau waspada terhadap potensi cuaca ekstrem dalam 3 hari ke depan.',
                                  tags: '#BMKG #Cuaca #Waspada',
                                  views: '9.1K', retweets: '1.3K', likes: '256', comments: '78', mentions: '42'
                                ),
                                
                                const SizedBox(height: 12),
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(border: Border.all(color: CyberTheme.border), borderRadius: BorderRadius.circular(16)),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Load More', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                                        Icon(Icons.keyboard_arrow_down, color: CyberTheme.textSec, size: 12),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 8),

                        // KOLOM KANAN: SIDEBAR (Agak Sempit)
                        Expanded(
                          flex: 9,
                          child: Column(
                            children: [
                              // POPULAR MENTIONS
                              _buildSidebarCard('POPULAR MENTIONS', _buildPopularMentions(), showLive: true),
                              const SizedBox(height: 8),
                              
                              // TRENDING HASHTAGS
                              _buildSidebarCard('TRENDING HASHTAGS', _buildSidebarHashtags(), showLive: true),
                              const SizedBox(height: 8),

                              // VIRAL MONITORING
                              _buildSidebarCard('VIRAL MONITORING', _buildViralMonitoring(), showLive: true),
                              const SizedBox(height: 8),

                              // MENTION ENGAGEMENT
                              _buildSidebarCard('MENTION ENGAGEMENT', _buildEngagementDonut(), showLive: true),
                            ],
                          ),
                        )
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
  // WIDGET BUILDERS: TOP AREA (Disamakan dengan Dashboard)
  // ===========================================================================

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          // Logo AIRA
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AIRA', style: TextStyle(color: CyberTheme.cyan, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('Advanced Intelligence\nRecon & Analytics', style: TextStyle(color: CyberTheme.textSec, fontSize: 6, height: 1.2)),
            ],
          ),
          const SizedBox(width: 16),
          // Profile Menu
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Project', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
              Row(
                children: const [
                  Text('TNI AU Monitoring', style: TextStyle(color: CyberTheme.textMain, fontSize: 10, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: CyberTheme.textSec, size: 12),
                ],
              )
            ],
          ),
          const SizedBox(width: 12),
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

  // ===========================================================================
  // WIDGET BUILDERS: TOP STATS & TABS
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
          Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.arrow_drop_up, color: pColor, size: 10),
              Text(percent, style: TextStyle(color: pColor, fontSize: 7, fontWeight: FontWeight.bold)),
              const SizedBox(width: 2),
              Expanded(child: Text(subtitle, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6), overflow: TextOverflow.ellipsis)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopStatCardIcon(String title, String value, String percent, Color pColor, IconData icon, Color iconColor) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    Row(
                      children: [
                        Icon(Icons.arrow_drop_up, color: pColor, size: 10),
                        Text(percent, style: TextStyle(color: pColor, fontSize: 7, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
              Icon(icon, color: iconColor, size: 18),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopStatCardLine(String title, String value, String percent, Color pColor) {
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
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: CyberTheme.textMain, fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          Row(
            children: [
              Icon(Icons.arrow_drop_up, color: pColor, size: 10),
              Text(percent, style: TextStyle(color: pColor, fontSize: 7, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Expanded(child: SizedBox(height: 10, child: CustomPaint(painter: MiniSparklinePainter(color: CyberTheme.cyan)))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, {bool isActive = false, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isActive ? CyberTheme.cyan.withOpacity(0.1) : CyberTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isActive ? CyberTheme.cyan : CyberTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, color: isActive ? CyberTheme.cyan : CyberTheme.textSec, size: 10), const SizedBox(width: 4)],
          Text(label, style: TextStyle(color: isActive ? CyberTheme.cyan : CyberTheme.textSec, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGET BUILDERS: FEED (LEFT)
  // ===========================================================================

  Widget _buildFeedItem({
    required String platform, required Color platformColor, required String avatarUrl, 
    required String username, required String time, required String location,
    required String sentiment, required Color sentimentColor,
    required String threat, required Color threatColor,
    required String content, required String tags,
    required String views, required String retweets, required String likes, required String comments, required String mentions,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Platform Text (menggantikan Icon jika icon tak ada)
        SizedBox(
          width: 16,
          child: Text(platform, style: TextStyle(color: platformColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        // Content Area
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row (Username, time, location, badges)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 10, backgroundImage: NetworkImage(avatarUrl)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(username, style: const TextStyle(color: CyberTheme.textMain, fontSize: 9, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.check_circle, color: CyberTheme.cyan, size: 8),
                                  const SizedBox(width: 6),
                                  Text(time, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7)),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: CyberTheme.textSec, size: 8),
                                  const SizedBox(width: 2),
                                  Expanded(child: Text(location, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7), overflow: TextOverflow.ellipsis)),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Badges
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBadge(sentiment, sentimentColor),
                      const SizedBox(height: 4),
                      _buildBadge(threat, threatColor, icon: Icons.shield),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 8),
              
              // Text Content
              Text(content, style: const TextStyle(color: CyberTheme.textMain, fontSize: 9, height: 1.4)),
              const SizedBox(height: 4),
              Text(tags, style: const TextStyle(color: CyberTheme.cyan, fontSize: 8)),
              const SizedBox(height: 10),

              // Interaction Row (PERBAIKAN: Gunakan Wrap agar tidak right overflow di layar sempit)
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _interactionIcon(Icons.visibility_outlined, views),
                  _interactionIcon(Icons.repeat, retweets),
                  _interactionIcon(Icons.favorite_border, likes),
                  _interactionIcon(Icons.chat_bubble_outline, comments),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Mentions ', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
                      Text(mentions, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              )
            ],
          )
        )
      ],
    );
  }

  Widget _buildBadge(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, color: color, size: 8), const SizedBox(width: 2)],
          if (icon == null) ...[Icon(Icons.circle, color: color, size: 6), const SizedBox(width: 2)],
          Text(text, style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _interactionIcon(IconData icon, String val) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: CyberTheme.textSec, size: 10),
        const SizedBox(width: 4),
        Text(val, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
      ],
    );
  }

  // ===========================================================================
  // WIDGET BUILDERS: SIDEBAR (RIGHT)
  // ===========================================================================

  Widget _buildSidebarCard(String title, Widget content, {bool showLive = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: CyberTheme.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: CyberTheme.border)),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5), overflow: TextOverflow.ellipsis)),
              if (showLive) Row(
                children: [
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: CyberTheme.green, shape: BoxShape.circle)),
                  const SizedBox(width: 2),
                  const Text('LIVE', style: TextStyle(color: CyberTheme.green, fontSize: 6, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Widget _buildPopularMentions() {
    return Column(
      children: [
        _popularRow('1', 'https://i.pravatar.cc/100?img=21', '@defenseupdatess', '12.4K'),
        _popularRow('2', 'https://i.pravatar.cc/100?img=22', '@indonesia.update', '8.9K'),
        _popularRow('3', 'https://i.pravatar.cc/100?img=23', 'CNN Indonesia', '7.3K'),
        _popularRow('4', 'https://i.pravatar.cc/100?img=24', '@Intel_Reporter', '6.2K'),
        _popularRow('5', 'https://i.pravatar.cc/100?img=25', 'Kompas.com', '5.1K'),
      ],
    );
  }

  Widget _popularRow(String num, String img, String name, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(num, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
          const SizedBox(width: 6),
          CircleAvatar(radius: 8, backgroundImage: NetworkImage(img)),
          const SizedBox(width: 6),
          Expanded(child: Text(name, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSidebarHashtags() {
    return Column(
      children: [
        _hashtagSparkRow('#TNI', '12.5K'),
        _hashtagSparkRow('#Natuna', '8.2K'),
        _hashtagSparkRow('#Pertahanan', '6.8K'),
        _hashtagSparkRow('#CyberSecurity', '5.4K'),
        _hashtagSparkRow('#Indonesia', '4.3K'),
        _hashtagSparkRow('#Militer', '3.9K'),
      ],
    );
  }

  Widget _hashtagSparkRow(String tag, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(tag, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 1, child: SizedBox(height: 8, child: CustomPaint(painter: MiniSparklinePainter(color: CyberTheme.green)))),
          const SizedBox(width: 6),
          Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildViralMonitoring() {
    return Column(
      children: [
        _viralVideoRow('1', 'Detik-detik pesawat militer terbang di wilayah perbatasan...', '02:45', '128.5K', 'High', CyberTheme.red),
        _viralVideoRow('2', 'Banjir besar rendam beberapa wilayah Surabaya...', '01:32', '98.2K', 'High', CyberTheme.red),
        _viralVideoRow('3', 'Warga rekam suara ledakan di perairan...', '00:58', '76.3K', 'Medium', CyberTheme.warning),
      ],
    );
  }

  Widget _viralVideoRow(String num, String title, String dur, String views, String threat, Color tColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(num, style: const TextStyle(color: CyberTheme.textSec, fontSize: 8)),
          const SizedBox(width: 6),
          // Thumbnail mock
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40, height: 24,
                decoration: BoxDecoration(color: CyberTheme.border, borderRadius: BorderRadius.circular(4)),
              ),
              const Icon(Icons.play_circle_fill, color: Colors.white70, size: 14),
              Positioned(
                bottom: 2, right: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(2)),
                  child: Text(dur, style: const TextStyle(color: Colors.white, fontSize: 4)),
                ),
              )
            ],
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                // PERBAIKAN: Gunakan Wrap atau atur flex dengan baik
                Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Icon(Icons.visibility, color: CyberTheme.cyan, size: 8),
                    Text(views, style: const TextStyle(color: CyberTheme.textMain, fontSize: 7, fontWeight: FontWeight.bold)),
                    _buildBadge(threat, tColor),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEngagementDonut() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50, height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(painter: EngageDonutPainter(), size: const Size(50, 50)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('98.4M', style: TextStyle(color: CyberTheme.textMain, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text('Total', style: TextStyle(color: CyberTheme.textSec, fontSize: 4)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  _engageLegend(CyberTheme.cyan, 'Likes', '45.2M', '(46.0%)'),
                  _engageLegend(CyberTheme.green, 'Retweets', '28.7M', '(29.2%)'),
                  _engageLegend(CyberTheme.warning, 'Comments', '16.8M', '(17.1%)'),
                  _engageLegend(Colors.purpleAccent, 'Shares', '7.7M', '(7.7%)'),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        const Row(
          children: [
            Icon(Icons.arrow_drop_up, color: CyberTheme.green, size: 12),
            Text('134%', style: TextStyle(color: CyberTheme.green, fontSize: 8, fontWeight: FontWeight.bold)),
            SizedBox(width: 4),
            Text('vs yesterday', style: TextStyle(color: CyberTheme.textSec, fontSize: 8)),
          ],
        )
      ],
    );
  }

  Widget _engageLegend(Color color, String label, String val, String pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 4),
          const SizedBox(width: 4),
          Expanded(child: Text(label, style: const TextStyle(color: CyberTheme.textSec, fontSize: 7), overflow: TextOverflow.ellipsis)),
          Text(val, style: const TextStyle(color: CyberTheme.textMain, fontSize: 7, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text(pct, style: const TextStyle(color: CyberTheme.textSec, fontSize: 6)),
        ],
      ),
    );
  }

  // --- BOTTOM NAV (Disamakan dengan Dashboard) ---
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
            Navigator.pushReplacement(
    context, 
    MaterialPageRoute(builder: (_) => const DashboardScreen()) // Pastikan nama class Dashboard Anda sesuai
  ); // Kembali ke Dashboard
          }),
          
          _navItem(Icons.wifi_tethering, 'Feed', isActive: true),
          
          // PERBAIKAN: Menambahkan onTap menuju AnalyticsScreen
          _navItem(Icons.bar_chart, 'Analytics', onTap: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => const AnalyticsScreen())
            );
          }),
          
          // <-- Tambahkan onTap menuju GeoIntelScreen
          _navItem(Icons.public, 'GeoIntel', onTap: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => const GeoIntelScreen())
            );
          }),
          
          // <-- 2. Update tombol Threat
          _navItem(Icons.shield_outlined, 'Threat', onTap: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => const ThreatScreen())
            );
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

class EngageDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = 6.0;

    final data = [
      {'val': 0.46, 'color': CyberTheme.cyan},
      {'val': 0.29, 'color': CyberTheme.green},
      {'val': 0.17, 'color': CyberTheme.warning},
      {'val': 0.08, 'color': Colors.purpleAccent},
    ];

    double startAngle = -math.pi / 2;
    for (var d in data) {
      final sweepAngle = (d['val'] as double) * 2 * math.pi;
      final paint = Paint()
        ..color = d['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      
      canvas.drawArc(rect, startAngle, sweepAngle - 0.1, false, paint);
      startAngle += sweepAngle;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}