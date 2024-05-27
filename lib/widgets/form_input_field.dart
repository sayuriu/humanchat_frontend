import 'package:flutter/material.dart';

class FormInputField extends StatefulWidget {
  // TODO: Actually, those prop keys can be reactive
  final TextEditingController controller;
  final String? label;
  final String? description;
  late final String initialText;
  final bool isPassword;
  final String? Function(String)? validator;
  late final Icon? icon;
  late final OutlineInputBorder border;
  late final OutlineInputBorder errorBorder;
  final bool disabled;

  FormInputField({
    super.key,
    required this.controller,
    this.label,
    OutlineInputBorder? border,
    OutlineInputBorder? errorBorder,
    this.initialText = '',
    this.icon,
    this.description,
    this.validator,
    this.disabled = false,
    this.isPassword = false,
  }) {
    this.border = border ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );
    this.errorBorder = errorBorder ?? OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(12),
    );
  }

  @override
  State<FormInputField> createState() => _FormInputFieldState();
}

class _FormInputFieldState extends State<FormInputField> {
  late TextEditingController controller;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.text = widget.initialText;
    if (widget.validator == null) return;
    controller.addListener(() {
      setState(() {
        _errorMessage = widget.validator!(controller.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubicEmphasized,
      margin: EdgeInsets.only(bottom: _errorMessage != null ? 8 : 0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.transparent
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: TextField(
        readOnly: widget.disabled,
        controller: controller,
        decoration: InputDecoration(
          counterText: widget.description,
          icon: widget.icon != null ? Icon(
            widget.icon!.icon,
            color: _errorMessage != null ? Colors.red : null,
          ) : null,
          border: widget.border,
          labelText: widget.label,
          errorBorder: widget.errorBorder,
          errorText: _errorMessage,
        ),
        // Text field is password
        obscureText: widget.isPassword,
      )
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

