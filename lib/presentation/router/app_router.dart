import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/trip/creating_itinerary_screen.dart';
import '../screens/trip/itinerary_view_screen.dart';
import '../screens/trip/chat_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/signup',
    redirect: (context, state) async {
      final authState = ref.read(authProvider);
      final isAuthenticated = authState.user != null;

      if (!isAuthenticated && state.uri.path != '/signup' && state.uri.path != '/login') {
        return '/signup';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/creating-itinerary',
        builder: (context, state) => CreatingItineraryScreen(
          prompt: state.extra as String,
        ),
      ),
      GoRoute(
        path: '/itinerary/:tripId',
        builder: (context, state) => ItineraryViewScreen(
          tripId: state.pathParameters['tripId']!,
        ),
      ),
      GoRoute(
        path: '/chat/:tripId',
        builder: (context, state) => ChatScreen(
          tripId: state.pathParameters['tripId']!,
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/error',
        builder: (context, state) => ErrorScreen(
          message: state.extra as String? ?? 'An error occurred',
        ),
      ),
    ],
  );
});

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.h4,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Back to Home',
              onPressed: () => context.go('/home'),
              variant: ButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}