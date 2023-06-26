// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-26 22:20:55
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Joystick extends StatefulWidget {
  static const double radius = 100.0; // 定义摇杆的半径
  const Joystick({
    Key? key,
    this.size = const Size(radius * 2, radius * 2),
    this.color = Colors.blue,
    this.onChange,
  }) : super(key: key);

  final Size size;
  final Color color;
  final ValueChanged<Offset>? onChange;

  @override
  _JoystickState createState() => _JoystickState();
}

class _JoystickState extends State<Joystick> {
  double _x = 0.0;
  double _y = 0.0;

  void _handleChange() {
    if (widget.onChange != null) {
      widget.onChange!(Offset(_x, _y));
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final Offset position = details.localPosition;
    final double radius = widget.size.width / 2.0;
    final double dx = position.dx - radius;
    final double dy = position.dy - radius;
    final double distance = math.sqrt(dx * dx + dy * dy);
    final double angle = math.atan2(dy, dx);
    final double saturation = distance / radius;

    if (saturation > 1.0) {
      setState(() {
        _x = math.cos(angle);
        _y = math.sin(angle);
      });
    } else {
      setState(() {
        _x = dx / radius;
        _y = dy / radius;
      });
    }

    _handleChange();
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _x = 0.0;
      _y = 0.0;
    });

    _handleChange();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _x = 0.0;
      _y = 0.0;
    });

    _handleChange();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      onTapUp: _handleTapUp,
      child: CustomPaint(
        painter: _JoystickPainter(
          x: _x,
          y: _y,
          color: widget.color,
        ),
        size: widget.size,
      ),
    );
  }
}

class _JoystickPainter extends CustomPainter {
  final double x;
  final double y;
  final Color color;

  _JoystickPainter({
    required this.x,
    required this.y,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2.0;
    final double centerX = radius;
    final double centerY = radius;
    final double knobRadius = radius / 4.0;
    final double knobCenterX = centerX + x * radius;
    final double knobCenterY = centerY + y * radius;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, Paint()..color = Colors.red);
    canvas.drawCircle(Offset(knobCenterX, knobCenterY), knobRadius, paint);
  }

  @override
  bool shouldRepaint(_JoystickPainter oldDelegate) {
    return x != oldDelegate.x || y != oldDelegate.y;
  }
}
