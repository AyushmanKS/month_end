import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_durations.dart';
import '../../core/logging/logging_observers.dart';
import '../../features/auth/presentation/screens/optional_auth_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/bucket/presentation/screens/bucket_home_screen.dart';
import '../../features/bucket/presentation/screens/create_bucket_screen.dart';
import '../../features/bucket/presentation/screens/join_bucket_screen.dart';
import '../../features/bucket/presentation/screens/invite_member_screen.dart';
import '../../features/expenses/presentation/screens/add_expense_screen.dart';
import '../../features/expenses/presentation/screens/big_expense_screen.dart';
import '../../features/expenses/presentation/screens/expense_history_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../shared_widgets/main_shell.dart';
import '../../shared_widgets/splash_screen.dart';
import 'route_names.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: RouteNames.splash,
    observers: [LoggingNavigatorObserver()],
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.optionalAuth,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const OptionalAuthScreen()),
      ),
      GoRoute(
        path: RouteNames.signup,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const SignupScreen()),
      ),
      GoRoute(
        path: RouteNames.createBucket,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const CreateBucketScreen()),
      ),
      GoRoute(
        path: RouteNames.joinBucket,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const JoinBucketScreen()),
      ),
      GoRoute(
        path: RouteNames.inviteMember,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const InviteMemberScreen()),
      ),
      GoRoute(
        path: RouteNames.addExpense,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const AddExpenseScreen()),
      ),
      GoRoute(
        path: RouteNames.bigExpense,
        parentNavigatorKey: _rootKey,
        pageBuilder: (context, state) =>
            _fadeSlide(state, const BigExpenseScreen()),
      ),
      ShellRoute(
        navigatorKey: _shellKey,
        observers: [LoggingNavigatorObserver()],
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) =>
                _noTransition(state, const BucketHomeScreen()),
          ),
          GoRoute(
            path: RouteNames.expenses,
            pageBuilder: (context, state) =>
                _noTransition(state, const ExpenseHistoryScreen()),
          ),
          GoRoute(
            path: RouteNames.notifications,
            pageBuilder: (context, state) =>
                _noTransition(state, const NotificationsScreen()),
          ),
          GoRoute(
            path: RouteNames.profile,
            pageBuilder: (context, state) =>
                _noTransition(state, const ProfileScreen()),
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _fadeSlide(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    name: state.uri.path,
    transitionDuration: AppDurations.pageTransition,
    child: child,
    transitionsBuilder: (context, animation, secondary, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

CustomTransitionPage<void> _noTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    name: state.uri.path,
    transitionDuration: Duration.zero,
    child: child,
    transitionsBuilder: (context, animation, secondary, child) => child,
  );
}
