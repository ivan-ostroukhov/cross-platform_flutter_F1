import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/utils/f1_colors.dart';
import '../../../driver/presentation/widgets/driver_hero_image.dart';
import '../../data/home_repository.dart';
import '../../domain/home_news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  Timer? _carouselTimer;
  int _activePage = 0;
  List<HomeNewsModel> _news = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
    _loadNews();
  }

  void _startAutoScroll() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (_pageController.hasClients) {
        final nextPage = (_activePage + 1) % 4;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  Future<void> _loadNews() async {
    final repo = HomeRepository();
    final newsList = await repo.getLatestNews();
    if (mounted) {
      setState(() {
        _news = newsList;
      });
    }
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _openNewsUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 360,
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (idx) {
                      setState(() {
                        _activePage = idx;
                      });
                    },
                    children: [
                      _buildDriverSlide(
                        driverId: 'verstappen',
                        bgText: 'max',
                        firstName: 'Max',
                        lastName: 'Verstappen',
                        teamName: 'Red Bull Racing',
                        pos: '04',
                        wins: '02',
                        pts: '236',
                        chartPoints: const [12, 18, 25, 15, 25, 18, 25, 12, 18, 25, 15, 25, 18],
                      ),
                      _buildDriverSlide(
                        driverId: 'piastri',
                        bgText: 'oscar',
                        firstName: 'Oscar',
                        lastName: 'Piastri',
                        teamName: 'McLaren',
                        pos: '07',
                        wins: '0',
                        pts: '144',
                        chartPoints: const [10, 12, 15, 18, 12, 25, 10, 15, 12, 15],
                      ),
                      _buildTeamSlide(
                        teamName: 'Red Bull Racing',
                        bgText: 'red bull',
                        pos: '03',
                        wins: '02',
                        pts: '355',
                      ),
                      _buildRaceSlide(
                        bgText: 'mexico',
                        locality: 'Mexico City',
                        dateRange: '31 Окт. - 02 Нояб.',
                        sessionTitle: 'Practice 1',
                        sessionDate: '31 СБ',
                        sessionTime: '00:30 - 01:30',
                      ),
                    ],
                  ),

                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (i) {
                        final isActive = i == _activePage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 24 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.white30,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 135,
                    height: 135,
                    child: CustomPaint(
                      size: const Size(135, 135),
                      painter: _GaugePainter(percent: 0.78),
                    ),
                  ),
                  const SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressStat('18/23', 'Гран-при завершено'),
                        const Divider(color: Colors.white12, height: 16),
                        _buildProgressStat('5483.0 КМ', 'Пройдено'),
                        const Divider(color: Colors.white12, height: 16),
                        _buildProgressStat('1 082', 'Пройдено кругов'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt, color: Colors.white, size: 22),
                      SizedBox(width: 6),
                      Text(
                        'Срочные новости',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _openNewsUrl('https://www.formula1.com/en/latest/all.html'),
                    child: const Text(
                      'Посмотреть все >',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _news.length,
                itemBuilder: (context, index) {
                  final news = _news[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GestureDetector(
                      onTap: () => _openNewsUrl(news.url),
                      child: Container(
                        width: 280,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: news.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  color: const Color(0xFF1C1C1E),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF2C2D35), Color(0xFF141518)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.newspaper_rounded,
                                      size: 48,
                                      color: Colors.white24,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.25),
                                      Colors.black.withValues(alpha: 0.88),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      news.title,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1.25,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.link,
                                              size: 14,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              news.source,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          news.timeAgo,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white38,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'R19 Гран-при Мехико',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildWhiteStagePill('71', 'Количество кругов', const Color(0xFFFFD600), Icons.repeat_rounded),
                  const SizedBox(height: 10),
                  _buildWhiteStagePill('356.9 км/ч', 'Максимальная скорость', const Color(0xFF00E676), Icons.speed_rounded),
                  const SizedBox(height: 10),
                  _buildWhiteStagePill('17', 'Количество поворотов', const Color(0xFF2979FF), Icons.alt_route_rounded),
                  const SizedBox(height: 10),
                  _buildWhiteStagePill('2.67 м', 'Перепад высот', const Color(0xFFFF3D00), Icons.height_rounded),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecordTile(
                    'Самая успешная команда-конструктор',
                    '04 ПОБЕДЫ',
                    'Red Bull',
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 28),
                  _buildRecordTile(
                    'Самые успешные пилоты',
                    '04 ПОБЕДЫ',
                    'Max Verstappen',
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 28),
                  _buildRecordTile(
                    'Рекорд круга гонки',
                    '1:14.774',
                    'Valtteri Bottas',
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 28),
                  _buildRecordTile(
                    'Самый быстрый пит-стоп сезона',
                    '1.80 с',
                    'McLaren (2023 Qatar GP)',
                  ),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 28),
                  _buildRecordTile(
                    'Самый быстрый круг сезона',
                    '1:11.890',
                    'Lando Norris',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverSlide({
    required String driverId,
    required String bgText,
    required String firstName,
    required String lastName,
    required String teamName,
    required String pos,
    required String wins,
    required String pts,
    required List<int> chartPoints,
  }) {
    final teamColor = F1Colors.getTeamColor(teamName);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.65, -0.6),
                radius: 1.25,
                colors: [
                  teamColor.withValues(alpha: 0.55),
                  teamColor.withValues(alpha: 0.28),
                  teamColor.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Positioned(
          left: -10,
          top: 10,
          child: Text(
            bgText,
            style: TextStyle(
              fontSize: 110,
              fontWeight: FontWeight.w900,
              color: teamColor.withValues(alpha: 0.15),
              height: 0.9,
            ),
          ),
        ),

        Positioned(
          right: -10,
          top: 10,
          bottom: 0,
          width: 230,
          child: DriverHeroImage(
            driverId: driverId,
            alignment: Alignment.topRight,
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 100,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.45, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 180,
                height: 32,
                child: _MiniPointsChart(
                  roundPoints: chartPoints,
                  accentColor: teamColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.bar_chart, size: 15, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  Text(
                    '$pos поз',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.stars, size: 15, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  Text(
                    '$wins Победы',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    pts,
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'блв',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamSlide({
    required String teamName,
    required String bgText,
    required String pos,
    required String wins,
    required String pts,
  }) {
    final teamColor = F1Colors.getTeamColor(teamName);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.65, -0.6),
                radius: 1.25,
                colors: [
                  teamColor.withValues(alpha: 0.55),
                  teamColor.withValues(alpha: 0.28),
                  teamColor.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Positioned(
          left: -10,
          top: 10,
          child: Text(
            bgText,
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w900,
              color: teamColor.withValues(alpha: 0.15),
              height: 0.9,
            ),
          ),
        ),

        Positioned(
          right: -10,
          top: 20,
          bottom: 0,
          width: 230,
          child: Image.asset(
            'assets/images/red_bull.png',
            fit: BoxFit.contain,
            alignment: Alignment.topRight,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.sports_motorsports,
              size: 130,
              color: Colors.white12,
            ),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 100,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.45, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart, size: 15, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  Text(
                    '$pos поз',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.stars, size: 15, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  Text(
                    '$wins Победы',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    pts,
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'блв',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRaceSlide({
    required String bgText,
    required String locality,
    required String dateRange,
    required String sessionTitle,
    required String sessionDate,
    required String sessionTime,
  }) {
    const circuitColor = Color(0xFF0E7A6B);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.65, -0.6),
                radius: 1.25,
                colors: [
                  circuitColor.withValues(alpha: 0.55),
                  circuitColor.withValues(alpha: 0.28),
                  circuitColor.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Positioned(
          left: -10,
          top: 10,
          child: Text(
            bgText,
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.w900,
              color: circuitColor.withValues(alpha: 0.2),
              height: 0.9,
            ),
          ),
        ),

        Positioned(
          right: -10,
          top: 20,
          width: 200,
          height: 180,
          child: Icon(
            Icons.polyline_rounded,
            size: 160,
            color: circuitColor.withValues(alpha: 0.9),
          ),
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 100,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.45, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                locality,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00E676),
                ),
              ),
              Text(
                dateRange,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                sessionTitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    sessionDate,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              Text(
                sessionTime,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildProgressStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static Widget _buildWhiteStagePill(
    String value,
    String label,
    Color btnColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: btnColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: Colors.black,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRecordTile(String category, String recordValue, String holder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          recordValue,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          holder,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MiniPointsChart extends StatelessWidget {
  final List<int> roundPoints;
  final Color accentColor;

  const _MiniPointsChart({
    required this.roundPoints,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    const maxScore = 25;
    const totalRounds = 18;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(totalRounds, (index) {
        final hasScore = index < roundPoints.length;
        final score = hasScore ? roundPoints[index] : 0;
        final barHeight = hasScore && score > 0
            ? ((score / maxScore) * 32).clamp(4.0, 32.0)
            : 3.0;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            height: barHeight,
            decoration: BoxDecoration(
              color: hasScore && score > 0
                  ? accentColor
                  : Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percent;

  _GaugePainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 2;

    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..strokeWidth = 1.0;

    const totalTicks = 72;
    for (int i = 0; i < totalTicks; i++) {
      final angle = i * (2 * math.pi / totalTicks);
      final pOuter = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      final pInner = Offset(
        center.dx + (outerRadius - 6) * math.cos(angle),
        center.dy + (outerRadius - 6) * math.sin(angle),
      );
      canvas.drawLine(pInner, pOuter, tickPaint);
    }

    final arcRadius = outerRadius - 16;
    const strokeWidth = 16.0;
    const startAngle = math.pi * 0.72;
    const totalSweep = math.pi * 1.56;

    final slatPaint = Paint()
      ..color = const Color(0xFF262830)
      ..strokeWidth = 1.8;

    const slatCount = 48;
    for (int i = 0; i < slatCount; i++) {
      final slatProgress = i / slatCount;
      if (slatProgress > percent) {
        final angle = startAngle + (totalSweep * slatProgress);
        final innerR = arcRadius - (strokeWidth / 2) + 2;
        final outerR = arcRadius + (strokeWidth / 2) - 2;
        final p1 = Offset(
          center.dx + innerR * math.cos(angle),
          center.dy + innerR * math.sin(angle),
        );
        final p2 = Offset(
          center.dx + outerR * math.cos(angle),
          center.dy + outerR * math.sin(angle),
        );
        canvas.drawLine(p1, p2, slatPaint);
      }
    }

    final activeSweep = totalSweep * percent;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + activeSweep,
        colors: const [
          Color(0xFF2C4AE2),
          Color(0xFF00C2FF),
          Color(0xFF8CE055),
          Color(0xFFFFD600),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: arcRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: arcRadius),
      startAngle,
      activeSweep,
      false,
      progressPaint,
    );

    final blackGapRadius = arcRadius - (strokeWidth / 2);
    final blackGapPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(center, blackGapRadius, blackGapPaint);

    final innerCircleRadius = blackGapRadius - 2;
    final centerCirclePaint = Paint()
      ..color = const Color(0xFF3253E8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerCircleRadius, centerCirclePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${(percent * 100).round()}',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const TextSpan(
            text: '%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.percent != percent;
}