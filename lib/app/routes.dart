import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/main_layout.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/dashboard_home_screen.dart';
import '../features/users/screens/users_management_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/services/screens/services_screen.dart';
import '../features/bills/screens/bills_screen.dart';
import '../features/circulars/screens/circulars_screen.dart';
import '../features/circulars/screens/circular_detail_screen.dart';
import '../features/projects/screens/projects_screen.dart';
import '../features/projects/screens/project_detail_screen.dart';
import '../features/complaints/screens/complaints_screen.dart';
import '../features/polls/screens/polls_screen.dart';
import '../features/suggestions/screens/suggestions_screen.dart';
import '../features/request_forms/screens/request_forms_screen.dart';
import '../features/request_forms/screens/user_requests_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/explores/screens/explores_admin_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/login',
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;
        final isLoginRoute = state.matchedLocation == '/login';

        // If not logged in and trying to access protected route, redirect to login
        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }

        // If logged in and on login page, redirect to dashboard
        if (isLoggedIn && isLoginRoute) {
          return '/dashboard';
        }

        return null;
      },
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainLayout(child: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              name: 'dashboard',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const DashboardHomeScreen(),
              ),
            ),
            // Placeholder routes for sidebar navigation
            GoRoute(
              path: '/users',
              name: 'users',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: UsersManagementScreen(),
              ),
            ),
            GoRoute(
              path: '/services',
              name: 'services',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ServicesScreen(),
              ),
            ),
            GoRoute(
              path: '/complaints',
              name: 'complaints',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ComplaintsScreen(),
              ),
            ),
            GoRoute(
              path: '/requests',
              name: 'requests',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RequestFormsScreen(),
              ),
            ),
            GoRoute(
              path: '/bills',
              name: 'bills',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const BillsScreen(),
              ),
            ),
            GoRoute(
              path: '/circulars',
              name: 'circulars',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CircularsScreen(),
              ),
            ),
            GoRoute(
              path: '/circulars/:id',
              name: 'circular-detail',
              pageBuilder: (context, state) {
                final extra = state.extra;
                final circular = extra is Map<String, dynamic> ? extra['circular'] : extra;
                return NoTransitionPage(
                  child: CircularDetailScreen(
                    circular: circular,
                  ),
                );
              },
            ),
            GoRoute(
              path: '/projects',
              name: 'projects',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const ProjectsScreen(),
              ),
            ),
            GoRoute(
              path: '/projects/:id',
              name: 'project-detail',
              pageBuilder: (context, state) {
                final extra = state.extra;
                final project = extra is Map<String, dynamic> ? extra['project'] : extra;
                return NoTransitionPage(
                  child: ProjectDetailScreen(
                    project: project,
                  ),
                );
              },
            ),
            GoRoute(
              path: '/projects/create',
              name: 'projects-create',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const ProjectsScreen(openCreateOnLoad: true),
              ),
            ),
            GoRoute(
              path: '/polls',
              name: 'polls',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PollsScreen(),
              ),
            ),
            GoRoute(
              path: '/suggestions',
              name: 'suggestions',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SuggestionsScreen(),
              ),
            ),
            GoRoute(
              path: '/request-forms',
              name: 'request-forms',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RequestFormsScreen(),
              ),
            ),
            GoRoute(
              path: '/user-requests',
              name: 'user-requests',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: UserRequestsScreen(),
              ),
            ),
            GoRoute(
              path: '/explore',
              name: 'explore',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ExploresAdminScreen(),
              ),
            ),
            GoRoute(
              path: '/notifications',
              name: 'notifications',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: NotificationsScreen(),
              ),
            ),
            GoRoute(
              path: '/logs',
              name: 'logs',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const _PlaceholderScreen(title: 'سجل الأنشطة'),
              ),
            ),
            GoRoute(
              path: '/settings',
              name: 'settings',
              pageBuilder: (context, state) => NoTransitionPage(
                child: const _PlaceholderScreen(title: 'الإعدادات'),
              ),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'الصفحة غير موجودة',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder screen for routes that will be implemented later
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'هذه الصفحة قيد التطوير',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
