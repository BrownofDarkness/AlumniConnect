import 'package:go_router/go_router.dart';
import 'package:allumni_connect/routing/routes.dart';
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

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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
      path: '/${RouteName.directory}',
      name: RouteName.directory,
      builder: (context, state) => const DirectoryScreen(),
    ),
    GoRoute(
      path: '/${RouteName.alumniDetail}/:id',
      name: RouteName.alumniDetail,
      builder: (context, state) => AlumniDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/${RouteName.map}',
      name: RouteName.map,
      builder: (context, state) => const MapViewScreen(),
    ),
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
  ],
);
