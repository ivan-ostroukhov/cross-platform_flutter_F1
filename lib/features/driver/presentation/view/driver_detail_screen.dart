import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:f1_app/common/localization/generated/app_localizations.dart';
import 'package:f1_app/features/driver/domain/i_driver_repository.dart';
import '../bloc/detail/driver_detail_cubit.dart';
import '../bloc/detail/driver_detail_state.dart';

class DriverDetailScreen extends StatelessWidget {
  final String driverId;

  const DriverDetailScreen({super.key, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (ctx) => DriverDetailCubit(ctx.read<IDriverRepository>())..load(driverId),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
          title: Text(l10n.appTitle),
        ),
        body: BlocBuilder<DriverDetailCubit, DriverDetailState>
          (
          builder: (context, state) {
            return switch (state) {
              DriverDetailNotFound() => Center(child: Text(l10n.notFoundTitle)),
              DriverDetailLoading() => const Center(child: CircularProgressIndicator()),
              DriverDetailError() => Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.errorLoading),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                    onPressed: () => context.read<DriverDetailCubit>().load(driverId),
                  ),
                ],
              ),
              ),
              DriverDetailLoaded(:final driver) => LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              child: Text('#${driver.permanentNumber}', style: Theme.of(context).textTheme.headlineMedium),
                            ),
                            const SizedBox(height: 16),
                            Text(driver.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                            Text(driver.teamName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('${l10n.points}: ${driver.points}'),
                                    Text('${l10n.teammate}: ${driver.teammateId.toUpperCase()}'),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              icon: const Icon(Icons.arrow_forward),
                              label: Text(l10n.viewTeammate),
                              onPressed: () {
                                // context.push сохраняет текущий экран в стеке истории
                                context.push('/drivers/${driver.teammateId}');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            };
          },
        ),
      ),
    );
  }
}