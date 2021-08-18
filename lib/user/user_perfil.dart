import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:doaruser/adm/lista_cidades.dart';
import 'package:doaruser/adm/lista_uf.dart';
import 'package:doaruser/cep/municipios.dart';
import 'package:doaruser/dados/campos_cidades.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/empresas/emprese_settings.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/circular.dart';
import 'package:doaruser/widget/edit.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPerfil extends StatefulWidget {
  @override
  _UserLocalizacaoState createState() => _UserLocalizacaoState();
}

class _UserLocalizacaoState extends State<UserPerfil> {
  var user;
  var nome = TextEditingController();
  var tmp = TextEditingController();
  var localizacao,ufEscolhida='uf'.tr,cidadeEscolhida='';
  bool mostraCircular=false;
  String ufID='',cidadeId='';

  inicia()async {
    user =  await Utils.getUserData();
    if (user!.ufId != null) {
      setState(() {
        ufEscolhida = user.ufNome;
        cidadeEscolhida = user.cidadeNome;
        ufID = user.ufId;
        cidadeId = user.cidadeId;
        nome.text=user.nome==null?'':user.nome;
      });
    }
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Get.offAll(() => EmpresaSettings(), arguments: {});
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    inicia();
    BackButtonInterceptor.add(myInterceptor);
    Dados.campos.clear();
    Dados.prepara(localizacao, 'nome',nome, true);
    Dados.prepara(localizacao, 'cidadeId',tmp, true);
    Dados.prepara(localizacao, 'cidadeNome',tmp, true);
    Dados.prepara(localizacao, 'ufId',tmp, true);
    Dados.prepara(localizacao, 'ufNome',tmp, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:'perfil'.tr,center: false,),
        bottomNavigationBar:BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child:OutlinedButton(
              style: Utils.OutlinedButtonStlo(false,0),
              child: mostraCircular?Circular():Texto(tit:'enviar'.tr,negrito: true,tam: 17,cor:Colors. white),
              onPressed: () {
                enviar();
                },
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 0, left: 0, right: 0),
                    child: Texto(tit:'nome_opcional'.tr,tam: 18,),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 10),
                    child: Edit(hint: 'Ex.: Pedro'.tr,controle: nome,campo: 'nome',),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
                    child: TextButton.icon(
                      style: Utils.TextButtoniconStyle(5),
                      icon: Icon(Icons.place_outlined), // Your icon here
                      label: Text(ufEscolhida), // Your text here
                      onPressed: (){getUf();},
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
                    child: Texto(tit:cidadeEscolhida,tam: 18,),
                  ),

                ],
              )
        )
    );
  }

  void enviar()async{
    if(ufID=='' || cidadeId==''){
      Utils.snak('atencao'.tr, 'informe_ufCidade'.tr, true, Colors.red);
      return;
    }
    setState(() {
      mostraCircular=true;
    });
    Dados.setDadosParaGravaCliente('nome', nome.text);
    Dados.setDadosParaGravaCliente('cidadeId', cidadeId);
    Dados.setDadosParaGravaCliente('cidadeNome', cidadeEscolhida);
    Dados.setDadosParaGravaCliente('ufId', ufID);
    Dados.setDadosParaGravaCliente('ufNome', ufEscolhida);
    await Dados.atualizaDados('user', context, user.id);

    var userAtualizado=await Dados.getUserFone(user.fone.toString());
    Utils.setUserData(userAtualizado);

    //var myClassObject = new EmpresaSettingsState();
    //myClassObject.userNome =nome.text;

    setState(() {
      //EmpresaSettingsState.userNome=nome.text;
      mostraCircular=false;
    });
  }

  void getUf()async{
    setState(() {
      mostraCircular=true;
    });
    final ufVolta = await Get.to(() => ListaUf(),);
    if (ufVolta != null) {
      var ufs = ufVolta.toString().split('#');
      ufID=ufs[0];
      ufEscolhida=ufs[1];
      getMunicipo(ufs[0]);
    }
  }

  getMunicipo(String UF)async{
    print(UF);
    var municipios = await Municipios.getMunicipio(municipio: UF);
    Dados.camposCidades.clear();
    for (var x = 0; x < municipios.length; x++) {
      Dados.camposCidades.add(CamposCidades(municipios[x].nome,municipios[x].id.toString(),),);
    }
    final cidadeVolta = await Get.to(() => ListaCidades(), arguments: {'UF':ufEscolhida});
    if (cidadeVolta != null) {
      setState(() {
        var cidade = cidadeVolta.toString().split('#');
        cidadeEscolhida = cidade[1];
        cidadeId =cidade[0];
        mostraCircular=false;
      });
    }
  }
}