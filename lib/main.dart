import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allumni_connect/firebase_options.dart';
import 'package:allumni_connect/routing/app_router.dart';
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

class AllumniConnectApp extends StatefulWidget {
  const AllumniConnectApp({super.key});

  @override
  State<AllumniConnectApp> createState() => _AllumniConnectAppState();
}

class _AllumniConnectAppState extends State<AllumniConnectApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: MaterialApp.router(
        title: 'AlumniConnect',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
      ),
    );
  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
