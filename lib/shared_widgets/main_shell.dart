import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app/router/route_names.dart';
import '../core/widgets/floating_bottom_nav.dart';
import '../features/bucket/presentation/providers/bucket_providers.dart';
import '../features/notifications/presentation/providers/notification_providers.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  static const List<String> _routes = [
    RouteNames.home,
    RouteNames.expenses,
    RouteNames.notifications,
    RouteNames.profile,
  ];

  int _indexForLocation(String location) {
    final match = _routes.indexWhere((route) => location.startsWith(route));
    return match < 0 ? 0 : match;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _indexForLocation(location);
    final unread = ref.watch(unreadNotificationCountProvider);
    final hasBuckets = ref.watch(myBucketsProvider).value?.isNotEmpty ?? false;
    ref.watch(thresholdWatcherProvider);

    return Scaffold(
      extendBody: true,
      body: child,
      floatingActionButton: currentIndex == 0 && hasBuckets
          ? FloatingActionButton.extended(
              onPressed: () => context.push(RouteNames.addExpense),
              icon: const Icon(Icons.add),
              label: const Text('Add expense'),
            )
          : null,
      bottomNavigationBar: FloatingBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          context.go(_routes[index]);
        },
        items: [
          const FloatingNavItem(icon: Icons.home_rounded, label: 'Home'),
          const FloatingNavItem(
            icon: Icons.receipt_long_rounded,
            label: 'Expenses',
          ),
          FloatingNavItem(
            icon: unread > 0
                ? Icons.notifications_active_rounded
                : Icons.notifications_rounded,
            label: 'Activity',
          ),
          const FloatingNavItem(icon: Icons.person_rounded, label: 'Profile'),
        ],
      ),
    );
  }
}
