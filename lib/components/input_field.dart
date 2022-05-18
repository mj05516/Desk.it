import 'package:flutter/material.dart';

import 'package:taskit/constants.dart';

class InputField extends StatelessWidget {
  final String msg;
  final void Function(String)? func;
  final bool pass;
  final TextInputType keyboard;
  final Widget icon;

  const InputField({
    Key? key,
    required this.msg,
    required this.func,
    required this.pass,
    required this.keyboard,
    required this.icon,
  }) : super(key: key);
  
      

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: this.keyboard,
      obscureText: this.pass,
      onChanged: this.func,
      decoration: kInputFieldDec.copyWith(
        hintText: msg,
        prefixIcon: icon,
      ),
    );
  }
}

