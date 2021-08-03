import 'package:brasil_fields/brasil_fields.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/circular.dart';
import 'package:doaruser/widget/edit.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DoacaoTermo extends StatefulWidget {
  @override
  _UserTermoState createState() => _UserTermoState();
}

class _UserTermoState extends State<DoacaoTermo> {
  var termo = TextEditingController();
  var cpf = TextEditingController();
  static final datacount = GetStorage();
  bool mostraCircular=false;
  static final idUser=datacount.read('idUser');
  var term;

  @override
  void initState() {
    super.initState();
    Dados.campos.clear();
    Dados.prepara(term, 'termo',termo, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BarraStatus(tit:'doacao'.tr,),
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
            Texto(tit:'termos_doar'.tr,cor: Utils.corApp,tam: 20,negrito: true,),

            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 0,left:10,right: 10),
              child:Texto(tit:'Todas as tratativas devem ser feitas diretamente entre o doador e você. Esse APP não assume nenhuma responsabilidade pela doação.\n Por questÕes de segurança precisamos que você informe seu CPF, querá exibido para o doador.',

              linhas: null,),
            ),

            Edit(label: 'cpf'.tr,hint: 'cpf'.tr,controle: cpf,mask: FilteringTextInputFormatter.digitsOnly,
              mask1: CpfInputFormatter(),input:TextInputType.number ,campo: 'cpf',),

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
    bool valida=UtilBrasilFields.isCPFValido(cpf.text);
    await Dados.atualizaDados('user',context,idUser);
    datacount.write('termoOk','OK');
    //Get.offAll(() => UserLocalizacao(), arguments: {'adm':true});
    //Grava no banco
  }
}