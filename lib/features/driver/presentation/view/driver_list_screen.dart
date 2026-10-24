import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:f1_app/common/localization/generated/app_localizations.dart';

import '../../../../common/theme/theme_cubit.dart';
import '../../../../common/localization/locale_cubit.dart';
import '../bloc/list/driver_list_cubit.dart';
import '../bloc/list/driver_list_state.dart';

class DriverListScreen extends StatelessWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchPlaceholder,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              onChanged: (val) => context.read<DriverListCubit>().search(val),
            ),
          ),
          Expanded(
            child: BlocBuilder<DriverListCubit, DriverListState>(
              builder: (context, state) {
                return switch (state) {
                  DriverListLoading() => const Center(child: CircularProgressIndicator()),
                // ВОТ ЭТА ВЕТКА ДОБАВИЛАСЬ:
                  DriverListError() => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_off, size: 64, color: colorScheme.error),
                        const SizedBox(height: 12),
                        Text(l10n.errorLoading, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.retry),
                          onPressed: () => context.read<DriverListCubit>().loadDrivers(),
                        ),
                      ],
                    ),
                  ),
                  DriverListNotFound(:final query) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: colorScheme.error),
                        const SizedBox(height: 12),
                        Text(
                          l10n.notFoundTitle,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text('"$query": ${l10n.notFoundSubtitle}'),
                      ],
                    ),
                  ),
                  DriverListLoaded(:final drivers) => ListView.builder(
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final driver = drivers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primary,
                            child: Text(
                              '#${driver.permanentNumber}',
                              style: TextStyle(color: colorScheme.onPrimary),
                            ),
                          ),
                          title: Text(driver.name),
                          subtitle: Text(driver.teamName),
                          trailing: Text('${driver.points} ${l10n.points}'),
                          onTap: () => context.push('/drivers/${driver.id}'),
                        ),
                      );
                    },
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}