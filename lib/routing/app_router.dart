import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/routing/routes.dart';
import 'package:allumni_connect/features/auth/providers/auth_providers.dart';
import 'package:allumni_connect/features/auth/screens/login_screen.dart';
import 'package:allumni_connect/features/auth/screens/forgot_password_screen.dart';
import 'package:allumni_connect/features/onboarding/screens/onboarding_screen.dart';
import 'package:allumni_connect/features/directory/screens/directory_screen.dart';
import 'package:allumni_connect/features/detail/screens/alumni_detail_screen.dart';
import 'package:allumni_connect/features/map/screens/map_view_screen.dart';
import 'package:allumni_connect/features/profile/screens/my_profile_screen.dart';
import 'package:allumni_connect/features/profile/screens/edit_profile_screen.dart';
import 'package:allumni_connect/features/settings/screens/settings_screen.dart';
import 'package:allumni_connect/features/settings/screens/change_password_screen.dart';
import 'package:allumni_connect/features/admin/screens/add_alumni_screen.dart';
import 'package:allumni_connect/features/admin/screens/invitation_sent_screen.dart';
import 'package:allumni_connect/core/widgets/main_scaffold.dart';

final Provider<GoRouter> routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthChangeNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) => _handleRedirect(ref, state),
    routes: [
      GoRoute(
        path: '/',
        name: RouteName.splash,
        redirect: (context, state) => '/${RouteName.login}',
      ),
      GoRoute(
        path: '/${RouteName.login}',
        name: RouteName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${RouteName.forgotPassword}',
        name: RouteName.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/${RouteName.onboarding}',
        name: RouteName.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/${RouteName.alumniDetail}/:id',
        name: RouteName.alumniDetail,
        builder: (context, state) => AlumniDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/${RouteName.addAlumni}',
        name: RouteName.addAlumni,
        builder: (context, state) => const AddAlumniScreen(),
      ),
      GoRoute(
        path: '/${RouteName.invitationSent}',
        name: RouteName.invitationSent,
        builder: (context, state) => const InvitationSentScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainScaffold(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteName.directory}',
                name: RouteName.directory,
                builder: (context, state) => const DirectoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteName.map}',
                name: RouteName.map,
                builder: (context, state) => const MapViewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteName.myProfile}',
                name: RouteName.myProfile,
                builder: (context, state) => const MyProfileScreen(),
                routes: [
                  GoRoute(
                    path: RouteName.editProfile,
                    name: RouteName.editProfile,
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/${RouteName.settings}',
                name: RouteName.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: RouteName.changePassword,
                    name: RouteName.changePassword,
                    builder: (context, state) => const ChangePasswordScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

String? _handleRedirect(Ref ref, GoRouterState state) {
  final auth = ref.read(authStateProvider);
  if (auth.isLoading) return null;

  final loggedIn = auth.value != null;
  final location = state.matchedLocation;

  final publicPaths = <String>{
    '/${RouteName.login}',
    '/${RouteName.forgotPassword}',
  };
  final onboardingPath = '/${RouteName.onboarding}';
  final directoryPath = '/${RouteName.directory}';

  if (!loggedIn) {
    return publicPaths.contains(location) ? null : '/${RouteName.login}';
  }

  final alumniAsync = ref.read(currentAlumniProvider);
  if (alumniAsync.isLoading) return null;
  final profilComplet = alumniAsync.value?.profilComplet ?? false;

  if (publicPaths.contains(location) || location == '/') {
    return profilComplet ? directoryPath : onboardingPath;
  }

  if (!profilComplet && location != onboardingPath) {
    return onboardingPath;
  }

  if (profilComplet && location == onboardingPath) {
    return directoryPath;
  }

  return null;
}

class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    _authSub = ref.listen(
      authStateProvider,
      (_, _) => notifyListeners(),
    );
    _alumniSub = ref.listen(
      currentAlumniProvider,
      (_, _) => notifyListeners(),
    );
  }

  late final ProviderSubscription _authSub;
  late final ProviderSubscription _alumniSub;

  @override
  void dispose() {
    _authSub.close();
    _alumniSub.close();
    super.dispose();
  }
}
