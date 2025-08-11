import 'package:flutter/material.dart';

class HeroButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  const HeroButton({super.key, required this.onPressed, required this.child, this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12), this.borderRadius = 14});

  @override
  State<HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<HeroButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [scheme.primary, scheme.tertiary],
    );
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(color: scheme.primary.withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onHighlightChanged: (v) => setState(() => _pressed = v),
            onTap: widget.onPressed,
            child: Padding(
              padding: widget.padding,
              child: DefaultTextStyle(
                style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w700),
                child: Center(child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

