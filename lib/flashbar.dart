import 'dart:async';
import 'package:flutter/material.dart';

///* The gravity of the Flashbar
enum FlashbarGravity { top, bottom }

///* The status of the Flashbar
enum FlashbarStatus { showing, shown, dismissing, dismissed }

/// Controls a [Flashbar] widget.
///
/// A [FlashbarController] can be used to programmatically dismiss a flashbar.
class FlashbarController {
  VoidCallback? _dismissListener;

  /// Dismisses the flashbar.
  void dismiss() {
    _dismissListener?.call();
  }

  void _attach(VoidCallback listener) {
    _dismissListener = listener;
  }

  void _detach() {
    _dismissListener = null;
  }
}

/// A highly customizable widget that can be displayed at the top or bottom of the screen.
///
/// This is the core widget that is used by the [showFlashbar] function.
class Flashbar extends StatefulWidget {
  final String? title;
  final String? message;
  final Widget? content;
  final Widget? icon;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final Duration duration;
  final FlashbarGravity gravity;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final TextStyle? messageTextStyle;
  final List<BoxShadow>? shadows;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Function(FlashbarStatus status)? onStatusChanged;
  final VoidCallback? onDismissed;
  final bool persistent;
  final FlashbarController? controller;
  final bool enableSwipeToDismiss;

  const Flashbar({
    super.key,
    this.title,
    this.message,
    this.content,
    this.icon,
    this.primaryAction,
    this.secondaryAction,
    this.duration = const Duration(seconds: 3),
    this.gravity = FlashbarGravity.bottom,
    this.backgroundColor,
    this.titleTextStyle,
    this.messageTextStyle,
    this.shadows,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
    this.borderRadius,
    this.onTap,
    this.onStatusChanged,
    this.onDismissed,
    this.persistent = false,
    this.controller,
    this.enableSwipeToDismiss = false,
  })  : assert(content != null || (message != null || title != null)),
        assert(content == null || (message == null && title == null));

  @override
  _FlashbarState createState() => _FlashbarState();
}

class _FlashbarState extends State<Flashbar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = _createAnimation();
    widget.controller?._attach(_dismiss);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onStatusChanged?.call(FlashbarStatus.shown);
      } else if (status == AnimationStatus.reverse) {
        widget.onStatusChanged?.call(FlashbarStatus.dismissing);
      } else if (status == AnimationStatus.dismissed) {
        widget.onStatusChanged?.call(FlashbarStatus.dismissed);
        widget.onDismissed?.call();
      }
    });

    _controller.forward();
    _startTimer();
    widget.onStatusChanged?.call(FlashbarStatus.showing);
  }

  void _startTimer() {
    if (widget.duration != Duration.zero && !widget.persistent) {
      _timer = Timer(widget.duration, _dismiss);
    }
  }

  void _dismiss() {
    if (_controller.status == AnimationStatus.forward ||
        _controller.status == AnimationStatus.completed) {
      _controller.reverse();
      _timer?.cancel();
    }
  }

  Animation<Offset> _createAnimation() {
    final begin =
        widget.gravity == FlashbarGravity.top ? const Offset(0, -1) : const Offset(0, 1);
    return Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    widget.controller?._detach();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildChild() {
    final child = Material(
      color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
      ),
      elevation: widget.shadows != null ? 0 : 4,
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          boxShadow: widget.shadows,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              widget.icon!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: widget.content ??
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: widget.titleTextStyle ??
                              Theme.of(context).textTheme.titleMedium,
                        ),
                      if (widget.message != null)
                        Text(
                          widget.message!,
                          style: widget.messageTextStyle ??
                              Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
            ),
            if (widget.primaryAction != null || widget.secondaryAction != null)
              const SizedBox(width: 12),
            if (widget.primaryAction != null || widget.secondaryAction != null)
              Row(
                children: [
                  if (widget.secondaryAction != null) widget.secondaryAction!,
                  if (widget.primaryAction != null &&
                      widget.secondaryAction != null)
                    const SizedBox(width: 8),
                  if (widget.primaryAction != null) widget.primaryAction!,
                ],
              ),
          ],
        ),
      ),
    );

    if (widget.enableSwipeToDismiss) {
      return Dismissible(
        key: UniqueKey(),
        onDismissed: (_) => _dismiss(),
        direction: widget.gravity == FlashbarGravity.top
            ? DismissDirection.up
            : DismissDirection.down,
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: widget.gravity == FlashbarGravity.top
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        child: SlideTransition(
          position: _animation,
          child: _buildChild(),
        ),
      ),
    );
  }
}

/// Shows a [Flashbar] at the top or bottom of the screen.
///
/// Returns a [FlashbarController] that can be used to dismiss the flashbar.
FlashbarController showFlashbar({
  required BuildContext context,
  String? title,
  String? message,
  Widget? content,
  Widget? icon,
  Widget? primaryAction,
  Widget? secondaryAction,
  Duration duration = const Duration(seconds: 3),
  FlashbarGravity gravity = FlashbarGravity.bottom,
  Color? backgroundColor,
  TextStyle? titleTextStyle,
  TextStyle? messageTextStyle,
  List<BoxShadow>? shadows,
  EdgeInsets padding = const EdgeInsets.all(16.0),
  EdgeInsets margin = const EdgeInsets.all(8.0),
  BorderRadius? borderRadius,
  VoidCallback? onTap,
  Function(FlashbarStatus status)? onStatusChanged,
  bool persistent = false,
  bool enableSwipeToDismiss = false,
  FlashbarController? controller,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  final effectiveController = controller ?? FlashbarController();

  entry = OverlayEntry(
    builder: (context) => Flashbar(
      title: title,
      message: message,
      content: content,
      icon: icon,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
      duration: duration,
      gravity: gravity,
      backgroundColor: backgroundColor,
      titleTextStyle: titleTextStyle,
      messageTextStyle: messageTextStyle,
      shadows: shadows,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      onStatusChanged: onStatusChanged,
      persistent: persistent,
      enableSwipeToDismiss: enableSwipeToDismiss,
      controller: effectiveController,
      onDismissed: () {
        entry.remove();
      },
    ),
  );

  overlay.insert(entry);
  return effectiveController;
}