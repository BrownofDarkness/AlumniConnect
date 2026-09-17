import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/firebase_options.dart';
import 'package:allumni_connect/routing/app_router.dart';
import 'package:allumni_connect/core/providers/theme_mode_provider.dart';
import 'package:allumni_connect/core/theme/app_theme.dart';

Future<void> main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterNativeSplash.remove();
  runApp(
    const ProviderScope(
      child: AllumniConnectApp(),
    ),
  );
}

class AllumniConnectApp extends ConsumerStatefulWidget {
  const AllumniConnectApp({super.key});

  @override
  ConsumerState<AllumniConnectApp> createState() => _AllumniConnectAppState();
}

class _AllumniConnectAppState extends ConsumerState<AllumniConnectApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final ThemeMode themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;
    return GestureDetector(
      onTap: hideKeyboard,
      child: MaterialApp.router(
        title: 'AlumniConnect',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        builder: (context, child) {
          final MediaQueryData mq = MediaQuery.of(context);
          final double clamped = mq.textScaler.scale(1).clamp(0.9, 1.3);
          return MediaQuery(
            data: mq.copyWith(textScaler: TextScaler.linear(clamped)),
            child: child!,
          );
        },
      ),
    );
  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
