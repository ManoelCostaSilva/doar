import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'msg.dart';

class MsgSolicitantes extends StatefulWidget {
  @override
  _MsgSolicitantesState createState() => _MsgSolicitantesState();
}

class _MsgSolicitantesState extends State<MsgSolicitantes> with AutomaticKeepAliveClientMixin<MsgSolicitantes> {
  static final datacount = GetStorage();
  var anuncio,solicitantes;
  static final foneUser2=datacount.read('foneUser');
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
    anuncio=Get.arguments['anuncio'] ?? null;
    solicitantes = anuncio['solicitantes'].toString().split('#');
    datacount.write('foneUser',foneUser2);
    datacount.write('local','OK');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BarraStatus(tit:anuncio['titulo']),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 18, right: 10),
            child:Texto(tit:'Escolha um solicitante abaixo para enviar uma mensagem',tam: 16,),
          ),
          Expanded(
            child:ListView.builder(
                itemCount: solicitantes.length-1,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 0, left: 10, right: 10),
                    child: InkWell(
                        onTap: () {
                          Get.to(() => Msg(),
                              arguments: {'titulo': anuncio['titulo'],'de': anuncio['userId']
                                ,'para': solicitantes[index],'idAnuncio': anuncio.id,}
                              );
                        },
                        child:Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Utils.corApp,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(solicitantes[index]),
                          ),
                        )
                    ),
                  );
                }),
          ),
        ],
      )
    );
  }
  @override
  bool get wantKeepAlive => true;
}