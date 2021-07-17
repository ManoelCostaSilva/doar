import 'package:flutter/material.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/texto.dart';

class wRamoAtividade extends StatefulWidget {
  var tit;
  dynamic currentFocus;
  double? tam;
  Color? cor;
  int? linhas;
  
  wRamoAtividade({
    @required this.tit,
    @required this.tam,
    @required this.cor,
    @required this.linhas,
    @required this.currentFocus,
  });

  @override
  _wRamoAtividadeState createState() => _wRamoAtividadeState();
}

class _wRamoAtividadeState extends State<wRamoAtividade> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return   Container(
      margin: EdgeInsets.all(10) ,
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Utils.corApp),
        borderRadius: BorderRadius.circular(14.0),
      ),
      width: MediaQuery.of(context).size.width, height: 50,
      child:OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            backgroundColor: Utils.corApp,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: Texto(tit: widget.tit,tam: 15.0,),
        onPressed: () {
          ramo(context);
        },
      ),

    );
  }

  ramo(BuildContext context) async{
    /*
    final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => RamoPesquisa(dados: null)));

    if (nmServ != null) {
      setState(() {
        var comVr = nmServ.toString().split('#');
        Utils.tiraFocus(widget.currentFocus);
        widget.tit = comVr[1];
        Utils.setDadosParaGravaCliente('idRamoAtividade', comVr[0]);
        Utils.setDadosParaGravaCliente('ramoAtividade', comVr[1]);

      });
    }

     */



  }
}