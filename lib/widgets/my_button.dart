import 'package:flutter/material.dart';

import '../utils/color_theme.dart';

class MyElevatedButton extends StatefulWidget {
  final Function()? onPress;
  final Color? buttonColor;
  final double? elevation;
  final Widget buttonContent;
  final bool? disableButton;
  final BorderSide? border;
  final double? width;
  final double? height;
  final double? borderRadius;
  const MyElevatedButton(
      {super.key,
      required this.onPress,
      required this.buttonContent,
      this.buttonColor,
      this.elevation,
      this.border,
      this.disableButton,
      this.height,
      this.width,
      this.borderRadius});

  @override
  State<MyElevatedButton> createState() => _MyElevatedButtonState();
}

class _MyElevatedButtonState extends State<MyElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(widget.elevation),
              backgroundColor: WidgetStateProperty.all<Color>(
                  widget.buttonColor ?? ColorTheme.primaryColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: widget.border ?? BorderSide.none,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 6.0),
              ))),
          onPressed: widget.disableButton == true ? null : widget.onPress,
          child: widget.buttonContent),
    );
  }
}

class MyOutlineButton extends StatefulWidget {
  final double elevation;
  final Color buttonColor;
  final Function() onPress;
  final Widget child;
  final double borderWidth;
  final Color borderColor;
  const MyOutlineButton(
      {super.key,
      required this.buttonColor,
      required this.child,
      required this.elevation,
      required this.onPress,
      required this.borderColor,
      required this.borderWidth});

  @override
  State<MyOutlineButton> createState() => _MyOutlineButtonState();
}

class _MyOutlineButtonState extends State<MyOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all(widget.elevation),
            backgroundColor: WidgetStateProperty.all<Color>(widget.buttonColor),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                  width: widget.borderWidth, color: widget.borderColor),
              borderRadius: BorderRadius.circular(6.0),
            ))),
        onPressed: widget.onPress,
        child: widget.child);
  }
}
