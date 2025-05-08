import 'package:admin_curator/Constants/app_colors.dart';
import 'package:admin_curator/Core/Notifiers/auth_notifier.dart';
import 'package:admin_curator/Presentation/LoadingScreen/loading_screen.dart';
import 'package:admin_curator/Presentation/Widgets/logo.dart';
import 'package:admin_curator/Providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../Constants/app_styles.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  final String currentRoute;
  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final authState = ref.watch(authNotifierProvider);
    if (authState.user == null) {
      return const LoadingScreen();
    }

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: AppColors.secondary,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LogoWidget(height: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.orange,
                        child: ClipOval(
                          child: Image.network(
                            authState.user!.photoUrl,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                                fit: BoxFit.cover,
                                width: 140,
                                height: 140,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        authState.user?.displayName ?? "Full Name",
                        style: AppStyles.style20.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Navigation Options
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildNavItem(
                        context,
                        label: "Task Management",
                        route: '/dashboard',
                        icon: Icons.dashboard,
                        authNotifier: authNotifier,
                      ),
                      _buildNavItem(
                        context,
                        label: "Onboard Curators",
                        route: '/curatorProfiles',
                        icon: Icons.task,
                        authNotifier: authNotifier,
                      ),
                      _buildNavItem(
                        context,
                        label: "Curators",
                        route: '/tasks',
                        icon: Icons.analytics,
                        authNotifier: authNotifier,
                      ),
                      _buildNavItem(
                        context,
                        label: "Pending Payments",
                        route: '/pending_tasks',
                        icon: Icons.currency_rupee,
                        authNotifier: authNotifier,
                      ),
                      // _buildNavItem(
                      //   context,
                      //   label: " CRM Tasks",
                      //   route: '/crm_tasks',
                      //   icon: Icons.analytics,
                      //   authNotifier: authNotifier,
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildNavItem(
                    context,
                    label: "Logout",
                    route: '/logout',
                    icon: Icons.logout,
                    authNotifier: authNotifier,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String label,
    required String route,
    required IconData icon,
    required AuthNotifier authNotifier,
  }) {
    if (route == '/logout') {
      return InkWell(
        onTap: () async {
          await authNotifier.signOut();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey.shade500),
              const SizedBox(width: 16),
              Text(
                label,
                style: AppStyles.style20.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      );
    }
    bool isSelected = currentRoute == route;

    return InkWell(
      onTap: () => context.go(route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.orange.shade900 : Colors.grey.shade500,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppStyles.style20.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black87,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
