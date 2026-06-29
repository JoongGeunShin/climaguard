import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/user_profile_provider.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/otp_screen.dart';

import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/shelter/shelter_screen.dart';
import '../../presentation/screens/splash_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authAsync = ref.read(authStateProvider);
      final loc = state.matchedLocation;

      // auth 또는 profile 로딩 중 → 스플래시 유지
      if (authAsync.isLoading) {
        return loc == '/splash' ? null : '/splash';
      }

      final isLoggedIn = authAsync.valueOrNull != null;
      final profileAsync = ref.read(userProfileNotifierProvider);

      if (!isLoggedIn) {
        return (loc == '/login' || loc == '/otp') ? null : '/login';
      }

      // 로그인됐지만 프로필 아직 로딩 중 → 스플래시 유지
      if (profileAsync.isLoading) {
        return loc == '/splash' ? null : '/splash';
      }

      final hasProfile = profileAsync.valueOrNull != null;
      if (!hasProfile) {
        return loc == '/onboarding' ? null : '/onboarding';
      }
      if (loc == '/login' || loc == '/otp' || loc == '/onboarding' || loc == '/splash') {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (_, state) {
          final extra = state.extra as Map<String, dynamic>;
          return OtpScreen(
            phoneNumber: extra['phoneNumber'] as String,
            verificationId: extra['verificationId'] as String,
          );
        },
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, _) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/shelter', builder: (_, _) => const ShelterScreen()),
          GoRoute(
            path: '/notifications',
            builder: (_, _) => const _NotificationsPlaceholder(),
          ),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
    ],
  );
}

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
    _ref.listen(userProfileNotifierProvider, (_, _) => notifyListeners());
  }

  final AppRouterRef _ref;
}

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = switch (location) {
      '/' => 0,
      '/shelter' => 1,
      '/notifications' => 2,
      '/profile' => 3,
      _ => 0,
    };

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/shelter');
            case 2:
              context.go('/notifications');
            case 3:
              context.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '홈',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: '쉘터',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: '알림',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }
}

class _NotificationsPlaceholder extends StatelessWidget {
  const _NotificationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('알림 내역', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
