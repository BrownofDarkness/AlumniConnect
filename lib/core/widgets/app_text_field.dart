import 'package:flutter/material.dart';

/// Champ de saisie réutilisable avec label au-dessus.
class AppTextField extends StatelessWidget {
  const AppTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(fallbackHeight: 74);
  }
}
