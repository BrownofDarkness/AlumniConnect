import 'package:flutter/material.dart';

class AvatarStack extends StatelessWidget {
  final List<LinearGradient> gradients;
  final double size;
  final double overlap;

  const AvatarStack({
    super.key,
    required this.gradients,
    this.size = 42,
    this.overlap = 14,
  });

  static const List<LinearGradient> sampleGradients = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFD4A574), Color(0xFF8B6F47)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFA3B8D1), Color(0xFF4A6F9C)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFC9A690), Color(0xFF7A5942)],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE8C5A0), Color(0xFFA68766)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).scaffoldBackgroundColor;
    final width = size + (gradients.length - 1) * (size - overlap);

    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < gradients.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  gradient: gradients[i],
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
