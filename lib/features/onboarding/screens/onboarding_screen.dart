import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:allumni_connect/routing/routes.dart';
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
  static const int _welcome = 0;
  static const int _identity = 1;
  static const int _contact = 2;
  static const int _locationChoice = 3;
  static const int _locationManual = 4;
  static const int _security = 5;
  static const int _confirmation = 6;

  final PageController _controller = PageController();
  int _current = _welcome;
  bool _fromGps = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goTo(int index) async {
    await _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _finish() => context.goNamed(RouteName.directory);

  Future<void> _handleHardwareBack() async {
    if (_current == _welcome || _current == _confirmation) return;
    await _goTo(_current - 1);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _current == _welcome,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _handleHardwareBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              WelcomeStep(onContinue: () => _goTo(_identity)),
              IdentityStep(
                onContinue: () => _goTo(_contact),
                onBack: () => _goTo(_welcome),
              ),
              ContactStep(
                onContinue: () => _goTo(_locationChoice),
                onBack: () => _goTo(_identity),
              ),
              LocationChoiceStep(
                onChooseGps: () {
                  setState(() => _fromGps = true);
                  _goTo(_locationManual);
                },
                onChooseManual: () {
                  setState(() => _fromGps = false);
                  _goTo(_locationManual);
                },
                onBack: () => _goTo(_contact),
              ),
              LocationManualStep(
                fromGps: _fromGps,
                onContinue: () => _goTo(_security),
                onBack: () => _goTo(_locationChoice),
              ),
              SecurityStep(
                onContinue: () => _goTo(_confirmation),
                onSkip: () => _goTo(_confirmation),
                onBack: () => _goTo(_locationManual),
              ),
              ConfirmationStep(onFinish: _finish),
            ],
          ),
        ),
      ),
    );
  }
}
