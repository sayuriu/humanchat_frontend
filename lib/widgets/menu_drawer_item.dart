import 'package:flutter/material.dart';

class MenuDrawerItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final void Function()? onPressed;
  final void Function()? onAnimationEnd;
  final Color? fgColor;
  final Color? bgColor;
  final Color? fgHoverColor;
  final Color? bgHoverColor;
  final bool isActive;

  const MenuDrawerItem({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.isActive = false,
    this.onAnimationEnd,
    this.fgColor,
    this.bgColor,
    this.fgHoverColor,
    this.bgHoverColor,
  });

  @override
  State<MenuDrawerItem> createState() => _MenuDrawerItemState();
}

class _MenuDrawerItemState extends State<MenuDrawerItem> {
  bool _hover = false;

  bool get hover => _hover;
  set hover(bool value) {
    setState(() {
      _hover = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    const hoverDuration = Duration(milliseconds: 500);
    const animationDuration = Duration(milliseconds: 500);
    var fgColor = widget.isActive
      ? widget.bgColor ?? Colors.white
      : _hover
        ? widget.fgHoverColor ?? Theme.of(context).colorScheme.primary
        : widget.fgColor ?? Theme.of(context).colorScheme.onSurface;
    var bgColor = widget.isActive
      ? widget.fgColor ?? Theme.of(context).colorScheme.primary
      : _hover
        ? widget.bgHoverColor ?? Theme.of(context).colorScheme.primary.withOpacity(0.05)
        : widget.bgColor ?? Colors.transparent;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hover = false;
        });
      },
      child: InkWell(
        onTap: widget.onPressed,
        onFocusChange: (value) {
          setState(() {
            _hover = value;
          });
        },
        child: AnimatedContainer(
          onEnd: widget.onAnimationEnd,
          duration: hoverDuration,
          curve: Curves.easeInOutQuint,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: bgColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: hoverDuration,
                  curve: Curves.easeInOutQuint,
                  transformAlignment: Alignment.center,
                  transform: widget.isActive
                    ? Matrix4.translationValues(12, 4, 0).scaled(3, 3, 1)
                    : hover
                      ? Matrix4.translationValues(8, 0, 0)
                      : Matrix4.identity(),
                  child: Icon(
                    widget.icon,
                    color: widget.isActive ? fgColor.withOpacity(0.1) : fgColor,
                  ),
                ),
                Flexible(
                  child: AnimatedContainer(
                    duration: animationDuration,
                    curve: Curves.easeInOutQuint,
                    width: widget.isActive ? 300 : 16,
                  )
                ),
                // const Gap(16),
                AnimatedContainer(
                  duration: hoverDuration,
                  curve: Curves.easeInOutQuint,
                  transform: !widget.isActive && hover
                    ? Matrix4.translationValues(4, 0, 0)
                    : Matrix4.identity(),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: fgColor,
                      fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}