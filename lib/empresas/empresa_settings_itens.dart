import 'package:doaruser/user/user_login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:get_storage/get_storage.dart';

class BtnLista extends StatefulWidget {
  var tit,destino,ID,TB;
  double? tam;
  Color? cor,iconCor;
  dynamic? icon,anuncios;

  BtnLista({
    this.tit,
    this.tam,
    this.cor,
    this.destino,
    this.ID,
    this.icon,
    this.iconCor,
    this.anuncios,
    this.TB,
  });

  @override
  _BtnListaState createState() => _BtnListaState();
}

class _BtnListaState extends State<BtnLista> with SingleTickerProviderStateMixin {
  static final datacount = GetStorage();
  var userId;
  dynamic anuncios;

  @override
  void initState() {
    userId=datacount.read('idUser');
    anuncios=datacount.read('anuncios');
    print('MANOEL');
    print(anuncios);
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0,left:3,right: 3),
        child:InkWell(
          onTap: () {
            Get.toNamed(widget.destino,arguments: {'id': widget.ID,'dados':widget.anuncios});
          },
          child:Column(
              children: <Widget>[
                IconButton(
                  color: widget.iconCor, icon: new Icon(widget.icon,),
                  onPressed: () {
                    if(widget.destino=='minhas_doacoes'){
                      try{
                        Get.toNamed(widget.destino,arguments: {'TB': widget.TB,'dados':widget.anuncios, 'tit':widget.tit});
                      } catch (e) {
                        Get.to(() => LoginPage(), arguments: {'tipo':'minhas_doacoes'});
                      }
                    }else{
                      Get.toNamed(widget.destino,arguments: {'TB': widget.TB,'anuncios':widget.anuncios, 'tit':widget.tit});
                    }
                  },
                ),
                Texto(tit:widget.tit,tam: widget.tam,cor:Colors.black,linhas: 2,),
                SizedBox(height : 10.0),
              ]
          ),
        )
    );
  }
}