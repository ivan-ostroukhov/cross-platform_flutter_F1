import 'package:go_router/go_router.dart';
import '../../features/driver/presentation/view/driver_list_screen.dart';
import '../../features/driver/presentation/view/driver_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/drivers',
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
);