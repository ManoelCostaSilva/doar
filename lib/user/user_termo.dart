import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/circular.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_localizacao.dart';

class UserTermo extends StatefulWidget {
  @override
  _UserTermoState createState() => _UserTermoState();
}

class _UserTermoState extends State<UserTermo> {
  var termo = TextEditingController();
  bool mostraCircular=false;
  var term,tipo,anuncio,user;

  inicia()async {
    user =  await Utils.getUserData();
  }

  @override
  void initState() {
    super.initState();
    inicia();
    Dados.campos.clear();
    Dados.prepara(term, 'termo',termo, true);
    anuncio =Get.arguments['anuncio'] ?? null;
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
              child:Texto(tit:'termo'.tr, linhas: 2,),
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
    await Dados.atualizaDados('user',context,user.id);
    user=await Dados.getUserFone(user.fone.toString());
    Utils.setUserData(user);
    Get.offAll(() => UserLocalizacao(), arguments: {'tipo': tipo,'anuncio':anuncio});
  }
}