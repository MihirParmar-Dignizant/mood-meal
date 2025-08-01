import 'package:flutter/material.dart';
import 'package:mood_meal/constant/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final bool isDropdown;
  final List<String>? dropdownItems;
  final Color borderColor;
  final Color textColor;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.isDropdown = false,
    this.dropdownItems,
    this.borderColor = const Color(0xFFCCCCCC),
    this.textColor = Colors.black,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  bool _obscure = true;

  void _toggleVisibility() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  void _showDropdownMenu() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: position.dx,
            top: position.dy + size.height + 5,
            width: size.width,
            child: CompositedTransformFollower(
              offset: Offset(0, size.height + 5),
              link: _layerLink,
              showWhenUnlinked: false,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: widget.borderColor, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children:
                        widget.dropdownItems!.map((item) {
                          return ListTile(
                            dense: true,
                            visualDensity: const VisualDensity(vertical: -4),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            title: Text(
                              item,
                              style: const TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              widget.controller?.text = item;
                              _removeDropdown();
                            },
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

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

    return null;
  }

  @override
  void dispose() {
    _removeDropdown();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller ?? TextEditingController();

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          Text(
            widget.label,
            style: TextStyle(
              color: AppColors.secondary700,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 6),

          /// Text Field or Dropdown
          TextFormField(
            controller: controller,
            readOnly: widget.isDropdown,
            focusNode: _focusNode,
            obscureText: widget.isPassword ? _obscure : false,
            validator: _autoValidator,
            style: TextStyle(color: widget.textColor),
            onTap:
                widget.isDropdown
                    ? () {
                      if (_overlayEntry == null) {
                        _showDropdownMenu();
                      } else {
                        _removeDropdown();
                      }
                    }
                    : null,
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
                      : widget.isDropdown
                      ? const Icon(
                        Icons.arrow_drop_down_outlined,
                        color: AppColors.secondary200,
                      )
                      : null,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor, width: 1.5),
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
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.red, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
