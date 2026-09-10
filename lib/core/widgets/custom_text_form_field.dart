import 'package:flutter/material.dart';
import 'package:newst/core/theme/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
    this.maxLines,
    this.validator,
    this.textInputAction,
    this.textInputType,
    this.isPassword = false,
  });

  final String title;
  final TextEditingController controller;
  final int? maxLines;
  final String hintText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;
  final bool isPassword;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          maxLines: widget.maxLines,
          textInputAction: widget.textInputAction,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  )
                : null,
          ),
          cursorColor: AppColors.textPrimary,
          keyboardType: widget.textInputType,
          obscureText: widget.isPassword ? _obscureText : false,
        ),
      ],
    );
  }
}
