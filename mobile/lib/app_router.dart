import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/properties_page.dart';
import 'pages/property_details_page.dart';
import 'pages/events_page.dart';
import 'pages/offers_page.dart';
import 'pages/bookings_page.dart';
import 'pages/profile_page.dart';
import 'pages/analytics_overview_page.dart';
import 'pages/agents_page.dart';
import 'pages/agent_details_page.dart';
import 'pages/ratings_page.dart';
import 'pages/auth/login_page.dart';
import 'widgets/auth_gate.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth/login',
    routes: [
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => AuthGate(child: const PropertiesPage()),
      ),
      GoRoute(
        path: '/properties/:id',
        builder: (context, state) => PropertyDetailsPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/events',
        builder: (context, state) => const EventsPage(),
      ),
      GoRoute(
        path: '/offers',
        builder: (context, state) => const OffersPage(),
      ),
      GoRoute(
        path: '/bookings',
        builder: (context, state) => const BookingsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/profile/analytics',
        builder: (context, state) => const AnalyticsOverviewPage(),
      ),
      GoRoute(
        path: '/profile/agents',
        builder: (context, state) => const AgentsPage(),
      ),
      GoRoute(
        path: '/agents/:id',
        builder: (context, state) => AgentDetailsPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/profile/ratings',
        builder: (context, state) => const RatingsPage(),
      ),
    ],
  );
});

