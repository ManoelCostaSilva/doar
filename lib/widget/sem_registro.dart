import 'package:flutter/material.dart';

class SemRegistro extends StatefulWidget {
  var tit;

  SemRegistro({
    @required this.tit,
  });

  @override
  _SemRegistroState createState() => _SemRegistroState();
}

class _SemRegistroState extends State<SemRegistro> with SingleTickerProviderStateMixin {

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return  Center(
      child:Text(widget.tit,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15.0,
          color: Colors.grey,
        ),),
    );
  }
}