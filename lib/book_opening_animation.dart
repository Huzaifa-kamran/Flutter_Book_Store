import 'package:flutter/material.dart';

class BookOpeningAnimation extends StatefulWidget {
  final Widget child;

  const BookOpeningAnimation({required this.child});

  @override
  _BookOpeningAnimationState createState() => _BookOpeningAnimationState();
}

class _BookOpeningAnimationState extends State<BookOpeningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BookPainter(_animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class BookPainter extends CustomPainter {
  final double progress;

  BookPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    double foldWidth = width * progress;

    Paint paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    // Draw book cover
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

    // Draw the fold
    paint.color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(foldWidth, 0, width - foldWidth, height), paint);

    // Draw the fold shadow
    paint.color = Colors.black.withOpacity(0.2);
    canvas.drawRect(Rect.fromLTWH(foldWidth, 0, 10, height), paint);

    // Optional: Draw book spine or additional details
    paint.color = Colors.grey.withOpacity(0.5);
    canvas.drawRect(Rect.fromLTWH(0, height - 20, width, 20), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
