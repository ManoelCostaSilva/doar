import 'package:brasil_fields/brasil_fields.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/user/user_termo.dart';
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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var celular = TextEditingController();
  static final datacount = GetStorage();
  bool mostraCircular=false;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    if(celular.text==''){
      Utils.snak('atencao'.tr, 'nro_cell'.tr, true, Colors.red);
      setState(() {
        mostraCircular=false;
      });
      return;
    }
    String nroF=celular.text;
    nroF=nroF.replaceAll('(', '');
    nroF=nroF.replaceAll(')', '');
    nroF=nroF.replaceAll('-', '');
    nroF='+55 '+nroF;

    await FirebaseAuth.instance.verifyPhoneNumber(
      //phoneNumber: '+55 41 99999--7777',
      phoneNumber: nroF,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: (AuthCredential authCredential) {
        //GRAVA E VAI PRA PROXIMA PÁGINA
        datacount.write('tipoUser','ADM');
      },

      verificationFailed: (FirebaseAuthException authException) {
        Utils.snak('check_auth'.tr, 'no_auth'.tr, true, Colors.red);
        setState(() {
          mostraCircular=false;
        });
      },

      codeSent: (String verId, [int? forceCodeResent]) {},

      codeAutoRetrievalTimeout: (String verId) {
        Utils.snak('check_auth'.tr, 'no_auth'.tr, true, Colors.red);
        setState(() {
          mostraCircular=false;
        });
      },
    );
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
            Texto(tit:'enviar'.tr,negrito: true,tam: 20,cor:Colors.green,),
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
    //apaga todas as rotas anteriores
    Get.offAll(() => UserTermo(), arguments: {'adm':true});


    //Grava no banco
  }
}