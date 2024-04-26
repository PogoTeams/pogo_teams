// flutter
import 'package:flutter/material.dart';

// recipio
import '../../app/ui/pogo_colors.dart';
import 'invactive_outlined_button.dart';
import '../../utils/async_state.dart';

class AsyncStatusButton extends StatelessWidget {
  const AsyncStatusButton({
    super.key,
    this.onPressed,
    required this.child,
    required this.status,
    this.successBuilder,
    this.errorBuilder,
    this.resetOnCompleted = true,
    this.resetDuration,
    // TODO - Sizing update
    this.width = double.infinity, //Sizing.formFieldWidth,
    this.height = double.infinity, //Sizing.formFieldHeight,
    this.gradientColors,
    this.borderRadius,
  });

  final void Function()? onPressed;
  final Widget child;
  final AsyncStatus status;
  final Widget Function(BuildContext)? successBuilder;
  final Widget Function(BuildContext)? errorBuilder;
  final bool resetOnCompleted;
  final Duration? resetDuration;
  final double width;
  final double height;
  final Gradient? gradientColors;
  final BorderRadius? borderRadius;

  Widget _buildInk(Widget child) {
    return Ink(
      width: double.maxFinite,
      height: double.maxFinite,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(100.0),
        gradient: gradientColors ??
            const LinearGradient(
              colors: PogoColors.greenGradient,
            ),
      ),
      child: Center(
        child: child,
      ),
    );
  }

  Widget _buildAnimatedContainer(
    double animatedWidth,
    Widget? loadingIndicator,
  ) {
    return AnimatedContainer(
      width: animatedWidth,
      height: height,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeOut,
      child: loadingIndicator ?? _buildButton(),
    );
  }

  Widget _buildButton() {
    return onPressed == null
        ? InactiveOutlinedButton(
            width: width,
            height: height,
            borderRadius: borderRadius,
            child: child,
          )
        : ElevatedButton(
            onPressed: onPressed,
            child: _buildInk(child),
          );
  }

  @override
  Widget build(BuildContext context) {
    double animatedWidth = width;
    Widget? loadingIndicator;
    Widget? overrideWidget;

    if (status.isInProgress) {
      loadingIndicator = _buildInk(const CircularProgressIndicator(
        color: Colors.white,
      ));
      animatedWidth = height;
    } else if (status.isSuccess && successBuilder != null) {
      overrideWidget = successBuilder!(context);
    } else if (status.isFailure && errorBuilder != null) {
      overrideWidget = errorBuilder!(context);
    }

    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 300,
      ),
      child: overrideWidget != null
          ? FutureBuilder(
              future: Future.delayed(resetDuration!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return _buildAnimatedContainer(
                      animatedWidth, loadingIndicator);
                }
                return SizedBox(
                  height: height,
                  width: width,
                  child: Center(
                    child: overrideWidget,
                  ),
                );
              },
            )
          : _buildAnimatedContainer(animatedWidth, loadingIndicator),
    );
  }
}
