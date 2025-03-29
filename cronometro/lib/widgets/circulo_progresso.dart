import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressCircle extends StatelessWidget {
  final double progresso;
  const ProgressCircle({required this.progresso, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(200, 200), // Tamanho do círculo
      painter: ProgressCirclePainter(progress: progresso),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;

  ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final paint = Paint()
      ..color = Colors.grey[300]! // Cor de fundo (círculo completo)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Desenha o círculo de fundo
    canvas.drawCircle(center, radius, paint);

    // Desenha o arco de progresso
    final progressPaint = Paint()
      ..color = Colors.amber // Cor do progresso
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Começa no topo
      2 * math.pi * progress, // Ângulo proporcional ao progresso
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
