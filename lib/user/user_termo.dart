import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/circular.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'user_localizacao.dart';

class UserTermo extends StatefulWidget {
  @override
  _UserTermoState createState() => _UserTermoState();
}

class _UserTermoState extends State<UserTermo> {
  var termo = TextEditingController();
  static final datacount = GetStorage();
  bool mostraCircular=false;
  static final idUser=datacount.read('idUser');
  var term,tipo,foneUser;

  @override
  void initState() {
    super.initState();
    Dados.campos.clear();
    Dados.prepara(term, 'termo',termo, true);
    tipo =Get.arguments['tipo'] ?? null;
    foneUser=datacount.read('foneUser');
    print('NO TERMO');
    print(foneUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:BottomAppBar(
        child:Padding(
          padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),

          child:OutlinedButton(
            style: Utils.OutlinedButtonStlo(mostraCircular,0),
            child:mostraCircular?Circular():
            Texto(tit:'concordo'.tr,negrito: true,tam: 20,cor:Colors.white,),
            onPressed: () {
              concordo();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 40.0,),
            Texto(tit:'termos'.tr,cor: Utils.corApp,tam: 20,negrito: true,),

            SizedBox(height: 10.0,),

            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 0,left:10,right: 10),
              child:Texto(tit:'Aqui ficará o termo de uso que o usuário é obrigado a aceitar, caso não aceite não poderá fazer anúncios no app'
                  ,
              linhas: 2,),
            ),
          ],
        ),
      ),
    );
  }
  void concordo() async{
    setState(() {
      mostraCircular=true;
    });
    Dados.setDadosParaGravaCliente('termo', 'Aceito');
    await Dados.atualizaDados('user',context,idUser);
    datacount.write('termoOk','OK');

    //if(tipo!='doar') {
      Get.offAll(() => UserLocalizacao(), arguments: {'tipo': tipo});
    //}else{
      //Get.offAll(() => AdmPedidos(), arguments: {'adm': true});
   // }

  }
}