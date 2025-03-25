import 'dart:convert';

import 'package:admin_curator/Models/model_tasks.dart';
import 'package:admin_curator/Models/task_model.dart';
import 'package:admin_curator/Presentation/About/about.dart';
import 'package:admin_curator/Presentation/Auth/Login/auth_signin.dart';
import 'package:admin_curator/Presentation/Dashboard/components/assignPricePopUp..dart';
import 'package:admin_curator/Presentation/Dashboard/dashboard_screen.dart';
import 'package:admin_curator/Presentation/LoadingScreen/loading_screen.dart';
import 'package:admin_curator/Presentation/MainLayout/main_layout.dart';
import 'package:admin_curator/Presentation/TasksScreen/task_details_assign.dart';
import 'package:admin_curator/Presentation/TasksScreen/tasks_details_age.dart';
import 'package:admin_curator/Presentation/TasksScreen/tasks_screen.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../Presentation/CuratorProfiles/curator_profiles.dart';
import '../Presentation/TasksScreen/task_details_github.dart';

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
            builder: (context, state) => DashboardScreen(),
          ),
          GoRoute(
            path: '/curatorProfiles',
            builder: (context, state) => const CuratorProfiles(),
          ),

          GoRoute(
            path: '/tasks',
            builder: (context, state) => const CuratorProfilesList(),
          ),
          GoRoute(
            path: '/tasks_details/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return TaskAdminPage(id ?? '');
            },
          ),
          GoRoute(
            path: '/crm_tasks',
            builder: (context, state) {
              final TaskModel? data = state.extra as TaskModel?;
              if (data != null) {
                return TasksDetailsPAge(data);
              } else {
                return const Scaffold(
                  body: Center(child: Text('No Data Found')),
                );
              }
            },
          ),
          GoRoute(
            path: '/crm_tasks_github/:taskID',
            builder: (context, state) {
              final taskId = state.pathParameters['taskId'] ?? '';
              return TaskDetailsScreen(taskId: taskId);
            },
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
