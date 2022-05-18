import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String msg;
  final Color color;
  final void Function()? func;


  const RoundedButton({
    Key? key,
    required this.msg,
    required this.color,
    required this.func,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: func,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            msg,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
