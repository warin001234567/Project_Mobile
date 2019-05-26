import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({@required this.onPressed, this.text, this.height, this.width});
  final GestureTapCallback onPressed;
  final String text;
  final double height, width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child:RawMaterialButton(
        fillColor: Color.fromRGBO(125, 145, 193, 0.8),

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