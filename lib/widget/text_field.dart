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

  /// ✅ Automatic validation based on label
  String? _autoValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '${widget.label} is required';
    }

    if (widget.label.toLowerCase().contains('email')) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Enter a valid email address';
      }
    }

    if (widget.label.toLowerCase().contains('password')) {
      if (value.length < 8) return 'Password must be at least 8 characters';
      if (!RegExp(r'[A-Z]').hasMatch(value))
        return 'Include an uppercase letter';
      if (!RegExp(r'[a-z]').hasMatch(value))
        return 'Include a lowercase letter';
      if (!RegExp(r'[0-9]').hasMatch(value)) return 'Include a number';
      if (!RegExp(r'[!@#\$&*~]').hasMatch(value))
        return 'Include a special character';
    }

    return null; // ✅ Valid input
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
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

        /// TextFormField
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscure : false,
          style: TextStyle(color: widget.textColor),
          // validator: _autoValidator,
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
