import 'package:flutter/material.dart';

class InteractiveButton extends StatefulWidget {
  final void Function()? onPressed;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final Color? backgroundColor;
  final Color? backgroundHoverColor;
  final Color? hoverBorderColor;
  final Color? textColor;
  final Icon? icon;
  final String? label;
  final bool reactiveBorder;
  final double borderThickness;
  final bool disabled;

  const InteractiveButton({
    super.key,
    this.onPressed,
    this.icon,
    this.label,
    this.onHover,
    this.onFocusChange,
    this.backgroundColor,
    this.hoverBorderColor,
    this.backgroundHoverColor,
    this.reactiveBorder = false,
    this.borderThickness = 0,
    this.disabled = false,
    this.textColor,
  });
  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton> {
  bool _active = false;

  bool get active => _active;
  set active(bool value) {
    setState(() {
      _active = value;
    });
  }

  bool _hover = false;
  bool get hover => _hover;
  set hover(bool value) {
    setState(() {
      _hover = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);
    var bgColor = widget.backgroundColor ?? Colors.white;
    var fgColor = widget.textColor ?? Theme.of(context).colorScheme.primary;
    var overlayColor = (widget.backgroundHoverColor ?? fgColor).withOpacity(0.02);
    var shouldDisplayBorder = widget.reactiveBorder && (hover || active) || widget.borderThickness > 0;
    double paddingWidth = !widget.disabled ? active ? 32 : hover ? 28 : 24 : 24;
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOutCubicEmphasized,
      child: ElevatedButton(
        onPressed: widget.disabled ? null : widget.onPressed,
        onHover: (value) => {
          hover = value
        },
        onFocusChange: (value) => {
          active = value
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 0),
          padding: const EdgeInsets.symmetric(vertical: 24),
          animationDuration: duration,
          backgroundColor: widget.disabled ? Colors.grey : bgColor,
          disabledBackgroundColor: widget.disabled ? Colors.grey : bgColor,
          overlayColor: overlayColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: shouldDisplayBorder ? widget.hoverBorderColor ?? fgColor : Colors.transparent,
              width: shouldDisplayBorder ? hover ? 2 : widget.borderThickness : 0,
            ),
          ),
        ),
        child: AnimatedPadding(
          padding: EdgeInsets.symmetric(horizontal: paddingWidth),
          duration: duration,
          curve: Curves.easeInOutCubicEmphasized,
          child: Row(
            children: [
              if (widget.icon != null)
                AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOutCubicEmphasized,
                  transform: active || hover ? Matrix4.translationValues(6, 0, 0) : Matrix4.identity(),
                  child: Icon(
                    widget.icon!.icon,
                    color: widget.textColor,
                  ),
                ),
              const Spacer(),
              Text(
                widget.label ?? 'No label',
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 16,
                )
              )
            ],
          ),
        )
      )
    );
  }
}



