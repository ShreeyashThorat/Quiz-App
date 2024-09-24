import 'package:flutter/material.dart';

import '../utils/color_theme.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? inputType;
  final Function(String)? onChange;
  final int? maxLength;
  final bool? isObscure;
  final Widget? preffix;
  final Widget? suffix;
  final int maxLines;
  final bool readOnly;
  final double? radius;
  final double? verticalPadding;
  final bool autofocus;
  final Function()? onTap;
  final Color? fillColor;
  final bool? filled;
  final String? Function(String?)? validator;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onChange,
      this.maxLength,
      this.isObscure = false,
      this.inputType,
      this.maxLines = 1,
      this.suffix,
      this.preffix,
      this.radius,
      this.verticalPadding,
      this.onTap,
      this.autofocus = false,
      this.readOnly = false,
      this.fillColor,
      this.filled,
      this.validator});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool obscure = false;

  @override
  void initState() {
    setState(() {
      obscure = widget.isObscure!;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      controller: widget.controller,
      obscureText: obscure,
      keyboardType: widget.inputType,
      onChanged: widget.onChange,
      maxLines: widget.isObscure == true ? 1 : widget.maxLines,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      style: const TextStyle(
          fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              fontSize: 15,
              color: ColorTheme.hintColor,
              fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 6)),
            borderSide: BorderSide(
                color: widget.filled == true
                    ? Colors.transparent
                    : ColorTheme.hintColor.withOpacity(0.7),
                width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 6)),
            borderSide: BorderSide(
                color: widget.filled == true
                    ? Colors.transparent
                    : ColorTheme.hintColor.withOpacity(0.7),
                width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 6)),
            borderSide: BorderSide(
                color: widget.filled == true
                    ? Colors.transparent
                    : ColorTheme.hintColor.withOpacity(0.7),
                width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 6)),
            borderSide: BorderSide(
                color: widget.filled == true ? Colors.transparent : Colors.red,
                width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 6)),
            borderSide: BorderSide(
                color: widget.filled == true ? Colors.transparent : Colors.red,
                width: 1),
          ),
          fillColor: widget.fillColor,
          filled: widget.filled,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
              vertical: widget.verticalPadding ?? 15, horizontal: 15),
          prefixIcon: widget.preffix,
          suffixIcon: widget.isObscure == true
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  highlightColor: Colors.transparent,
                  icon: obscure == true
                      ? Icon(
                          Icons.visibility_rounded,
                          color: ColorTheme.hintColor,
                          size: 22,
                        )
                      : Icon(
                          Icons.visibility_off_rounded,
                          color: ColorTheme.textColor,
                          size: 22,
                        ))
              : widget.suffix),
      cursorColor: Colors.black,
      cursorHeight: 18,
      cursorWidth: 1,
      onTap: widget.onTap,
      validator: widget.validator,
      onSaved: (newValue) => widget.controller.text = newValue!,
    );
  }
}

bool validatePhone(String phone) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(patttern);
  return regExp.hasMatch(phone);
}

bool validateEmail(String email) {
  RegExp emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

  return emailReg.hasMatch(email);
}

bool validatePassword(String password) {
  RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{9,}$');
  return passwordRegExp.hasMatch(password);
}

bool containsSpecialCharOrNumber(String input) {
  RegExp regExp = RegExp(r'[!@#\$%^&*(),.?":{}|<>0-9]');
  return regExp.hasMatch(input);
}
