import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:f1_app/features/home/presentation/view/home_screen.dart';
import 'package:f1_app/features/settings/presentation/view/settings_screen.dart';
import 'package:f1_app/features/constructor/presentation/view/constructor_detail_screen.dart';
import 'package:f1_app/features/constructor/presentation/view/constructor_list_screen.dart';
import 'package:f1_app/features/driver/presentation/view/driver_detail_screen.dart';
import 'package:f1_app/features/driver/presentation/view/driver_list_screen.dart';
import 'package:f1_app/features/schedule/presentation/view/schedule_screen.dart';
import 'package:f1_app/features/schedule/presentation/view/race_detail_screen.dart';
import 'package:f1_app/features/schedule/domain/models/race_model.dart';
import 'scaffold_with_nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => CupertinoPage(
        key: state.pageKey,
        child: const SettingsScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/drivers',
              builder: (context, state) => const DriverListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return CupertinoPage(
                      key: state.pageKey,
                      child: DriverDetailScreen(driverId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/constructors',
              builder: (context, state) => const ConstructorListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return CupertinoPage(
                      key: state.pageKey,
                      child: ConstructorDetailScreen(constructorId: id),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/schedule',
              builder: (context, state) => const ScheduleScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  pageBuilder: (context, state) {
                    final race = state.extra as RaceModel;
                    return CupertinoPage(
                      key: state.pageKey,
                      child: RaceDetailScreen(race: race),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);