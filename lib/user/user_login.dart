import 'package:brasil_fields/brasil_fields.dart';
import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/doacao/minhas_doacoes.dart';
import 'package:doaruser/empresas/emprese_settings.dart';
import 'package:doaruser/user/user_anuncio.dart';
import 'package:doaruser/user/user_localizacao.dart';
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
  var fones,tipo;

  @override
  void initState() {
    super.initState();
    try{
      tipo =Get.arguments['tipo'] ?? null;
    } catch (e) {
      tipo='login';
    }
    Dados.campos.clear();
    Dados.prepara(fones, 'fone',celular, true);
    Dados.prepara(fones, 'local',celular, true);
    Dados.prepara(fones, 'termo',celular, true);
  }

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
      phoneNumber: nroF,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: (AuthCredential authCredential) {
        //GRAVA E VAI PRA PROXIMA PÁGINA
        simula();
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
            Texto(tit:'enviar'.tr,negrito: true,tam: 20,cor:Colors.white,),
            onPressed: () {
              setState(() {
                mostraCircular=true;
              });
             // verifyPhoneNumber(context);
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

            Padding(
              padding: EdgeInsets.only(top: 20,bottom: 0,left:10,right: 10),
              child:Texto(tit:'nao_conect'.tr,tam: 16,),
            ),

            SizedBox(height: 80.0,),

            Texto(tit:'nro_cell'.tr,tam: 18,),

            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 0,left:5,right: 5),
              child: Edit(hint: '(99) 9 9999-9999',controle: celular,input: TextInputType.phone,campo: 'fone',
              icon: Icons.phone_iphone,corIcone: Utils.corApp,tamFont: 20,
                  mask: FilteringTextInputFormatter.digitsOnly, mask1: TelefoneInputFormatter()),),
          ],
        ),
      ),
    );
  }

  void simula() async{
    if(celular.text==''){
      Utils.snak('atencao'.tr, 'fone_inf'.tr, true, Colors.red);
      return;
    }

    var user=await Dados.getUserFone(celular.text);

    if(user==null){
      await Dados.inserirUser(celular.text);
      datacount.write('foneUser',celular.text);
      datacount.write('termoOk','NAO');
      datacount.write('local','NAO');
      Get.offAll(() => UserTermo(), arguments: {'tipo':tipo});
    }else{
      datacount.write('foneUser',celular.text);
      datacount.write('idUser',user.id);
      if(user['termo']!='Aceito'){
        Get.offAll(() => UserTermo(), arguments: {'tipo':tipo});
      }else{
        datacount.write('termoOk','SIM');
        if(user['ufId']==''){
          Get.offAll(() => UserLocalizacao(), arguments: {'tipo':tipo});
        }else{
          datacount.write('local','OK');
          switch(tipo) {
            case 'doar'://DOAR ***********************************************
              Get.offAll(() => UserAnuncio(), arguments: {'primeiraVez': true});
              break;
            case 'configuracoes': //CONFIGURAÇÕES ****************************
              Get.offAll(() => EmpresaSettings(), arguments: {'primeiraVez': true});
              break;
            case 'aceitar': // ACEITAR ***************************************
              var idDoacao=datacount.read('idDoacao');
              Dados.solicitarDoacao(idDoacao,celular.text);
              Get.offAll(() => AdmPedidos(), arguments: {'foneUser':celular.text,'cidade':user['cidadeId'],'local':'OK'});
              break;
          }
        }
      }
    }
  }
}