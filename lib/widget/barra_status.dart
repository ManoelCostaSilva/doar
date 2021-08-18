import 'package:flutter/material.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class BarraStatus extends StatefulWidget implements PreferredSizeWidget{
  @override
  Size get preferredSize => const Size.fromHeight(50);
  var tit;
  double? tam;
  Color? cor;
  bool? negrito;
  bool? center;

  BarraStatus({
    this.tit,
    this.tam,
    this.cor,
    this.negrito,
    this.center,
  });

  @override
  _BarraStatusState createState() => _BarraStatusState();
}

class _BarraStatusState extends State<BarraStatus> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.dark,
      titleSpacing: 0,
      centerTitle: widget.center,
      title: Texto(tit:widget.tit,cor: Colors.white,),
      backgroundColor: widget.cor==null?Utils.corApp :widget.cor,
    );
  }
}