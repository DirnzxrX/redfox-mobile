import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../data/api_service.dart';
import 'analytics_screen.dart';
import 'auth/login_screen.dart';
import 'feed_screen.dart';
import 'geointel_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'threat_screen.dart';

class CyberTheme {
  static const Color background = Color(0xFF070A12);
  static const Color backgroundDeep = Color(0xFF03050B);
  static const Color panel = Color(0xFF111827);
  static const Color panelSoft = Color(0xFF192235);
  static const Color panelRaised = Color(0xFF202A40);
  static const Color surface = Color(0xFF121A2B);
  static const Color surfaceLow = Color(0xFF0C1321);
  static const Color line = Color(0xFF2A3449);
  static const Color shadow = Color(0xFF01030A);
  static const Color mint = Color(0xFF9EF7D0);
  static const Color blush = Color(0xFFFF9FB6);
  static const Color lavender = Color(0xFFC8B8FF);
  static const Color sky = Color(0xFF93E7FF);
  static const Color amber = Color(0xFFFFD6A5);
  static const Color highlight = Color(0xFFEFF6FF);
  static const Color textMain = Color(0xFFF6F8FF);
  static const Color textSec = Color(0xFFA7B0C5);
  static const Color textMuted = Color(0xFF697389);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  
  Map<String, dynamic> _dashboardData = {};
  Map<String, dynamic> _parametersData = {}; 
  Map<String, dynamic> _userData = {}; 
  
