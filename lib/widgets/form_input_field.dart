import 'dart:async';

import 'package:flutter/material.dart';

class FormInputField extends StatefulWidget {
  // TODO: Actually, those prop keys can be reactive
  final TextEditingController controller;
  final String? label;
  final String? description;
  late final String initialText;
  final bool isPassword;
  final FutureOr<String?> Function(String)? validator;
  late final Icon? icon;
  late final OutlineInputBorder border;
  late final OutlineInputBorder errorBorder;
  late final String? errorMessage;
  final bool disabled;
  final bool autofocus;
  final FocusNode? focusNode;

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
    this.errorMessage,
    this.isPassword = false,
    this.autofocus = false,
    this.focusNode,
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
      Future(() => widget.validator!(controller.text)).then((value) {
        setState(() {
          _errorMessage = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var hasError = (widget.errorMessage ?? _errorMessage) != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubicEmphasized,
      margin: EdgeInsets.only(bottom: hasError ? 8 : 0),
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
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          counterText: widget.description,
          icon: widget.icon != null ? Icon(
            widget.icon!.icon,
            color: hasError ? Colors.red : null,
          ) : null,
          border: widget.border,
          labelText: widget.label,
          errorBorder: widget.errorBorder,
          errorText: widget.errorMessage ?? _errorMessage,
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

