import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/localization/app_localizations.dart';
import 'common/navigation/app_router.dart';
import 'common/theme/app_theme.dart';
import 'common/theme/theme_cubit.dart';
import 'common/localization/locale_cubit.dart';
import 'features/driver/data/driver_repository.dart';
import 'features/driver/domain/i_driver_repository.dart';
import 'features/driver/presentation/bloc/list/driver_list_cubit.dart';

class F1App extends StatelessWidget {
  const F1App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IDriverRepository>(
      create: (_) => DriverRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => DriverListCubit(ctx.read<IDriverRepository>())..loadDrivers(),
          ),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => LocaleCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return BlocBuilder<LocaleCubit, Locale>(
              builder: (context, locale) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: appRouter,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  locale: locale,
                  localizationsDelegates: AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                );
              },
            );
          },
        ),
      ),
    );
  }
}