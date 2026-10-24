import 'package:go_router/go_router.dart';
import 'package:f1_app/features/constructor/presentation/view/constructor_list_screen.dart';
import 'package:f1_app/features/driver/presentation/view/driver_detail_screen.dart';
import 'package:f1_app/features/driver/presentation/view/driver_list_screen.dart';
import 'package:f1_app/features/schedule/presentation/view/schedule_screen.dart';
import 'scaffold_with_nav_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/drivers',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Ветка 1: Гонщики
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/drivers',
              builder: (context, state) => const DriverListScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return DriverDetailScreen(driverId: id);
                  },
                ),
              ],
            ),
          ],
        ),

        // Ветка 2: Конструкторы
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/constructors',
              builder: (context, state) => const ConstructorListScreen(),
            ),
          ],
        ),

        // Ветка 3: Расписание
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/schedule',
              builder: (context, state) => const ScheduleScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);