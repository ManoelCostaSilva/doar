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

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:'Olá '+userNome),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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