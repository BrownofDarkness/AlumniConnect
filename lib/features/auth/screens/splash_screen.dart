import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Image(
          image: AssetImage('assets/images/logo.png'),
          width: 130,
          height: 130,
        ),
      ),
    );
  }
}
