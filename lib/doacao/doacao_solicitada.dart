import 'dart:async';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/sem_registro.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doaruser/widget/texto.dart';

class DoacoesSolicitadas extends StatefulWidget {
  @override
  MinhasDoacoesState createState() => MinhasDoacoesState();
}

class MinhasDoacoesState extends State<DoacoesSolicitadas> {
  dynamic dataList;
  var user;
  String doadoPara='';
  var vazio='https://firebasestorage.googleapis.com/v0/b/beleza-b3e97.appspot.com/o/DOC%2FNE8etfleO61F2teGzimR.jpeg?alt=media&token=9ce1035e-777e-4f1c-b7ea-fc9f7512164b';

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Get.offAll(() => AdmPedidos(), arguments: {});
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> getAnuncios() async {
    dataList =await Utils.datacount.read('anuncios');
    setState(() {});
  }

  inicia()async {
    user =  await Utils.getUserData();
    getAnuncios();

  }

  @override
  void initState() {
    inicia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:'doacao_solicitada'.tr),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: dataList,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return SemRegistro(tit:'erro_inesperado'.tr);
                  }

                  if (!snapshot.hasData) {
                    return SemRegistro(tit: 'sem_dados'.tr);
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SemRegistro(tit:'aguarde'.tr);
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        DateTime dateTime = ds["dtCriado"].toDate();
                        DateTime dtAlterado = ds["dtAlterado"].toDate();
                        if(ds['doadoPara']=='NINGUEM'){
                          //corData=Colors.black;
                          doadoPara='';
                        }else{
                          doadoPara='DOADO';
                         // corData=Colors.red;
                        }

                        if(ds['solicitantes'].toString().contains(user.fone)) {
                          return Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, bottom: 0, left: 3, right: 3),
                                  child: Card(
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: Utils.corApp, width: 2.0,
                                      ),
                                    ),

                                    child: Container(
                                      child: Column(
                                          children: <Widget>[
                                            //IMAGEM E TÍTULO
                                            Transform.translate(
                                              offset: Offset(5, 0),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    //IMAGEM*************************************
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 10, bottom: 0, left: 5, right: 0),
                                                      child: Container(
                                                        width: 85,
                                                        height: 85,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                              image: ds['img'] == '' ? NetworkImage(vazio)
                                                                  : NetworkImage(ds['img']),
                                                              fit: BoxFit.fill,
                                                            ),
                                                            borderRadius: BorderRadius.all(Radius.circular(40))
                                                        ),
                                                      ),
                                                    ),

                                                    //TÍTULO ***********************************
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 0, bottom: 10, left: 08, right: 0),
                                                      child: Texto(tit: ds["titulo"], tam: 16.0),
                                                    ),
                                                  ]
                                              ),
                                            ),

                                            //DATA, LIXEIRA E SETINHA
                                            Transform.translate(
                                              offset: Offset(18, -40),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[

                                                      //DATA*******************************
                                                      Transform.translate(
                                                        offset: Offset(85, 0),
                                                        child: Container(
                                                          child: Texto(
                                                            tit: DateFormat('dd/MM/yy hh:mm').format(dateTime) + ' ' + doadoPara,
                                                            tam: 12, negrito: true,),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                              ),
                                            ),

                                            //DESCRIÇÃO
                                            Transform.translate(
                                              offset: Offset(15, -10),
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 0, bottom: 00, left: 00, right: 30),
                                                child: Texto(tit: ds['descricao'], linhas: null, cor: Colors.grey,),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                          );
                        }else{
                          return Container();
                        }
                      }
                  );
                },
              ),
            ),
          ],
        )
    );
  }

}