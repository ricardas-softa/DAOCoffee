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
    final Gradient gradient =  LinearGradient(colors: [
      // Color.fromARGB(255, 29, 126, 65),
      Color.fromARGB(255, 233, 171, 105),
      Color.fromARGB(255, 154, 80, 16),
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
