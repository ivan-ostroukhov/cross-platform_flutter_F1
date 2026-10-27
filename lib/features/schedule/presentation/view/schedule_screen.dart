import 'package:flutter/material.dart';
import 'package:f1_app/common/localization/generated/app_localizations.dart';
import '../../../../common/utils/f1_colors.dart';
import '../../domain/models/race_model.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final Key _currentRaceKey = const ValueKey('current_race_hero');
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPastRaces() {
    // Плавно скроллим вверх в сторону прошедших гонок (на высоту двух карточек)
    final targetOffset = _scrollController.offset < -20 ? 0.0 : -220.0;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const accentBlue = Color(0xFF15448C);

    final currentRace = RaceModel(
      round: '18',
      raceName: 'Гран-при США',
      circuitId: 'americas',
      locality: 'Austin',
      country: 'USA',
      date: DateTime.now().add(const Duration(hours: 8, minutes: 3)),
      dateRange: '23 - 26 Окт.',
      isCompleted: false,
    );

    final pastRaces = [
      RaceModel(
        round: '17',
        raceName: 'Гран-при Сингапура',
        circuitId: 'marina_bay',
        locality: 'Marina Bay',
        country: 'Singapore',
        dateRange: '',
        date: DateTime(2026, 9, 20),
        isCompleted: true,
        podium: const [
          PodiumDriver(code: 'VER', teamName: 'Red Bull'),
          PodiumDriver(code: 'LEC', teamName: 'Ferrari'),
          PodiumDriver(code: 'ANT', teamName: 'Mercedes'),
        ],
      ),
      RaceModel(
        round: '16',
        raceName: 'Гран-при Бахрейна',
        circuitId: 'bahrain',
        locality: 'Kuala Lumpur',
        country: 'Bahrain',
        dateRange: '',
        date: DateTime(2026, 9, 6),
        isCompleted: true,
        podium: const [
          PodiumDriver(code: 'VER', teamName: 'Red Bull'),
          PodiumDriver(code: 'ANT', teamName: 'Mercedes'),
          PodiumDriver(code: 'HAM', teamName: 'Ferrari'),
        ],
      ),
      RaceModel(
        round: '15',
        raceName: 'Гран-при Азербайджана',
        circuitId: 'baku',
        locality: 'Baku',
        country: 'Azerbaijan',
        dateRange: '',
        date: DateTime(2026, 8, 30),
        isCompleted: true,
        podium: const [
          PodiumDriver(code: 'RUS', teamName: 'Mercedes'),
          PodiumDriver(code: 'VER', teamName: 'Red Bull'),
          PodiumDriver(code: 'HAD', teamName: 'Red Bull'),
        ],
      ),
    ];

    final upcomingRaces = [
      RaceModel(
        round: '19',
        raceName: 'Гран-при Мехико',
        circuitId: 'rodriguez',
        locality: 'Mexico City',
        country: 'Mexico',
        dateRange: '02 Нояб.',
        date: DateTime(2026, 11, 2),
        isCompleted: false,
      ),
      RaceModel(
        round: '20',
        raceName: 'São Paulo GP',
        circuitId: 'interlagos',
        locality: 'São Paulo',
        country: 'Brazil',
        dateRange: '08 Нояб.',
        date: DateTime(2026, 11, 8),
        isCompleted: false,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        controller: _scrollController,
        center: _currentRaceKey,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // 1. ПРОШЕДШИЕ ГОНКИ (расположены выше стартовой точки)
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final race = pastRaces[index];
                return _buildPastRaceTile(race);
              },
              childCount: pastRaces.length,
            ),
          ),

          // 2. СТАРТОВАЯ ТОЧКА: Кнопка «Прошедшие гонки» + Карточка текущего этапа
          SliverToBoxAdapter(
            key: _currentRaceKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка перехода к прошедшим гонкам
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: _scrollToPastRaces,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.pastRaces,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white70,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Карточка текущей гонки
                SizedBox(
                  height: 310,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Градиент
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0.7, -0.5),
                              radius: 1.3,
                              stops: const [0.0, 0.45, 0.8, 1.0],
                              colors: [
                                accentBlue.withValues(alpha: 0.65),
                                accentBlue.withValues(alpha: 0.30),
                                accentBlue.withValues(alpha: 0.08),
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Изометрия трассы
                      Positioned(
                        right: 8,
                        top: 10,
                        width: 200,
                        height: 180,
                        child: Icon(
                          Icons.polyline_rounded,
                          size: 150,
                          color: Colors.blueAccent.withValues(alpha: 0.85),
                        ),
                      ),

                      // Текст текущей гонки
                      Positioned(
                        left: 16,
                        top: 16,
                        right: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Раунд ${currentRace.round}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.65),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentRace.raceName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentRace.locality,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentRace.dateRange,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Таймер
                      Positioned(
                        left: 16,
                        bottom: 20,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.raceCountdownPrefix,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    _buildCountdownItem('00', l10n.daysShort),
                                    const SizedBox(width: 14),
                                    _buildCountdownItem('08', l10n.hoursShort),
                                    const SizedBox(width: 14),
                                    _buildCountdownItem('03', l10n.minutesShort),
                                  ],
                                ),
                              ],
                            ),

                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withValues(alpha: 0.14),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.access_time, size: 16),
                              label: Text(l10n.scheduleButton, style: const TextStyle(fontSize: 13)),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),

                      // Нижнее растворение
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 24,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. ПРЕДСТОЯЩИЕ ГОНКИ (расположены ниже)
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final race = upcomingRaces[index];
                return _buildUpcomingRaceTile(race);
              },
              childCount: upcomingRaces.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
    );
  }

  static Widget _buildCountdownItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white38,
          ),
        ),
      ],
    );
  }

  static Widget _buildPastRaceTile(RaceModel race) {
    return Column(
      children: [
        Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: Icon(Icons.timeline, color: Colors.white.withValues(alpha: 0.7)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      race.raceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'R${race.round} • ${race.locality}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (race.podium != null)
                      Row(
                        children: race.podium!.map((driver) {
                          final teamColor = F1Colors.getTeamColor(driver.teamName);
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 14,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: teamColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  driver.code,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.35),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildUpcomingRaceTile(RaceModel race) {
    return Column(
      children: [
        Divider(color: Colors.white.withValues(alpha: 0.07), height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      race.dateRange.split(' ').first,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      race.dateRange.split(' ').length > 1 ? race.dateRange.split(' ').last : '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      race.raceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'R${race.round} • ${race.locality}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.timeline, color: Colors.white.withValues(alpha: 0.6)),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.35),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}