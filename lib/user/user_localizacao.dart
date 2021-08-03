import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/adm/lista_cidades.dart';
import 'package:doaruser/adm/lista_uf.dart';
import 'package:doaruser/cep/municipios.dart';
import 'package:doaruser/dados/campos_cidades.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/user/user_anuncio.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/edit.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserLocalizacao extends StatefulWidget {
  @override
  _UserLocalizacaoState createState() => _UserLocalizacaoState();
}

class _UserLocalizacaoState extends State<UserLocalizacao> {
  static final datacount = GetStorage();
  var nome = TextEditingController();
  var tmp = TextEditingController();
  var localizacao,ufEscolhida='uf'.tr,cidadeEscolhida='';
  bool mostraCircular=false;
  String ufID='',cidadeId='';
  static final idUser=datacount.read('idUser');
  static final cidadeNome=datacount.read('cidadeNome');
  static final ufNome=datacount.read('uf');
  static final userNome=datacount.read('userNome');

  @override
  void initState() {
    super.initState();
    Dados.campos.clear();
    Dados.prepara(localizacao, 'nome',nome, true);
    Dados.prepara(localizacao, 'cidadeId',tmp, true);
    Dados.prepara(localizacao, 'cidadeNome',tmp, true);
    Dados.prepara(localizacao, 'ufId',tmp, true);
    Dados.prepara(localizacao, 'ufNome',tmp, true);
    if(ufNome!=null && ufNome!=''){
      ufEscolhida=ufNome;
    }
    if(cidadeNome!=null && cidadeNome!=''){
      cidadeEscolhida=cidadeNome;
    }
    if(ufNome!=null && userNome!=''){
      nome.text=userNome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:'local'.tr,center: true,),
        bottomNavigationBar:BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child:OutlinedButton(
              style: Utils.OutlinedButtonStlo(false,0),
              child: Texto(tit:'enviar'.tr,negrito: true,tam: 17,cor:Colors. white),
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

    datacount.write('cidade', cidadeId);
    datacount.write('cidadeNome', cidadeEscolhida);
    datacount.write('uf', ufEscolhida);
    datacount.write('userNome', nome.text);

    if(idUser!=null && idUser!='') {
      //DOADOR
      Dados.setDadosParaGravaCliente('nome', nome.text);
      Dados.setDadosParaGravaCliente('cidadeId', cidadeId);
      Dados.setDadosParaGravaCliente('cidadeNome', cidadeEscolhida);
      Dados.setDadosParaGravaCliente('ufId', ufID);
      Dados.setDadosParaGravaCliente('ufNome', ufEscolhida);

      await Dados.atualizaDados('user', context, idUser);
      datacount.write('local', 'OK');
      Get.offAll(() => UserAnuncio(), arguments: {'primeiraVez': true});
    }else{
      //QUEM VAI RECEBER A DOAÇÃO
      Get.offAll(() => AdmPedidos(), arguments: {'primeiraVez': true});
    }
  }

  void getUf()async{
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
      });
    }
  }
}