  // FIX: Menggunakan List<int> yang benar-benar cocok dengan api_service.dart
  List<int> _selectedProjectIds = []; 
  final GlobalKey _projectMenuKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  // Mengambil 3 API sekaligus: Dashboard KPI, Parameters, dan Current User
  Future<void> _fetchDashboardData() async {
    final results = await Future.wait([
      // FIX: Memanggil projectIds (jamak) sesuai dengan parameter di api_service.dart terbaru
      ApiService.getDashboardData(projectIds: _selectedProjectIds),
      ApiService.getDashboardParameters(),
      ApiService.getCurrentUser(),
    ]);

    final dashResult = results[0];
    final paramResult = results[1];
    final userResult = results[2];

    if (!mounted) return;

    if (dashResult['success'] == true && paramResult['success'] == true) {
      setState(() {
        _dashboardData = dashResult['data']['data'] ?? {};
        _parametersData = paramResult['data']['data'] ?? {};
        _userData = userResult['success'] == true ? (userResult['data']['data'] ?? {}) : {};
        
        // Auto-centang project yang statusnya true dari API jika masih kosong
        if (_selectedProjectIds.isEmpty && _parametersData['projects'] != null) {
          for (var p in _parametersData['projects']) {
            if (p['status'] == true) {
              _selectedProjectIds.add(p['id']);
            }
          }
        }
        
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      
      final errorMessage = dashResult['success'] == false ? dashResult['message'] : paramResult['message'];
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: CyberTheme.blush,
          content: Text(
            errorMessage.toString(),
            style: const TextStyle(color: CyberTheme.highlight),
          ),
        ),
      );

      if (dashResult['is_unauthorized'] == true || paramResult['is_unauthorized'] == true || userResult['is_unauthorized'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  String _formatNumber(num? value) {
    if (value == null) return '0';
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: CyberTheme.background,
      body: Stack(
        children: [
          const _DashboardBackdrop(),
          SafeArea(
            child: Column(
              children: [
                _buildTopAppBar(context),
                _buildSearchBar(),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: CyberTheme.lavender,
                            strokeWidth: 2,
                          ),
                        )
                      : SingleChildScrollView(
                          clipBehavior: Clip.none,
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 104),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTopStatsGrid(),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: _buildSentimentTimeline(),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 4,
                                    child: _buildSourceDistribution(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _buildMentionsOverTime()),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildAnomalyDetection()),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildMapSection(),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 188,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  children: [
                                    _buildInfoCardWide(
                                      'AI Intelligence Summary',
                                      _buildAiSummaryContent(),
                                    ),
                                    _buildInfoCard(
                                      'Threat Alert Center',
                                      _buildAlertCenterContent(),
                                      accent: CyberTheme.blush,
                                    ),
                                    _buildInfoCard(
                                      'Suspicious Activity',
                                      _buildSuspiciousContent(),
                                      accent: CyberTheme.amber,
                                    ),
                                    _buildInfoCard(
                                      'Bot Detection',
                                      _buildBotContent(),
                                      accent: CyberTheme.lavender,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 154,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  clipBehavior: Clip.none,
                                  children: [
                                    _buildInfoCard(
                                      'Trending Hashtags',
                                      _buildHashtagsContent(),
                                      accent: CyberTheme.sky,
                                    ),
                                    _buildInfoCard(
                                      'Top Authors',
                                      _buildTopAuthorsContent(),
                                      accent: CyberTheme.mint,
                                    ),
                                    _buildInfoCard(
                                      'Floating Keywords',
                                      _buildTrendingKeywords(),
                                      accent: CyberTheme.lavender,
                                    ),
                                    _buildInfoCard(
                                      'Viral Content',
                                      _buildViralContent(),
                                      accent: CyberTheme.amber,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildCyberBottomNav(),
    );
  }

  // =====================================================================
  // APP BAR DENGAN PROFIL TENGAH & MENU MULTI-SELECT PROJECT NATIVE
  // =====================================================================
  Widget _buildTopAppBar(BuildContext context) {
    // 1. Ambil Nama & Foto dari User yang login
    final String userFullName = _userData['fullname'] ?? 'Analyst';
    final String userRole = _userData['role']?['role_name'] ?? 'Guest';
    final String userAvatar = _userData['avatar'] ?? 'https://ui-avatars.com/api/?name=$userFullName&background=0D8ABC&color=fff';

    // 2. Tentukan Label Project Berdasarkan Jumlah Pilihan
    final projects = _parametersData['projects'] as List? ?? [];
    String projectName = 'All Projects';
    if (_selectedProjectIds.isNotEmpty) {
      if (_selectedProjectIds.length == 1) {
        final activeProject = projects.firstWhere((p) => p['id'] == _selectedProjectIds.first, orElse: () => null);
        projectName = activeProject != null ? activeProject['project_name'] : 'Unknown';
      } else {
        projectName = '${_selectedProjectIds.length} Projects Selected';
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Row(
        children: [
          const _BrandMark(),
          const SizedBox(width: 16),

          // TENGAH KIRI: Profile Menu 
          PopupMenuButton<String>(
            offset: const Offset(0, 46),
            color: CyberTheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            onSelected: (value) async {
              if (value == 'profile') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              }
              if (value == 'settings') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }
              if (value == 'logout') {
                await ApiService.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              }
            },
            itemBuilder: (context) => [
              _buildPopupMenuItem('My Profile', Icons.person_outline_rounded, 'profile'),
              _buildPopupMenuItem('Settings', Icons.tune_rounded, 'settings'),
              const PopupMenuDivider(height: 1),
              _buildPopupMenuItem('Logout', Icons.logout_rounded, 'logout', isDestructive: true),
            ],
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [CyberTheme.mint, CyberTheme.lavender],
                    ),
                    boxShadow: [
                      BoxShadow(color: CyberTheme.shadow, blurRadius: 18, offset: const Offset(0, 8)),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userAvatar), 
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userFullName, 
                      style: const TextStyle(
                        color: CyberTheme.textMain, 
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          userRole, 
                          style: const TextStyle(color: CyberTheme.textSec, fontSize: 9),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: CyberTheme.textSec, size: 14),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // KANAN: Project Selector (Multi-Select Menu Custom Native)
          InkWell(
            key: _projectMenuKey,
            onTap: _showProjectMultiSelect,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CyberTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CyberTheme.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Project',
                    style: TextStyle(color: CyberTheme.textMuted, fontSize: 8),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        projectName, 
                        style: const TextStyle(
                          color: CyberTheme.textMain,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: CyberTheme.textSec,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          const _IconBubble(icon: Icons.notifications_none_rounded),
        ],
      ),
    );
  }

  // =====================================================================
  // FUNGSI CUSTOM DROPDOWN MULTI-SELECT (Tidak Pakai Set Sementara)
  // =====================================================================
  void _showProjectMultiSelect() {
    final RenderBox renderBox = _projectMenuKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final projects = _parametersData['projects'] as List? ?? [];

    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Background transparan seperti menu biasa
      builder: (BuildContext dialogContext) {
        return Stack(
          children: [
            // Area luar untuk menutup modal
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(dialogContext);
                  setState(() { _isLoading = true; });
                  _fetchDashboardData();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(color: Colors.transparent),
              ),
            ),
            // Kotak Dropdown
            Positioned(
              top: offset.dy + size.height + 8,
              right: MediaQuery.of(context).size.width - offset.dx - size.width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 260,
                  decoration: BoxDecoration(
                    color: CyberTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CyberTheme.line),
                    boxShadow: const [
                      BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 6)),
                    ]
                  ),
                  child: StatefulBuilder(
                    builder: (context, setModalState) {
                      if (projects.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No projects available', style: TextStyle(color: CyberTheme.textMuted)),
                        );
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...projects.map((p) {
                            final id = p['id'] as int;
                            final isActive = _selectedProjectIds.contains(id);
                            
                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  if (isActive) {
                                    _selectedProjectIds.remove(id);
                                  } else {
                                    _selectedProjectIds.add(id);
                                  }
                                });
                                // Update tulisan judul di AppBar di layar utama
                                setState(() {}); 
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Icon(
                                      isActive ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                      color: isActive ? CyberTheme.mint : CyberTheme.textSec,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        p['project_name'].toString(),
                                        style: TextStyle(
                                          color: isActive ? CyberTheme.textMain : CyberTheme.textSec,
                                          fontSize: 11,
                                          fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          // Tombol Submit / Terapkan
                          InkWell(
                            onTap: () {
                              Navigator.pop(dialogContext);
                              setState(() { _isLoading = true; });
                              _fetchDashboardData();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: CyberTheme.line))
                              ),
                              child: const Text('Terapkan Filter', style: TextStyle(color: CyberTheme.mint, fontWeight: FontWeight.bold, fontSize: 12)),
                            )
                          )
                        ],
                      );
                    }
                  )
                )
              )
            )
          ]
        );
      }
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String title,
    IconData icon,
    String value, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? CyberTheme.blush : CyberTheme.textMain;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _FloatingPanel(
              radius: 22,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: const Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: CyberTheme.textSec,
                    size: 17,
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Search intelligence...',
                      style: TextStyle(color: CyberTheme.textSec, fontSize: 12),
                    ),
                  ),
                  Icon(
                    Icons.tune_rounded,
                    color: CyberTheme.lavender,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          const _FloatingPanel(
            radius: 22,
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: Row(
              children: [
                _SoftDot(color: CyberTheme.mint, size: 7),
                SizedBox(width: 7),
                Text(
                  'LIVE',
                  style: TextStyle(
                    color: CyberTheme.mint,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // DATA KPI BERDASARKAN API
  // =====================================================================
  Widget _buildTopStatsGrid() {
    final kpis = _dashboardData['kpis'] ?? {};
    final sentimentDist = kpis['sentiment_distribution'] ?? {};
    final num pos = sentimentDist['positive'] ?? 0;
    final num neu = sentimentDist['neutral'] ?? 0;
    final num neg = sentimentDist['negative'] ?? 0;
    final totalSent = pos + neu + neg;
    final posPercent = totalSent > 0 ? ((pos / totalSent) * 100).toStringAsFixed(1) : '0';
    final negPercent = totalSent > 0 ? ((neg / totalSent) * 100).toStringAsFixed(1) : '0';
    final trendingKeywords = _dashboardData['top_trending_keywords'] as List? ?? [];
    final threatScore = kpis['threat_score'];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.16,
      children: [
        _buildStatCard(
          'Total Mentions',
          _formatNumber(kpis['total_mentions']),
          'Momentum rising',
          CyberTheme.mint,
          Icons.trending_up_rounded,
        ),
        _buildStatCard(
          'Threat Score',
          threatScore is num ? threatScore.toStringAsFixed(1) : '0',
          kpis['anomaly_level']?.toString().toUpperCase() ?? 'LOW',
          CyberTheme.blush,
          Icons.warning_amber_rounded,
        ),
        _buildStatCard(
          'Positive Sentiment',
          '$posPercent%',
          'Soft signal',
          CyberTheme.mint,
          Icons.sentiment_satisfied_alt_rounded,
          compactWave: true,
        ),
        _buildStatCard(
          'Negative Sentiment',
          '$negPercent%',
          'Watchlist',
          CyberTheme.blush,
          Icons.sentiment_dissatisfied_rounded,
          compactWave: true,
        ),
        _buildStatCardIcon(
          'Net Sentiment',
          '${kpis['net_sentiment_score'] ?? '0'}',
          'Balanced index',
          CyberTheme.lavender,
          Icons.auto_graph_rounded,
        ),
        _buildStatCardIcon(
          'Trending Topics',
          '${trendingKeywords.length}',
          'Active clusters',
          CyberTheme.amber,
          Icons.local_fire_department_outlined,
        ),
        _buildStatCardIcon(
          'Engagement Reach',
          _formatNumber(kpis['total_engagement']),
          'Audience touch',
          CyberTheme.sky,
          Icons.people_alt_outlined,
        ),
        _buildStatCardIcon(
          'Potential Reach',
          _formatNumber(kpis['potential_reach']),
          'Projection',
          CyberTheme.mint,
          Icons.cell_tower_rounded,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color accent,
    IconData icon, {
    bool compactWave = false,
  }) {
    return _FloatingPanel(
      radius: 22,
      padding: const EdgeInsets.all(13),
      child: Stack(
        children: [
          Positioned.fill(
            top: compactWave ? 25 : 34,
            child: CustomPaint(
              painter: OrganicWavePainter(color: accent, compact: true),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(child: _SectionLabel(title)),
                  Icon(icon, color: accent, size: 17),
                ],
              ),
              Text(
                value,
                style: const TextStyle(
                  color: CyberTheme.textMain,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  _SoftDot(color: accent, size: 6),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TextStyle(color: accent, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardIcon(
    String title,
    String value,
    String subtitle,
    Color accent,
    IconData iconRight,
  ) {
    return _FloatingPanel(
      radius: 22,
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionLabel(title),
                Text(
                  value,
                  style: const TextStyle(
                    color: CyberTheme.textMain,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: accent, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _IconOrb(icon: iconRight, color: accent),
        ],
      ),
    );
  }

  Widget _buildSentimentTimeline() {
    return _ChartPanel(
      title: 'Sentiment Timeline',
      subtitle: 'Solid flowing waves',
      height: 190,
      accent: CyberTheme.mint,
      child: CustomPaint(
        painter: SentimentTimelinePainter(),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildSourceDistribution() {
    final kpis = _dashboardData['kpis'] ?? {};
    final List sources = kpis['social_share_of_voice'] ?? [];

    Color getColor(String platform) {
      final name = platform.toLowerCase();
      if (name == 'x') return CyberTheme.sky;
      if (name == 'tiktok') return CyberTheme.blush;
      if (name == 'instagram') return CyberTheme.lavender;
      if (name == 'threads') return CyberTheme.textMain;
      return CyberTheme.mint;
    }

    final chartData = <Map<String, dynamic>>[];
    for (final src in sources) {
      final percent = src['share_percent'];
      if (percent is! num) continue;
      chartData.add({
        'val': percent / 100.0,
        'color': getColor(src['platform'].toString()),
        'label': src['platform'].toString().toUpperCase(),
        'percent': percent,
      });
    }

    return _ChartPanel(
      title: 'Share Of Voice',
      subtitle: 'Solid 3D ring',
      height: 190,
      accent: CyberTheme.lavender,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: CustomPaint(
              painter: DynamicDonutPainter(data: chartData),
              size: const Size(96, 96),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chartData.map((e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    children: [
                      _SoftDot(color: e['color'] as Color, size: 7),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          e['label'].toString(),
                          style: const TextStyle(
                            color: CyberTheme.textSec,
                            fontSize: 9,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${e['percent']}%',
                        style: const TextStyle(
                          color: CyberTheme.textMain,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentionsOverTime() {
    return _ChartPanel(
      title: 'Mentions Over Time',
      subtitle: 'Flowing volume',
      height: 166,
      accent: CyberTheme.sky,
      child: CustomPaint(
        painter: OrganicWavePainter(color: CyberTheme.sky),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildAnomalyDetection() {
    return _ChartPanel(
      title: 'Anomaly Detection',
      subtitle: 'Soft risk plume',
      height: 166,
      accent: CyberTheme.blush,
      child: CustomPaint(
        painter: AnomalyAreaPainter(color: CyberTheme.blush),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildMapSection() {
    return _FloatingPanel(
      height: 232,
      radius: 24,
      padding: const EdgeInsets.all(14),
      child: Stack(
        children: [
          CustomPaint(painter: MapPainter(), size: Size.infinite),
          const Positioned(
            top: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Indonesia Intelligence Map',
                  style: TextStyle(
                    color: CyberTheme.textMain,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Raised topographic relief',
                  style: TextStyle(color: CyberTheme.textSec, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCardWide(String title, Widget content) {
    return _FloatingPanel(
      width: 286,
      margin: const EdgeInsets.only(right: 12),
      radius: 22,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelTitle(title, accent: CyberTheme.sky),
          const SizedBox(height: 10),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    Widget content, {
    Color accent = CyberTheme.lavender,
  }) {
    return _FloatingPanel(
      width: 206,
      margin: const EdgeInsets.only(right: 12),
      radius: 22,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelTitle(title, accent: accent),
          const SizedBox(height: 10),
          Expanded(child: content),
        ],
      ),
    );
  }

  Widget _buildAiSummaryContent() {
    return const Text(
      'Terdeteksi pola narasi terkait "stabilitas nasional" dan "konflik sosial". Engagement terbesar berasal dari X dan TikTok.',
      style: TextStyle(color: CyberTheme.textSec, fontSize: 11, height: 1.55),
    );
  }

  Widget _buildAlertCenterContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SignalRow(
          color: CyberTheme.blush,
          label: 'Volume spike detected',
          value: '100%',
        ),
        SizedBox(height: 8),
        _SignalRow(
          color: CyberTheme.amber,
          label: 'High anomaly level',
          value: 'Review',
        ),
      ],
    );
  }

  Widget _buildSuspiciousContent() {
    final kpis = _dashboardData['kpis'] ?? {};
    final signals = kpis['threat_signals'] ?? {};
    final negRatio = signals['negative_ratio'] ?? '3.04';

    return Text(
      'Negative ratio $negRatio. Narasi kritikal perlu dipantau secara berkelanjutan.',
      style: const TextStyle(color: CyberTheme.textSec, fontSize: 11, height: 1.45),
    );
  }

  Widget _buildBotContent() {
    return const Text(
      'Analyzing network clusters for automated behavior signatures.',
      style: TextStyle(color: CyberTheme.textSec, fontSize: 11, height: 1.45),
    );
  }

  Widget _buildHashtagsContent() {
    final hashtags = _dashboardData['top_trending_hashtags'] as List? ?? [];
    if (hashtags.isEmpty) return const _EmptyState();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: math.min(hashtags.length, 5),
      itemBuilder: (context, index) {
        final tag = hashtags[index];
        return _FloatingTextRow(
          label: tag['hashtag'].toString(),
          value: tag['total'].toString(),
          color: CyberTheme.sky,
        );
      },
    );
  }

  Widget _buildTopAuthorsContent() {
    final authors = _dashboardData['top_influential_authors'] as List? ?? [];
    if (authors.isEmpty) return const _EmptyState();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: math.min(authors.length, 5),
      itemBuilder: (context, index) {
        final author = authors[index];
        return _FloatingTextRow(
          label: '@${author['username']}',
          value: _formatNumber(author['followers']),
          color: CyberTheme.mint,
        );
      },
    );
  }

  Widget _buildTrendingKeywords() {
    final keywords = _dashboardData['top_trending_keywords'] as List? ?? [];
    if (keywords.isEmpty) return const _EmptyState();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: math.min(keywords.length, 5),
      itemBuilder: (context, index) {
        final kw = keywords[index];
        final size = 11.0 + (math.min(index, 3) * 1.1);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            kw['keyword'].toString(),
            style: TextStyle(
              color: index.isEven ? CyberTheme.lavender : CyberTheme.textMain,
              fontSize: size,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }

  Widget _buildViralContent() {
    return const Text(
      'Video from @officialinews reached 3.3M views with elevated resonance.',
      style: TextStyle(color: CyberTheme.textSec, fontSize: 11, height: 1.45),
    );
  }

  Widget _buildCyberBottomNav() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: _FloatingPanel(
          radius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.dashboard_outlined, 'Dashboard', isActive: true),
              _navItem(
                Icons.wifi_tethering_outlined,
                'Feed',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FeedScreen()),
                ),
              ),
              _navItem(
                Icons.bar_chart_rounded,
                'Analytics',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                ),
              ),
              _navItem(
                Icons.public_rounded,
                'GeoIntel',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const GeoIntelScreen()),
                ),
              ),
              _navItem(
                Icons.shield_outlined,
                'Threat',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ThreatScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final color = isActive ? CyberTheme.lavender : CyberTheme.textMuted;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardBackdrop extends StatelessWidget {
  const _DashboardBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.55, -0.85),
          radius: 1.25,
          colors: [
            Color(0xFF172235),
            CyberTheme.background,
            CyberTheme.backgroundDeep,
          ],
          stops: [0, 0.48, 1],
        ),
      ),
      child: CustomPaint(
        painter: _AtmosphericGridPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _FloatingPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double? width;
  final double? height;

  const _FloatingPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.radius = 20,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [CyberTheme.panelSoft, CyberTheme.panel],
        ),
        border: Border.all(color: CyberTheme.line),
        boxShadow: [
          const BoxShadow(
            color: CyberTheme.shadow,
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
          const BoxShadow(
            color: CyberTheme.surfaceLow,
            blurRadius: 14,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ChartPanel extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final Color accent;
  final Widget child;

  const _ChartPanel({
    required this.title,
    required this.subtitle,
    required this.height,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _FloatingPanel(
      height: height,
      radius: 24,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _PanelTitle(title, accent: accent)),
              _SoftDot(color: accent, size: 8),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(color: CyberTheme.textMuted, fontSize: 10),
          ),
          const SizedBox(height: 10),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AIRA',
          style: TextStyle(
            color: CyberTheme.textMain,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
        Text(
          'Advanced Intelligence',
          style: TextStyle(
            color: CyberTheme.textSec,
            fontSize: 9,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _PanelTitle extends StatelessWidget {
  final String title;
  final Color accent;

  const _PanelTitle(this.title, {required this.accent});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: accent,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: CyberTheme.textSec,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _IconBubble extends StatelessWidget {
  final IconData icon;

  const _IconBubble({required this.icon});

  @override
  Widget build(BuildContext context) {
    return _FloatingPanel(
      radius: 18,
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: CyberTheme.textSec, size: 18),
    );
  }
}

class _IconOrb extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconOrb({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, CyberTheme.panelRaised]),
        boxShadow: [const BoxShadow(color: CyberTheme.shadow, blurRadius: 18)],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _SoftDot extends StatelessWidget {
  final Color color;
  final double size;

  const _SoftDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: CyberTheme.shadow, blurRadius: size * 2.4),
        ],
      ),
    );
  }
}

class _SignalRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _SignalRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SoftDot(color: color, size: 7),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: CyberTheme.textSec, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FloatingTextRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _FloatingTextRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(color: CyberTheme.textSec, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'No data',
      style: TextStyle(color: CyberTheme.textMuted, fontSize: 11),
    );
  }
}

class _AtmosphericGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberTheme.surfaceLow
      ..strokeWidth = 1;
    for (double y = 34; y < size.height; y += 58) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 24; x < size.width; x += 64) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OrganicWavePainter extends CustomPainter {
  final Color color;
  final bool compact;

  OrganicWavePainter({required this.color, this.compact = false});

  @override
  void paint(Canvas canvas, Size size) {
    final heightFactor = compact ? 0.35 : 0.5;
    final baseline = size.height * (compact ? 0.62 : 0.58);
    final path = Path()..moveTo(0, baseline);

    for (double x = 0; x <= size.width; x += size.width / 7) {
      final nextX = x + size.width / 7;
      final controlX = x + size.width / 14;
      final wave =
          math.sin((x / size.width) * math.pi * 2.3) * size.height * 0.18;
      final y =
          baseline -
          (math.sin((nextX / size.width) * math.pi * 1.4) *
              size.height *
              heightFactor *
              0.38) -
          wave;
      path.quadraticBezierTo(
        controlX,
        baseline + wave * 0.5,
        nextX,
        y.clamp(0, size.height),
      );
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fill = Paint()
      ..shader = ui.Gradient.linear(const Offset(0, 0), Offset(0, size.height), [
        color,
        CyberTheme.surfaceLow,
      ]);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = compact ? 1.4 : 2.2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    final shine = Paint()
      ..color = CyberTheme.highlight
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = compact ? 0.6 : 1;

    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, stroke);
    canvas.drawPath(path.shift(const Offset(0, -2)), shine);
  }

  @override
  bool shouldRepaint(covariant OrganicWavePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.compact != compact;
  }
}

class SentimentTimelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [CyberTheme.mint, CyberTheme.lavender, CyberTheme.blush];
    for (var i = 0; i < colors.length; i++) {
      final path = Path();
      final baseline = size.height * (0.35 + i * 0.16);
      path.moveTo(0, baseline);
      for (double x = 0; x <= size.width; x += size.width / 6) {
        final nextX = x + size.width / 6;
        final controlX = x + size.width / 12;
        final y =
            baseline +
            math.sin((x / size.width * math.pi * 2) + i) * size.height * 0.18;
        path.quadraticBezierTo(
          controlX,
          baseline - size.height * 0.16,
          nextX,
          y,
        );
      }
      final stroke = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.6);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DynamicDonutPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  DynamicDonutPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) {
      final emptyPaint = Paint()
        ..color = CyberTheme.lavender
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(
        size.center(Offset.zero),
        math.min(size.width, size.height) * 0.3,
        emptyPaint,
      );
      return;
    }

    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) * 0.31;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final base = Paint()
      ..color = CyberTheme.panelRaised
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center.translate(0, 4), radius, base);

    double startAngle = -math.pi / 2;
    for (final d in data) {
      final sweepAngle = (d['val'] as double) * 2 * math.pi;
      final color = d['color'] as Color;
      final shadowPaint = Paint()
        ..color = CyberTheme.shadow
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      final paint = Paint()
        ..shader = ui.Gradient.sweep(
          center,
          [color, color, CyberTheme.highlight, color],
          [0, 0.45, 0.65, 1],
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect.shift(const Offset(0, 5)),
        startAngle,
        sweepAngle,
        false,
        shadowPaint,
      );
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    final core = Paint()
      ..shader = ui.Gradient.radial(center, radius * 0.78, [
        CyberTheme.panelRaised,
        CyberTheme.surfaceLow,
      ]);
    canvas.drawCircle(center, radius * 0.82, core);
  }

  @override
  bool shouldRepaint(covariant DynamicDonutPainter oldDelegate) => true;
}

class AnomalyAreaPainter extends CustomPainter {
  final Color color;

  AnomalyAreaPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.82)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.62,
        size.width * 0.38,
        size.height * 0.9,
        size.width * 0.56,
        size.height * 0.52,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.26,
        size.width * 0.73,
        size.height * 0.05,
        size.width * 0.82,
        size.height * 0.18,
      )
      ..cubicTo(
        size.width * 0.9,
        size.height * 0.32,
        size.width * 0.94,
        size.height * 0.58,
        size.width,
        size.height * 0.44,
      );
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = ui.Gradient.linear(Offset.zero, Offset(0, size.height), [
          color,
          CyberTheme.surfaceLow,
        ]),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.4),
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.18),
      7,
      Paint()..color = CyberTheme.panelRaised,
    );
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.18),
      3,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant AnomalyAreaPainter oldDelegate) =>
      oldDelegate.color != color;
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.58;
    final islandPaint = Paint()
      ..color = CyberTheme.panelRaised
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
    final crestPaint = Paint()
      ..color = CyberTheme.surface
      ..style = PaintingStyle.fill;
    final edgePaint = Paint()
      ..color = CyberTheme.sky
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final basePaint = Paint()
      ..color = CyberTheme.shadow
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final islands = [
      Rect.fromLTWH(size.width * 0.12, centerY - 18, size.width * 0.23, 22),
      Rect.fromLTWH(size.width * 0.36, centerY - 2, size.width * 0.2, 16),
      Rect.fromLTWH(size.width * 0.55, centerY - 31, size.width * 0.18, 23),
      Rect.fromLTWH(size.width * 0.69, centerY + 2, size.width * 0.18, 18),
      Rect.fromLTWH(size.width * 0.42, centerY + 30, size.width * 0.12, 13),
    ];

    for (final rect in islands) {
      final rrect = RRect.fromRectAndRadius(
        rect.translate(0, 8),
        const Radius.circular(16),
      );
      canvas.drawRRect(rrect, basePaint);
    }
    for (final rect in islands) {
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));
      canvas.drawRRect(rrect, islandPaint);
      canvas.drawRRect(rrect, edgePaint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.deflate(4).translate(0, -2),
          const Radius.circular(14),
        ),
        crestPaint,
      );
    }

    final scanPaint = Paint()
      ..color = CyberTheme.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, centerY + 9),
          width: size.width * (0.34 + i * 0.14),
          height: 24 + i * 16,
        ),
        scanPaint,
      );
    }

    _drawPulse(
      canvas,
      Offset(size.width * 0.24, centerY - 11),
      CyberTheme.mint,
      11,
    );
    _drawPulse(
      canvas,
      Offset(size.width * 0.51, centerY + 5),
      CyberTheme.blush,
      15,
    );
    _drawPulse(
      canvas,
      Offset(size.width * 0.74, centerY - 18),
      CyberTheme.lavender,
      10,
    );
  }

  void _drawPulse(Canvas canvas, Offset center, Color color, double radius) {
    canvas.drawCircle(
      center,
      radius * 1.9,
      Paint()
        ..color = CyberTheme.shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(center, radius, Paint()..color = CyberTheme.panelRaised);
    canvas.drawCircle(center, radius * 0.34, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}