import 'package:admin_curator/Presentation/About/about.dart';
import 'package:admin_curator/Presentation/Auth/Login/auth_signin.dart';
import 'package:admin_curator/Presentation/CuratorProfiles/curator_profiles.dart';
import 'package:admin_curator/Presentation/Dashboard/dashboard_screen.dart';
import 'package:admin_curator/Presentation/LoadingScreen/loading_screen.dart';
import 'package:admin_curator/Presentation/MainLayout/main_layout.dart';
import 'package:admin_curator/Presentation/TasksScreen/tasks_screen.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/loading',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const AuthSignIn()),
      ShellRoute(
        builder: (context, state, child) {
          final currentLocation = state.uri.path;
          return MainLayout(currentRoute: currentLocation, child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/curatorProfiles',
            builder: (context, state) => const CuratorProfiles(),
          ),
          GoRoute(
            path: '/about',
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading) return null;
      if (authState.user == null) {
        return '/login';
      }
      if (authState.user != null &&
          (state.uri.path == '/login' || state.uri.path == '/loading')) {
        return '/dashboard';
      }
      return null;
    },
  );
});
