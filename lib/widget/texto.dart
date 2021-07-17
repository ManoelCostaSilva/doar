import 'package:flutter/material.dart';

class Texto extends StatefulWidget {
  var tit;
  double? tam;
  Color? cor;
  bool? negrito;
  dynamic? alin;
  int? linhas;

  Texto({
    this.tit,
    this.tam,
    this.cor,
    this.negrito,
    this.alin,
    this.linhas,
  });

  @override
  _TextoState createState() => _TextoState();
}

class _TextoState extends State<Texto> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return   Text(widget.tit,
      textAlign: widget.alin,
      maxLines: widget.linhas==null?1:widget.linhas,
      style: TextStyle(
          fontWeight: widget.negrito==null?FontWeight.normal:widget.negrito!?FontWeight.bold:FontWeight.normal,
          color: widget.cor,
          fontSize: widget.tam,
      ),
    );
  }
}