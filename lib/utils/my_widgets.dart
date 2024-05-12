import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRoundButton extends StatelessWidget {
  final Widget child;
  final void Function() onPressed;
  const MyRoundButton(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Colors.white, // border color
          shape: BoxShape.circle,
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class MyRoundBox extends StatelessWidget {
  final double diameter;
  final Color color;
  final Widget? child;
  const MyRoundBox({
    super.key,
    required this.diameter,
    required this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}

class MySwatch extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final void Function() onPressed;
  final void Function() onLongPressed;
  const MySwatch({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onPressed,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    // expensive, may not be needed
    bool isVeryBright = color.computeLuminance() > 0.9;
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: MyRoundBox(
        diameter: 36,
        color: Colors.white,
        child: Center(
          child: Center(
            child: MyRoundBox(
              diameter: 28,
              color: color,
              child: isSelected
                  ? Center(
                      child: MyRoundBox(
                        // visually the same size
                        diameter: isVeryBright ? 10 : 8,
                        color: isVeryBright ? Colors.black38 : Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextButton extends StatelessWidget {
  final String text;
  final double? fontSize = 16;
  final void Function()? onPressed;
  const MyTextButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }
}
