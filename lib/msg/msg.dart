import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/sem_registro.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class C6PayNotas extends StatefulWidget {
  var pedido,adm;

  C6PayNotas({
    @required this.pedido,
    @required this.adm,
  });

  @override
  _C6PayNotasState createState() => _C6PayNotasState();
}

class _C6PayNotasState extends State<C6PayNotas> with AutomaticKeepAliveClientMixin<C6PayNotas> {
  FocusScopeNode? currentFocus;
  final pesquisaMsg= TextEditingController();
  TextEditingController nota = TextEditingController();
  var te='',idPedido='';
  Stream? dataList;

  @override
  void dispose() {
    currentFocus!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    idPedido=widget.pedido.id;
    if(idPedido!=''){

      dataList = Dados.databaseReference.collection('msg')
          .where('idPedido', isEqualTo: idPedido).orderBy('dtAtualizado',descending: false).snapshots();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
               onChanged: (value) {
                 setState(() {});
                 },
                controller: pesquisaMsg,
                decoration: InputDecoration(
                    labelText: "Pesquisa",
                    hintText: "Pesquisa",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ),
/*
              Expanded(
                child:StreamBuilder(
                  stream: dataList,
                  builder: (context, snapshot) {
                    if(snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.none: return SemRegistro(tit: 'Ainda não tem nenhuma mensagem');
                      case ConnectionState.waiting: return SemRegistro(tit: 'Aguardando...');
                      case ConnectionState.active:
                        if(snapshot.data!.documents.length>0) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data.documents.length > 0) {
                                  DocumentSnapshot ds = snapshot.data.documents[index];
                                  DateTime dateTime = ds["dtAtualizado"].toDate();

                                  if (pesquisaMsg.text.isEmpty) {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),

                                      child: Card(
                                          color: ds['adm']?Colors.white:Utils.corMsg,
                                          elevation: 5,
                                          child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Texto(tit:ds["msg"],tam:16.0,cor: Utils.corApp,linhas: 5,),
                                                        Texto(tit:DateFormat('dd/MM/yy HH:MM').format(dateTime),tam: 12,),
                                                        SizedBox(height : 10.0),
                                                      ]
                                                  ),
                                                ),
                                              ]
                                          ),
                                        ),

                                    );
                                  } else if (ds["msg"].toLowerCase().contains(pesquisaMsg.text.toLowerCase())) {
                                    return Container(
                                      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      child: Card(
                                        color: ds['adm']?Colors.white:Colors.green,
                                        elevation: 5,
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
                                  } else {
                                    return Container();
                                  }
                                }
                              });
                        }else{
                          return SemRegistro(tit: 'Ainda não tem nenhuma msnsagem');
                        }
                        break;
                    }
                    return null;
                  }),
              ),

 */
              Visibility(
                visible: idPedido!='',
                child:TextField(
                  controller: nota,
                  decoration: InputDecoration(
                      hintText: "Mensagem",
                      suffixIcon: IconButton(
                        onPressed: () {
                          Utils.tiraFocus(currentFocus!);
                          setState(() {
                            if(nota.text!='') {
                              Dados.databaseReference.collection('fin_msg').add({
                                'msg': nota.text,
                                'idPedido':idPedido,
                                'adm':widget.adm,
                                'dtAtualizado':FieldValue.serverTimestamp(),
                              });

                              nota.text = '';
                            }
                          });
                          },
                        icon: Icon(Icons.send),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                  onTap:() {
                    currentFocus = FocusScope.of(context);
                  }
                  ),
              ),
            ],
          ),
    );
  }

  bool get wantKeepAlive {
    return true;
  }
}//176