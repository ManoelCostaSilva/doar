import 'package:brasil_fields/brasil_fields.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/circular.dart';
import 'package:doaruser/widget/edit.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserTermo extends StatefulWidget {
  @override
  _UserTermoState createState() => _UserTermoState();
}

class _UserTermoState extends State<UserTermo> {

  static final datacount = GetStorage();
  bool mostraCircular=false;

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
            Texto(tit:'concordo'.tr,negrito: true,tam: 20,cor:Colors.green,),
            onPressed: () {
              simula();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Texto(tit:'autenticacao'.tr,cor: Utils.corApp,tam: 30,negrito: true,),

            SizedBox(height: 80.0,),

            Texto(tit:'nro_cell'.tr,tam: 18,),

            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 0,left:5,right: 5),
              child: Edit(hint: '(99) 9 9999-9999',controle: celular,input: TextInputType.phone,
              icon: Icons.phone_iphone,corIcone: Utils.corApp,tamFont: 20,
                  mask: FilteringTextInputFormatter.digitsOnly, mask1: TelefoneInputFormatter()),),
          ],
        ),
      ),
    );
  }
  void simula() async{
    setState(() {
      mostraCircular=true;
      //verifyPhoneNumber(context);
    });

    var user=await Dados.getUserFone(celular.text);

    if(user==null){
      await Dados.inserirUser(celular.text);
    }else{
      print('TEM');
    }
    datacount.write('foneUser',celular.text);
    datacount.write('termoOk','NAO');
    //Grava no banco
  }
}