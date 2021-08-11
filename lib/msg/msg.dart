import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/sem_registro.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class Msg extends StatefulWidget {
  @override
  _MsgState createState() => _MsgState();
}

class _MsgState extends State<Msg> with AutomaticKeepAliveClientMixin<Msg> {
  static final datacount = GetStorage();
  final pesquisaMsg= TextEditingController();
  TextEditingController nota = TextEditingController();
  var te='',idAnuncio='',userId,de,para,titulo;
  Stream? dataList;
  static final foneUser=datacount.read('foneUser');
  static final cidade=datacount.read('cidade');

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    var foneUser=datacount.read('foneUser');
    datacount.write('foneUser',foneUser);
    datacount.write('local','OK');
    Get.offAll(() => AdmPedidos(), arguments: {'foneUser':foneUser,'cidade':cidade,'local':'OK'});
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    titulo=Get.arguments['titulo'] ?? null;
    de=Get.arguments['de'] ?? null;
    para=Get.arguments['para'] ?? null;
    idAnuncio=Get.arguments['idAnuncio'] ?? null;
    userId=datacount.read('idUser');
    if(idAnuncio!=''){
      dataList = Dados.databaseReference.collection('msg')
          .where('idAnuncio', isEqualTo: idAnuncio).orderBy('dtAtualizado',descending: false).snapshots();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Texto(tit:titulo,cor: Colors.white,tam: 16,),
              Texto(tit:para,cor: Colors.white,tam: 14,)
            ]
        ),
        backgroundColor: Utils.corApp,
      ),

      body: Stack(
            children: <Widget>[//SingleChildScrollView
              SingleChildScrollView(
                child:Column(
                    children: <Widget>[
                      //MENSAGENS ****************************************************
                      Column(
              children: <Widget>[
                //PESQUISA ************************************************
                /*
                deixa para quando precisar
                Padding(
                  padding: EdgeInsets.only(top: 5,bottom: 0,left:10,right: 10),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                      },
                    controller: pesquisaMsg,
                    decoration: InputDecoration(
                        labelText: "pesquisa".tr,
                        hintText: "pesquisa".tr,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                  ),
                ),
                 */

                //MENSSAGENS *********************************************
                Padding(
                  padding: EdgeInsets.only(top: 5,bottom: 0,left:5,right: 5),
                  child:StreamBuilder(
                      stream: dataList,
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasError) {
                          return SemRegistro(tit:'msg_no'.tr);
                        }
                        if (!snapshot.hasData) {
                          return SemRegistro(tit:'msg_no'.tr);
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SemRegistro(tit:'aguarde'.tr);
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              DateTime dateTime = ds["dtAtualizado"].toDate();

                              if((ds['de'].toString()==de || ds['para'].toString()==de) && (ds['de'].toString()==para
                                  || ds['para'].toString()==para)) {

                                if (pesquisaMsg.text.isEmpty) {
                                  return mostraMsg(ds, dateTime);
                                } else if (ds["msg"].toLowerCase().contains(
                                    pesquisaMsg.text.toLowerCase())) {
                                  return mostraMsg(ds, dateTime);
                                } else {
                                  return Container();
                                }
                              }else{
                                return Container();
                              }
                            }
                            );
                      }),
                ),
              ]
          ),
                    ]
                ),
              ),
              //DIGITAR A MSG E ENVIAR ****************************************
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 0,bottom: 0,left:5,right: 5),
                  height: 65,
                  color: Colors.white,

                  //width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5,bottom: 5,left:10,right: 10),
                    child:TextField(
                        controller: nota,
                        decoration: InputDecoration(
                            hintText: "Mensagem",
                            suffixIcon: IconButton(
                              onPressed: () {

                                if(nota.text!='') {
                                  Dados.databaseReference.collection('msg').add({
                                    'msg': nota.text,
                                    'idAnuncio':idAnuncio,
                                    'de':de,
                                    'para':para,
                                    'dtAtualizado':FieldValue.serverTimestamp(),
                                  });

                                  FocusScope.of(context).requestFocus(FocusNode());
                                  nota.text = '';
                                }
                              },
                              icon: Icon(Icons.send),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                        onTap:() {
                          // currentFocus = FocusScope.of(context);
                        }
                    ),
                  ),
                ),
              ),
            ]
      ),
    );
  }

  Widget mostraMsg(dynamic ds,DateTime dateTime){
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Card(
       color: ds['de']==userId || ds['de']==foneUser?Utils.corMsg:Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Utils.corApp,
            width: 1.0,
          ),
        ),
        child: Column(
            children: <Widget>[
              ListTile(
                title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Texto(tit:ds["msg"],tam:16.0,cor: Utils.corApp,linhas: 2,),
                      Texto(tit:DateFormat('dd/MM/yy HH:MM').format(dateTime),tam: 12,),
                      SizedBox(height : 10.0),
                    ]
                ),
              ),
            ]
        ),
      ),
    );
  }

  bool get wantKeepAlive {
    return true;
  }
}//176