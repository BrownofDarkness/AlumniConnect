import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:allumni_connect/features/onboarding/widgets/onboarding_progress_bar.dart';

class OnboardingStepShell extends StatelessWidget {
  final int? currentStep;
  final int totalSteps;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Widget child;
  final Widget? bottomAction;

  const OnboardingStepShell({
    super.key,
    this.currentStep,
    this.totalSteps = 4,
    this.showBackButton = true,
    this.onBack,
    required this.child,
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            if (showBackButton) _buildTopBar(context),
            if (currentStep != null) _buildProgressZone(),
            Expanded(child: child),
            if (bottomAction != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 22),
                child: bottomAction!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
            ),
            icon: Icon(
              LucideIcons.chevronLeft,
              size: 22,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressZone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 4, 28, 20),
      child: OnboardingProgressBar(
        current: currentStep!,
        total: totalSteps,
      ),
    );
  }
}
