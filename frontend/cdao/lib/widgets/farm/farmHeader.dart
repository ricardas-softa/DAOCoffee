import 'package:flutter/material.dart';

class FarmHeader extends StatelessWidget {
  const FarmHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    final Gradient gradient = LinearGradient(colors: [
      // const Color.fromARGB(255, 1, 207, 183),
      Colors.orange,
      Colors.red.shade900,
    ]);
    const Gradient gradient2 = LinearGradient(colors: [
      Color.fromARGB(255, 1, 207, 183),
      Colors.orange,
      // Colors.red.shade900,
    ]);
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image.asset('lib/assets/images/coffee_picking_crew_1.png',
            // height: 250,
            width: mWidth,
            fit: BoxFit.contain,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: mWidth,
          child: Center(
            child: Column(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => gradient2.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    '''Village Of''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Alonira', 
                        fontWeight: FontWeight.bold,
                        color: Colors.orange, 
                        fontSize: mWidth < 753 ? 20 : mWidth < 1225 && mWidth >= 753 ? 20 : 40), //1225
                  ),
                ),
                SizedBox(height: mWidth < 753 ? mWidth/3 - 25 : mWidth < 1225 && mWidth >= 753 ? mWidth/3 + 20 : mWidth/7 * 2 + 75,),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => gradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Text(
                    '''Los Hornos''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Alonira', 
                        fontWeight: FontWeight.bold,
                        color: Colors.orange, 
                        fontSize: mWidth < 753 ? 40 : mWidth < 1225 && mWidth >= 753 ? 60 : 100),
                  ),
                ),
                Text('''Comayagua, Honduras''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: mWidth < 753 ? 15 : mWidth < 1225 && mWidth >= 753 ? 30 : 40,
                      color: Colors.orange
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}