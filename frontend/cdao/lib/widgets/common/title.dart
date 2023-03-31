import 'package:flutter/material.dart';

class TitleWidget extends StatefulWidget {
  double size;
  TitleWidget({required this.size, Key? key}) : super(key: key);

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    final Gradient gradient = LinearGradient(colors: [
      Colors.orange,
      Colors.red.shade900,
    ]);

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        '''Coffee DAO''',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Alonira', color: Colors.orange, fontSize: widget.size),
      ),
    );
  }
}
