import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:f1_app/common/localization/generated/app_localizations.dart';
import 'package:f1_app/common/localization/locale_cubit.dart';
import 'package:f1_app/common/theme/theme_cubit.dart';
import '../../domain/schedule_repository.dart';
import '../bloc/schedule_cubit.dart';
import '../bloc/schedule_state.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      ScheduleCubit(context.read<IScheduleRepository>())..loadSchedule(),
      child: const _ScheduleView(),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  String _formatDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final hours = dt.hour.toString().padLeft(2, '0');
    final minutes = dt.minute.toString().padLeft(2, '0');
    return '$day.$month.$dt.year $hours:$minutes';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scheduleTab),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => context.read<LocaleCubit>().toggleLocale(),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
        ],
      ),
      body: BlocBuilder<ScheduleCubit, ScheduleState>(
        builder: (context, state) {
          return switch (state) {
            ScheduleLoading() =>
            const Center(child: CircularProgressIndicator()),
            ScheduleError() => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 64, color: colorScheme.error),
                  const SizedBox(height: 12),
                  Text(
                    l10n.errorLoading,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                    onPressed: () =>
                        context.read<ScheduleCubit>().loadSchedule(),
                  ),
                ],
              ),
            ),
            ScheduleLoaded(:final races) => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: races.length,
              itemBuilder: (context, index) {
                final race = races[index];
                final isPast = race.isPast;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: colorScheme.primaryContainer,
                          child: Text(
                            '${race.round}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                race.raceName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${race.circuitName} (${race.locality}, ${race.country})',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _formatDate(race.raceDateTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          padding: EdgeInsets.zero,
                          labelPadding:
                          const EdgeInsets.symmetric(horizontal: 8),
                          label: Text(
                            isPast ? l10n.raceCompleted : l10n.raceUpcoming,
                            style: TextStyle(
                              fontSize: 11,
                              color: isPast
                                  ? colorScheme.outline
                                  : colorScheme.primary,
                            ),
                          ),
                          backgroundColor: isPast
                              ? colorScheme.surfaceContainerHighest
                              : colorScheme.primaryContainer.withOpacity(0.4),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          };
        },
      ),
    );
  }
}