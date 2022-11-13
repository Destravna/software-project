import 'package:flutter/material.dart';

import '../../utils.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? editingController;
  final String? hintText;
  final Widget? prefixIcon;
  final double? width;
  final bool? hasSuffixIcon;
  final TextInputType? inputType;
  final TextStyle? textStyle;
  int? multiLine = 1;

  CustomTextField(
      {this.editingController,
      this.hintText,
      this.prefixIcon,
      this.width,
      this.hasSuffixIcon,
      this.inputType,
      this.multiLine,
      this.textStyle});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obscureText = widget.hasSuffixIcon!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      // color: Colors.grey,
      // height: 50,
      // width: 200,
      child: TextFormField(
          maxLines: widget.multiLine,
          controller: widget.editingController,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.hasSuffixIcon!
                ? IconButton(
                    hoverColor: backGroundColor,
                    highlightColor: backGroundColor,
                    splashColor: backGroundColor,
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: Icon(
                      obscureText
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                      color: Colors.white,
                    ))
                : SizedBox.shrink(),
            labelStyle: const TextStyle(fontSize: 14, color: greyStyleText),

            labelText: "${widget.hintText}",
            fillColor: Colors.white,
            border: OutlineInputBorder(
              gapPadding: 2,
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            //fillColor: Colors.green
          ),
          validator: (val) {},
          obscureText: obscureText,
          keyboardType: widget.inputType,
          style: widget.textStyle),
    );
  }
}
