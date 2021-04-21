import 'package:fanta_sanremo/utils/theme.dart';
import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  int questionIndex;
  VoidCallback onTimerCompleted;
  QuizTimer({@required this.questionIndex, this.onTimerCompleted});

  @override
  _QuizTimerState createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> with TickerProviderStateMixin {
  AnimationController controller;
  double barHeight = 64;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 10));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTimerCompleted();
      }
    });
    if (!controller.isAnimating && !controller.isCompleted)
      controller.forward();
  }

  @override
  void dispose() {
    widget.onTimerCompleted();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          height: barHeight,
          child: Stack(fit: StackFit.expand, children: [
            CustomPaint(
              painter: LinearTimerPainter(animation: controller),
            ),
            Center(
                child: Text(
              timerString,
              style: TextStyle(color: color_b5, fontWeight: FontWeight.w700),
            ))
          ]),
        );
      },
    );
  }

  String get timerString {
    if (controller.isAnimating) {
      Duration duration = controller.duration * (1 - controller.value);
      return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '';
  }
}

class LinearTimerPainter extends CustomPainter {
  LinearTimerPainter({this.animation}) : super(repaint: animation);

  final Animation<double> animation;
  final Color consumedTimeColor = color_b2.withOpacity(0.6);
  final Color remainingTimeColor = color_b5.withOpacity(0.6);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = remainingTimeColor
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;
    paint.color = consumedTimeColor;
    canvas.drawLine(size.centerRight(Offset.zero),
        size.centerRight(Offset(-animation.value * size.width, 0)), paint);
  }

  @override
  bool shouldRepaint(LinearTimerPainter old) {
    return animation.value != old.animation.value;
  }
}
