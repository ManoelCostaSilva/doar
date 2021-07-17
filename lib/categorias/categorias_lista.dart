import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/widget/img.dart';
import 'package:flutter/material.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/sem_registro.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:get/get.dart';

class CategoriasLista extends StatefulWidget {
  @override
  _CategoriasListaState createState() => _CategoriasListaState();
}

class _CategoriasListaState extends State<CategoriasLista> with AutomaticKeepAliveClientMixin<CategoriasLista> {
  Stream? dataList;
  var tit,TB,url;

  @override
  void initState() {
    tit =Get.arguments['tit'] ?? null;
    TB ='categorias';
    dataList = Dados.databaseReference.collection(TB).orderBy('nome').snapshots();
    url='https://firebasestorage.googleapis.com/v0/b/beleza-b3e97.appspot.com/o/DOC%2FLh9uevbhCWLkVvRuamAC.jpeg?alt=media&token=83b8abcf-9a9c-4430-94b6-57745dffe878';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BarraStatus(tit:tit),
      body: Column(
        children: <Widget>[
          Expanded(
            child:dataList==null?SemRegistro(tit:tit+' sem_dados'.tr):

            StreamBuilder(
              stream: dataList,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return SemRegistro(tit:'erro_inesperado'.tr);
                }

                if (!snapshot.hasData) {
                  return SemRegistro(tit:tit+' sem_dados'.tr);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SemRegistro(tit:'aguarde'.tr);
                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return Padding(
                        padding:EdgeInsets.fromLTRB(0.0, 5.0, 1.0, 5.0) ,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 6,
                          color: ds["status"] == 'A' ? Colors.white : Colors.grey,
                          child: Column(
                              children: <Widget>[
                                ListTile(
                                  dense:true,
                                  //                                  le   to   ri   bo
                                  contentPadding: EdgeInsets.fromLTRB(1.0, 5.0, 1.0, 5.0),
                                  leading: Img(tit:ds['img']==''?url:ds['img'],tam: 50,),
                                  title: Texto(tit:ds["nome"],tam:15.0),
                                  // MENU *******************************
                                  trailing: new Column(
                                    children: <Widget>[
                                      new Container(
                                          child: Utils.menus(ds,context,TB,'categorias',tit,'')
                                      )
                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          Utils.execute(context,tit,TB,'categorias'),
          SizedBox(height : 10.0),
        ],
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}