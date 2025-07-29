import 'package:flutter/material.dart';
import 'package:mood_meal/constant/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final Color borderColor;
  final Color textColor;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.borderColor = const Color(0xFFCCCCCC),
    this.textColor = Colors.black,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label text
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: TextStyle(
              color: AppColors.secondary700,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 6),

        /// Text field
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "${widget.label} is Empty";
            } else {
              return null;
            }
          },
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscure : false,
          style: TextStyle(color: widget.textColor),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: AppColors.secondary400,
              fontWeight: FontWeight.w400,
            ),

            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.secondary200,
                      ),
                      onPressed: _toggleVisibility,
                    )
                    : null,

            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.red, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.red, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
