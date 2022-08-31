import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  ProgressDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Container(
          // margin: EdgeInsets.all(15),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/gif/login_page.gif'),
              fit: BoxFit.fill,
            ),
            borderRadius: BorderRadius.circular(100),
          ),
        ));
  }
}
