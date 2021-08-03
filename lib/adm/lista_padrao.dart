import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/user/user_anuncio.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/img.dart';
import 'package:doaruser/widget/sem_registro.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListaPadrao extends StatefulWidget {
  @override
  _ListaPadraoState createState() => _ListaPadraoState();
}

class _ListaPadraoState extends State<ListaPadrao> with AutomaticKeepAliveClientMixin<ListaPadrao> {
  Stream? dataList;
  var tit,TB;

  @override
  void initState() {
    tit =Get.arguments['tit'] ?? null;
    TB =Get.arguments['TB'] ?? null;

    dataList = Dados.databaseReference.collection(TB).orderBy('nome').snapshots();
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
                      return InkWell(
                        onTap: () {
                          Get.back(result: ds['nome']+'#'+ds.id);
                          },
                        child:Padding(
                          padding:EdgeInsets.fromLTRB(0.0, 5.0, 1.0, 5.0) ,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            elevation: 6,
                            child: ListTile(
                              dense:true,
                              //                                  le   to   ri   bo
                              contentPadding: EdgeInsets.fromLTRB(0.0, 5.0, 1.0, 5.0),
                              leading: Transform.translate(
                                offset: Offset(-15, 0),
                                child: Img(tit:ds['img']),
                              ),

                              title: Transform.translate(
                                offset: Offset(-40, 0),
                                child: Texto(tit:ds["nome"],tam:15.0),
                              )
                            ),
                          ),
                        ),
                      );
                    });
                },
            ),
          ),
        ],
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}