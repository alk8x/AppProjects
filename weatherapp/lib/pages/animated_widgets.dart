import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration delay;
  final bool shouldAnimate;

  const AnimatedText({
    Key? key,
    required this.text,
    required this.style,
    required this.delay,
    required this.shouldAnimate,
  }) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (widget.shouldAnimate) {
      await Future.delayed(widget.delay);
      if (mounted) {
        _controller.forward();
      }
    }
  }

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldAnimate && !_controller.isAnimating && !_controller.isCompleted) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.5),
              end: Offset(0, 0),
            ).animate(_controller),
            child: child,
          ),
        );
      },
      child: Text(
        widget.text,
        style: widget.style,
      ),
    );
  }
}

class AnimatedLottie extends StatefulWidget {
  final String assetPath;
  final Duration delay;
  final bool shouldAnimate;
  final double size;

  const AnimatedLottie({
    Key? key,
    required this.assetPath,
    required this.delay,
    required this.shouldAnimate,
    this.size = 100.0, // Default size if not provided
  }) : super(key: key);

  @override
  _AnimatedLottieState createState() => _AnimatedLottieState();
}

class _AnimatedLottieState extends State<AnimatedLottie> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    if (widget.shouldAnimate) {
      await Future.delayed(widget.delay);
      if (mounted) {
        _controller.forward();
      }
    }
  }

  @override
  void didUpdateWidget(AnimatedLottie oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldAnimate && !_controller.isAnimating && !_controller.isCompleted) {
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _controller,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.5),
              end: Offset(0, 0),
            ).animate(_controller),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: child,
            ),
          ),
        );
      },
      child: Lottie.asset(widget.assetPath),
    );
  }
}


