import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:f1_app/common/localization/generated/app_localizations.dart';
import '../../../../common/utils/f1_colors.dart';
import '../../../../common/utils/f1_media.dart';
import '../bloc/list/driver_list_cubit.dart';
import '../bloc/list/driver_list_state.dart';
import '../widgets/round_points_chart.dart';

class DriverDetailScreen extends StatelessWidget {
  final String driverId;

  const DriverDetailScreen({
    super.key,
    required this.driverId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;


    final listState = context.read<DriverListCubit>().state;
    dynamic currentDriver;

    if (listState is DriverListLoaded) {
      try {
        currentDriver = listState.drivers.firstWhere(
              (d) => d.id == driverId,
        );
      } catch (_) {
        currentDriver = listState.drivers.first;
      }
    }

    final fullName = currentDriver?.name as String? ?? 'Driver Name';
    final nameParts = fullName.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final teamName = currentDriver?.teamName as String? ?? 'Mercedes';
    final teamColor = F1Colors.getTeamColor(teamName);
    final points = currentDriver?.points?.toString() ?? '0';

    String positionNumber = '01';
    if (listState is DriverListLoaded && currentDriver != null) {
      final index = listState.drivers.indexOf(currentDriver);
      if (index >= 0) {
        positionNumber = (index + 1).toString().padLeft(2, '0');
      }
    }

    final imageUrl = F1Media.getDriverImageUrl(driverId);
    final isAntonelli = driverId.toLowerCase().contains('antonelli');

    final roundPoints = [
      25, 25, 25, 25, 25, 1, 1, 18, 1, 25, 25, 18, 25, 25, 15, 25, 18,
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.65, -0.6),
                        radius: 1.25,
                        stops: const [0.0, 0.45, 0.8, 1.0],
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
                  right: 0,
                  top: 40,
                  bottom: 0,
                  width: 400,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.65, 0.90, 1.0],
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.white24,
                          Colors.transparent,
                        ],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: isAntonelli
                        ? Image.asset(
                      'assets/images/antonnelii.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.topRight,
                    )
                        : CachedNetworkImage(
                      imageUrl: imageUrl,
                      httpHeaders: F1Media.defaultHeaders,
                      fit: BoxFit.contain,
                      alignment: Alignment.topRight,
                      placeholder: (_, __) => const SizedBox.shrink(),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.sports_motorsports_rounded,
                        size: 200,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 60,
                  child: IgnorePointer(
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
                ),

                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 26,
                          ),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          firstName,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          lastName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: teamColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.seasonPrefix('2026'),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.unfold_more,
                              size: 16,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        _buildBigStat(positionNumber, l10n.driverPositionShort),
                        const SizedBox(height: 10),
                        _buildBigStat(points, l10n.driverPointsShort),
                        const SizedBox(height: 16),

                        _buildIconStat(
                          Icons.emoji_events_outlined,
                          '08',
                          l10n.winsLabel,
                        ),
                        const SizedBox(height: 12),
                        _buildIconStat(
                          Icons.bar_chart,
                          '14',
                          l10n.podiumsLabel,
                        ),
                        const SizedBox(height: 12),
                        _buildIconStat(
                          Icons.adjust_outlined,
                          '07',
                          l10n.polesLabel,
                        ),
                        const SizedBox(height: 12),
                        _buildIconStat(
                          Icons.block,
                          '01',
                          l10n.dnfsLabel,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ------------------ ГРАФИК ОЧКОВ ------------------
            RoundPointsChart(
              roundPoints: roundPoints,
              accentColor: teamColor,
            ),

            const SizedBox(height: 20),
            Divider(
              color: Colors.white.withValues(alpha: 0.08),
              height: 1,
            ),

            // ------------------ КАРЬЕРНЫЕ ДАННЫЕ ------------------
            _buildDetailTile(
              leading: Text(
                driverId.length > 2 ? driverId.substring(0, 2).toUpperCase() : '00',
                style: TextStyle(
                  color: teamColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: driverId.length >= 3 ? driverId.substring(0, 3).toUpperCase() : driverId.toUpperCase(),
              subtitle: l10n.driverCodeLabel,
            ),

            _buildDetailTile(
              leading: Icon(
                Icons.sports_motorsports_outlined,
                color: Colors.white.withValues(alpha: 0.9),
                size: 26,
              ),
              title: teamName,
              subtitle: l10n.teamLabel,
            ),

            _buildDetailTile(
              leading: const Icon(
                Icons.flag_circle_outlined,
                color: Colors.white70,
                size: 26,
              ),
              title: '2025 Australian Grand Prix',
              subtitle: l10n.firstRaceLabel,
            ),

            _buildDetailTile(
              leading: const Icon(
                Icons.military_tech_outlined,
                color: Colors.white70,
                size: 26,
              ),
              title: '2026 Chinese Grand Prix',
              subtitle: l10n.firstWinLabel,
            ),

            _buildDetailTile(
              leading: const Icon(
                Icons.emoji_events_outlined,
                color: Colors.white70,
                size: 26,
              ),
              title: '0',
              subtitle: l10n.worldChampionshipsLabel,
            ),

            _buildDetailTile(
              leading: const Icon(
                Icons.calendar_today_outlined,
                color: Colors.white70,
                size: 24,
              ),
              title: '25.08.2006 (20)',
              subtitle: l10n.dateOfBirthLabel,
            ),

            _buildDetailTile(
              leading: const Icon(
                Icons.public,
                color: Colors.white70,
                size: 24,
              ),
              title: 'Italy',
              subtitle: l10n.countryLabel,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static Widget _buildBigStat(String value, String unit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static Widget _buildIconStat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _buildDetailTile({
    required Widget leading,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(width: 44, child: leading),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
      ],
    );
  }
}