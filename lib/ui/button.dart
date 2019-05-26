import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({@required this.onPressed, this.text, this.height, this.width, this.gradient});
  final GestureTapCallback onPressed;
  final String text;
  final Gradient gradient;
  final double height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
      ),
      child:RawMaterialButton(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle( 
              color: Colors.white,
              fontSize: 15  
              ),
            ),
          ],
        ),
        shape: StadiumBorder(),
        onPressed: onPressed
      ),
    );
  }
}