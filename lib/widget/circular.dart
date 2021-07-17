import 'package:flutter/material.dart';

class Circular extends StatefulWidget {
  var tit;

  Circular({
    this.tit,
  });

  @override
  _CircularState createState() => _CircularState();
}

class _CircularState extends State<Circular> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
        child:
        SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(),
        )
    );
  }
}