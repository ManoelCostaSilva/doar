import 'package:flutter/material.dart';
import 'package:doaruser/utils/utils.dart';

class DataFiltro extends StatefulWidget {
  dynamic mask,controle;
  var label,hint,campo;

  DataFiltro({
    @required this.mask,
    @required this.label,
    @required this.hint,
    @required this.campo,
    @required this.controle,
  });

  @override
  _DataFiltroState createState() => _DataFiltroState();
}

class _DataFiltroState extends State<DataFiltro> with SingleTickerProviderStateMixin {
  Color corDataFiltro=Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 5.0),
      child:TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [widget.mask],
        style: TextStyle(color: corDataFiltro),

        onChanged: (String value) {
          String dia=value.substring(0,2);
          String mes=value.substring(3,5);
          setState(() {
            if(value.length<10 || int.parse(dia)>31 || int.parse(dia)<1 || int.parse(mes)>12 || int.parse(mes)<1){
              corDataFiltro=Colors.red;
              final tile = Utils.opcaoFilto.firstWhere((item) => item.campo == widget.campo);
              tile.valor = '';
            }else{
              corDataFiltro=Colors.grey;
              print(widget.campo);
              print(value);
              final tile = Utils.opcaoFilto.firstWhere((item) => item.campo == widget.campo);
              tile.valor = value;
            }
          });
        },
        
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 10.0),

              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            filled: true,
            hintText: widget.hint,
            labelText: widget.label,
            labelStyle: TextStyle(color: corDataFiltro),
            errorStyle: TextStyle(height: 0),
            fillColor: Colors.white70
        ),
        controller: widget.controle,
        validator: (value) {},
      ),
    );
  }
  }