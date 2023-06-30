// @author: tafiagu
// @email: tafiagu@gmail.com
// @date: 2023-06-30 17:42:11
import 'package:flutter/material.dart';

class JoyButton extends StatefulWidget {
  final double size;
  final double buttonRadius;
  final Function(String) onButtonTapDown;
  final Function(String) onButtonTapUp;

  const JoyButton({
    Key? key,
    required this.size,
    required this.buttonRadius,
    required this.onButtonTapDown,
    required this.onButtonTapUp,
  }) : super(key: key);

  @override
  _JoyButtonState createState() => _JoyButtonState();
}

class _JoyButtonState extends State<JoyButton> {
  String _direction = '';
  String _pressedButton = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: widget.size / 2 - widget.buttonRadius,
            child: _buildButton('W'),
          ),
          Positioned(
            bottom: 0,
            left: widget.size / 2 - widget.buttonRadius,
            child: _buildButton('S'),
          ),
          Positioned(
            left: 0,
            top: widget.size / 2 - widget.buttonRadius,
            child: _buildButton('A'),
          ),
          Positioned(
            right: 0,
            top: widget.size / 2 - widget.buttonRadius,
            child: _buildButton('D'),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label) {
    final isPressed = _pressedButton == label;
    return GestureDetector(
      onTapDown: (_) {
        widget.onButtonTapDown(label);
        _updatePressedButton(label);
      },
      onTapUp: (_) {
        widget.onButtonTapUp(label);
        _updatePressedButton('');
      },
      child: Container(
        width: widget.buttonRadius * 2,
        height: widget.buttonRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPressed ? Colors.red : Colors.grey[500],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: widget.buttonRadius,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _updateDirection(String direction) {
    setState(() {
      _direction = direction;
    });
  }

  String _getDirection(Offset localPosition) {
    final dx = localPosition.dx - widget.size / 2;
    final dy = localPosition.dy - widget.size / 2;

    if (dx.abs() > dy.abs()) {
      return dx > 0 ? 'D' : 'A';
    } else {
      return dy > 0 ? 'S' : 'W';
    }
  }

  void _updatePressedButton(String button) {
    setState(() {
      _pressedButton = button;
    });
  }

  String _getPressedButton(Offset localPosition) {
    final dx = localPosition.dx - widget.size / 2;
    final dy = localPosition.dy - widget.size / 2;

    if (dx.abs() < widget.buttonRadius && dy < 0) {
      return 'W';
    } else if (dx.abs() < widget.buttonRadius && dy > 0) {
      return 'S';
    } else if (dx > 0 && dy.abs() < widget.buttonRadius) {
      return 'D';
    } else if (dx < 0 && dy.abs() < widget.buttonRadius) {
      return 'A';
    } else {
      return '';
    }
  }
}
