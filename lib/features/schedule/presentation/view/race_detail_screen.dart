import 'package:flutter/material.dart';
import '../../../../common/utils/f1_colors.dart';
import '../../domain/models/race_detail_model.dart';
import '../../domain/models/race_model.dart';

class RaceDetailScreen extends StatelessWidget {
  final RaceModel race;

  const RaceDetailScreen({
    super.key,
    required this.race,
  });

  @override
  Widget build(BuildContext context) {
    final circuitColor = F1Colors.getCircuitColor(
      race.circuitId.isNotEmpty ? race.circuitId : race.raceName,
    );

    final detail = RaceDetailModel(
      raceName: race.raceName.isNotEmpty ? race.raceName : 'São Paulo GP',
      circuitName: race.circuitName.isNotEmpty
          ? race.circuitName
          : 'Autódromo José Carlos Pace',
      dateRange: race.dateRange.isNotEmpty ? race.dateRange : '06 - 08 Ноября',
      lengthKm: '4.309',
      laps: 71,
      corners: 15,
      maxSpeed: '338.3',
      elevation: '42.98',
      sessions: const [
        WeekendSession(
          day: '06',
          dayOfWeek: 'ПТ',
          title: 'Practice 1',
          timeRange: '21:30 - 22:30',
        ),
        WeekendSession(
          day: '07',
          dayOfWeek: 'СБ',
          title: 'Practice 2',
          timeRange: '01:00 - 02:00',
        ),
        WeekendSession(
          day: '07',
          dayOfWeek: 'СБ',
          title: 'Practice 3',
          timeRange: '20:30 - 21:30',
        ),
        WeekendSession(
          day: '08',
          dayOfWeek: 'ВС',
          title: 'Qualifying',
          timeRange: '00:00 - 01:00',
        ),
        WeekendSession(
          day: '08',
          dayOfWeek: 'ВС',
          title: 'Race',
          timeRange: '23:00 - 01:00',
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.85, -0.2),
                          radius: 1.1,
                          colors: [
                            circuitColor.withValues(alpha: 0.65),
                            circuitColor.withValues(alpha: 0.30),
                            circuitColor.withValues(alpha: 0.08),
                            Colors.black,
                          ],
                          stops: const [0.0, 0.45, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 50,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          detail.raceName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          detail.circuitName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: circuitColor.withValues(alpha: 0.95),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          detail.dateRange,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        detail.lengthKm,
                                        style: const TextStyle(
                                          fontSize: 34,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: -1,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'КМ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  _buildStatItem(
                                    icon: Icons.repeat_rounded,
                                    value: '${detail.laps}',
                                    label: 'Количество кругов',
                                  ),
                                  const SizedBox(height: 14),
                                  _buildStatItem(
                                    icon: Icons.alt_route_rounded,
                                    value: '${detail.corners}',
                                    label: 'Повороты',
                                  ),
                                  const SizedBox(height: 14),
                                  _buildStatItem(
                                    icon: Icons.speed_rounded,
                                    value: '${detail.maxSpeed} км/ч',
                                    label: 'Максимальная скорость',
                                  ),
                                  const SizedBox(height: 14),
                                  _buildStatItem(
                                    icon: Icons.height_rounded,
                                    value: '${detail.elevation} м',
                                    label: 'Перепад высот',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                height: 210,
                                child: Center(
                                  child: Icon(
                                    Icons.polyline_rounded,
                                    size: 190,
                                    color: circuitColor.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Выходные гонки',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final session = detail.sessions[index];
                  return _buildSessionTile(session);
                },
                childCount: detail.sessions.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 60),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildSessionTile(WeekendSession session) {
    return Column(
      children: [
        Divider(
          color: Colors.white.withValues(alpha: 0.08),
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.day,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      session.dayOfWeek,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      session.timeRange,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}