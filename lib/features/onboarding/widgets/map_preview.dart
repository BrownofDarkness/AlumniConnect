import 'package:flutter/material.dart';
import 'package:allumni_connect/core/constants/app_colors.dart';

class MapPreview extends StatelessWidget {
  final double height;

  const MapPreview({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8EEF5), Color(0xFFDDE5EF)],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _StreetsPainter(),
          ),
          _buildPin(),
        ],
      ),
    );
  }

  Widget _buildPin() {
    return SizedBox(
      width: 24,
      height: 32,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.amber,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.amber.withValues(alpha: 0.45),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: AppColors.amber.withValues(alpha: 0.18),
                  spreadRadius: 6,
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            child: Transform.rotate(
              angle: 0.785398,
              child: Container(
                width: 10,
                height: 10,
                color: AppColors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreetsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.08)
      ..strokeWidth = 2;

    for (double y = -size.height; y < size.height * 2; y += 45) {
      canvas.drawLine(
        Offset(-10, y),
        Offset(size.width + 10, y + size.width * 0.577),
        paint,
      );
    }

    final paint2 = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.06)
      ..strokeWidth = 2;

    for (double y = -size.height; y < size.height * 2; y += 60) {
      canvas.drawLine(
        Offset(-10, y),
        Offset(size.width + 10, y - size.width * 0.577),
        paint2,
      );
    }

    final paint3 = Paint()
      ..color = AppColors.navy.withValues(alpha: 0.05)
      ..strokeWidth = 2;

    for (double x = -20; x < size.width + 20; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint3);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
