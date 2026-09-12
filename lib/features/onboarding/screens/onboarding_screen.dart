import 'package:flutter/material.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/welcome_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/identity_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/contact_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/location_choice_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/location_manual_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/security_step.dart';
import 'package:allumni_connect/features/onboarding/widgets/steps/confirmation_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  static const List<Widget> _steps = [
    WelcomeStep(),
    IdentityStep(),
    ContactStep(),
    LocationChoiceStep(),
    LocationManualStep(),
    SecurityStep(),
    ConfirmationStep(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goBack() async {
    if (_current > 0) {
      await _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _current == 0,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _goBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            physics: const NeverScrollableScrollPhysics(),
            children: _steps,
          ),
        ),
      ),
    );
  }
}
