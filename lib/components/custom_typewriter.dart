import 'package:flutter/material.dart';

class CustomTypewriterText extends StatefulWidget {
  final String text;
  final TextStyle normalTextStyle;
  final TextStyle firstLetterTextStyle;
  final Duration duration;

  const CustomTypewriterText({
    Key? key,
    required this.text,
    required this.normalTextStyle,
    required this.firstLetterTextStyle,
    required this.duration,
  }) : super(key: key);

  @override
  _CustomTypewriterTextState createState() => _CustomTypewriterTextState();
}

class _CustomTypewriterTextState extends State<CustomTypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();

    _characterCount = StepTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
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
        String currentText = widget.text.substring(0, _characterCount.value);
        List<InlineSpan> spans = [];

        for (String word in currentText.split(" ")) {
          if (word.isNotEmpty) {
            spans.add(
              TextSpan(
                text: word[0],
                style: widget.firstLetterTextStyle,
              ),
            );
            spans.add(
              TextSpan(
                text: word.substring(1) + " ",
                style: widget.normalTextStyle,
              ),
            );
          } else {
            spans.add(TextSpan(text: " ", style: widget.normalTextStyle));
          }
        }

        return RichText(
          text: TextSpan(children: spans),
        );
      },
    );
  }
}
