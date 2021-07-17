import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doaruser/utils/utils.dart';

import 'texto.dart';

class Btn extends StatefulWidget {
  var tit,destino,dados;
  double? tam;
  Color? cor,corTexto;
  bool? negrito;
  dynamic? alin;
  int? linhas;

  Btn({
    this.tit,
    this.tam,
    this.cor,
    this.negrito,
    this.alin,
    this.linhas,
    this.destino,
    this.dados,
    this.corTexto,
  });

  @override
  _BtnState createState() => _BtnState();
}

class _BtnState extends State<Btn> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
      child:OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: widget.cor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Texto(tit:widget.tit,negrito: widget.negrito,tam: widget.tam,cor:widget.corTexto),
        onPressed: () {
          Get.toNamed(widget.destino,arguments: {'dados': widget.dados,});
        },
      ),
    );
  }
}