import 'dart:async';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/user/user_login.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:doaruser/empresas/emprese_settings.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:get_storage/get_storage.dart';

class AdmPedidos extends StatefulWidget {
  @override
  _AdmPedidosState createState() => _AdmPedidosState();
}

class _AdmPedidosState extends State<AdmPedidos> {
  dynamic dataList;
  TextEditingController editingController = TextEditingController();
  bool mostraCircular=false;
  static final datacount = GetStorage();
  static final tpUser=datacount.read('tipoUser');

  @override
  void dispose() {
    super.dispose();
  }

  void getdadosEmpresa()async{
  }

  Future<dynamic> getPedidos() async {
    dataList = await Dados.databaseReference.collection('man_pedidos').orderBy('dtAtualizado',descending: true).snapshots();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Texto(tit:'bem_vindo'.tr,cor: Colors.white,negrito: true,tam: 18,),
            ),
            IconButton(
              color: Colors.white, icon: new Icon(Icons.settings,),
              onPressed: () {
                Get.to(() => EmpresaSettings(), arguments: {'adm':true});
                },
            )
          ],
        ),
        backgroundColor: Utils.corApp,
      ),

      bottomNavigationBar:BottomAppBar(
        child:Padding(
          padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
          child:OutlinedButton(
            style: Utils.OutlinedButtonStlo(mostraCircular,0),
            child: Texto(tit:'quero_doar'.tr,negrito: true,tam: 17,cor:Colors. white),
            onPressed: () {
              mostraCircular=true;
              Get.to(() => LoginPage(), arguments: {'adm':true});
            },
          ),
        ),
      ),
        /*
        body:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Pesquisa",
                    hintText: "Pesquisa",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ),
            ),
            Expanded(
                child:StreamBuilder(
                  stream: dataList,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return SemRegistro(tit:'Erro inesperado');
                    }

                    if (!snapshot.hasData) {
                      return SemRegistro(tit:'Nenhum fornecedor cadastrado');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SemRegistro(tit:'Aguarde....');
                    }

                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              elevation: 5,
                              color: ds["status"] == 'A' ? Colors.white : Colors.grey,
                              child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      //                                  le   to   ri   bo
                                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 1.0, 5.0),
                                      leading:
                                      Img(tit:ds['img']),
                                      title: Texto(tit:ds["nome"],tam:15.0),
                                      // MENU *******************************
                                      trailing: new Column(
                                        children: <Widget>[
                                          new Container(
                                              child: Utils.menus(ds,context,'man_fornecedor','FornecedorManutencao')
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
          ],
        )

         */
      body:Text('kkkk'),

    );
  }
}