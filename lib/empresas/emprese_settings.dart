import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:get/get.dart';

import 'empresa_settings_itens.dart';

class EmpresaSettings extends StatefulWidget {
  @override
  EmpresaSettingsState createState() => EmpresaSettingsState();
}

class EmpresaSettingsState extends State<EmpresaSettings> with AutomaticKeepAliveClientMixin<EmpresaSettings> {
  static final datacount = GetStorage();
  static final userNome=datacount.read('userNome');
  static final cidade=datacount.read('cidade');
  var foneUser;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
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
    foneUser=datacount.read('foneUser');
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:userNome!=null?'Olá '+userNome:'Olá'),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //PRIMEIRA LINHA ********************************************
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //MINHAS DOAÇÕES ******************************************
                  SizedBox(
                    width: 160,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: BtnLista(tit:'doacao_minhas'.tr,destino: 'minhas_doacoes',tam: 18,ID: '1',
                          icon:Icons.volunteer_activism, iconCor: Colors.red,
                          TB:'anuncio'),
                    ),
                  ),

                  //PERFIL **************************************************
                  SizedBox(
                    width: 160,
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        ),
                      child: BtnLista(tit:'perfil'.tr,destino: 'perfil',tam: 18,ID: '1',
                          icon:Icons.contact_phone_rounded, iconCor: Colors.blue,
                          TB:'usuarios'),
                    ),
                  ),
                ],
              ),
              //SEGUNDA LINHA ********************************************
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //DOAÇÕES SOLICITADAS  *********************************
                  SizedBox(
                    width: 160,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child: BtnLista(tit:'doacao_solicitada'.tr,destino: 'doacoes_solicitadas',tam: 16,ID: '1',
                          icon:Icons.volunteer_activism, iconCor: Utils.corApp,
                          TB:'anuncio'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}