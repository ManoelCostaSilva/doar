import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:meta/meta.dart';

class Edit extends StatefulWidget {
  dynamic? controle,input,mask,mask1,alinhamento,icon;
  var label,hint,campo;
  double? tamFont;
  Color? corFonte,corIcone;
  int? linhas;

  Edit({
     this.label,
     this.hint,
     this.campo,
     this.controle,
     this.input,
     this.mask,
     this.mask1,
     this.tamFont,
     this.corFonte,
     this.linhas,
     this.alinhamento,
     this.icon,
     this.corIcone,
  });

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> with SingleTickerProviderStateMixin {
  Color cor=Colors.grey;

  @override
  void initState() {
    if(widget.corFonte!=null) {
      cor = widget.corFonte!;
    }else{
      cor=Colors.black;
    }
    super.initState();
  }

  @override
  void dispose() {super.dispose();}

  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0,horizontal: 5.0),

      child:TextFormField(
        keyboardType: widget.input!=null?widget.input:null,
        inputFormatters: widget.mask==null?null:widget.mask1==null?[widget.mask]:[widget.mask,widget.mask1],
        style: TextStyle(color: cor,fontSize: widget.tamFont),
        maxLines: widget.linhas,
        textAlign: widget.alinhamento==null?TextAlign.left:widget.alinhamento,
        onChanged: (String value) {
          Dados.setDadosParaGravaCliente(widget.campo, value);

          if(widget.label=='CPF') {
            setState(() {
              if(UtilBrasilFields.isCPFValido(value)){
                cor=Colors.black;
              }else{
                cor=Colors.red;
              }
            });
          }else{
            if(widget.label=='CNPJ'){
              setState(() {
                if(UtilBrasilFields.isCPFValido(value)){
                  cor=Colors.black;
                }else{
                  cor=Colors.red;
                }
              });
            }
          }
        },

        decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: BorderSide(color: Utils.corApp, width: 10.0),
              borderRadius: const BorderRadius.all(
                const Radius.circular(10.0),
              ),
            ),
            filled: true,
            hintText: widget.hint,
            labelText: widget.label,
            labelStyle: TextStyle(color: cor),
            fillColor: Colors.white70,
            prefixIcon: widget.icon!=null?Icon(widget.icon, color: widget.corIcone,):null,
        ),
        controller: widget.controle,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo obrigatório';
           }
          return null;
        },
      ),
    );
  }
}