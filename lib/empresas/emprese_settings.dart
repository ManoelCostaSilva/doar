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

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:'Olá Henrique'),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BtnLista(tit:'categorias'.tr,destino: 'categorias_lista',tam: 18,ID: '1',
                      icon:Icons.album_outlined, iconCor: Colors.blue,
                    TB:'categorias'),
                  ),
                  Expanded(
                    child: BtnLista(tit:'usuarios'.tr,destino: 'usuarios_lista',tam: 18,ID: '1',
                        icon:Icons.contact_phone_rounded, iconCor: Colors.blue,
                        TB:'usuarios'),
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