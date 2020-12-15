import 'package:flutter/material.dart';

class ActivityButton extends StatelessWidget {
  final Function function;
  final String title;
  final double intensity;
  ActivityButton({this.function, this.title, this.intensity});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 8,
              color: Colors.grey.shade400,
              spreadRadius: 0,
            ),
          ],
          color: Color(0xff00ADC2).withOpacity(intensity),
        ),
        height: 35,
        width: 95,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget activityButton({title, function}) {
//   return RaisedButton(
//     onPressed: function,
//     color: Color(0xff00ADC2),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(18.0),
//     ),
//     child: Center(
//       child: Text(
//         title,
//         style: TextStyle(
//           color: Colors.white,
//         ),
//       ),
//     ),
//   );
// }
