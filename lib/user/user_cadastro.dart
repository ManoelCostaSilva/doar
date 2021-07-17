import 'package:doaruser/cep/services/via_cep_service.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/edit.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCadastro extends StatefulWidget {
  @override
  _UserCadastroState createState() => _UserCadastroState();
}

class _UserCadastroState extends State<UserCadastro> {
  final globalKey = GlobalKey<ScaffoldState>();
  var titulo = TextEditingController();
  var descricao = TextEditingController();
  var categoria = TextEditingController();
  var zip = TextEditingController();

  @override
  void initState() {
    super.initState();
    Dados.campos.clear();
    //Dados.prepara(fones, 'fone',nroFone, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:'autenticacao'.tr),
        bottomNavigationBar:BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child:OutlinedButton(
              style: Utils.OutlinedButtonStlo(false,0),
              child: Texto(tit:'enviar'.tr,negrito: true,tam: 17,cor:Colors. white),
              onPressed: () {
                //phoneNumberVerification();
              },
            ),
          ),
        ),
        key: globalKey,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Edit(label: 'titulo'.tr,hint: 'titulo'.tr,controle: titulo,campo: 'titulo',),
                  Edit(label: 'descricao'.tr,hint: 'descricao'.tr,controle: descricao,campo: 'descricao',),
                  Edit(label: 'categorias'.tr,hint: 'categorias'.tr,controle: categoria,campo: 'categoria',),
                  Edit(label: 'cep'.tr,hint: 'cep'.tr,controle: zip,campo: 'cep',),
                ],
              )),
        ));
  }

  Future _searchCep() async {
    final resultCep = await ViaCepService.fetchCep(cep: zip.text);
    print(resultCep.localidade); // Exibindo somente a localidade no terminal

    //setState(() {
      //_result = resultCep.toJson();
   // });
  }
}