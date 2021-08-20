import 'dart:io';
import 'package:doaruser/adm/adm_pedidos.dart';
import 'package:doaruser/adm/lista_padrao.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/circular.dart';
import 'package:doaruser/widget/edit.dart';
import 'package:doaruser/widget/mk_BoxDecoration.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class UserAnuncio extends StatefulWidget {
  @override
  _UserAnuncioState createState() => _UserAnuncioState();
}

class _UserAnuncioState extends State<UserAnuncio> {
  static final datacount = GetStorage();
  var titulo = TextEditingController();
  var descricao = TextEditingController();
  var div = TextEditingController();
  File? _image;
  var url,idCat,anuncio,user;
  String categoriaEscolhida='Categorias';
  bool mostraCircular=false,priVez=false;

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Get.offAll(() => AdmPedidos(), arguments: {});
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  inicia()async {
    user =  await Utils.getUserData();
    if (user!.ufId != null) {
        //ufEscolhida = user.ufNome;
    }
  }

  @override
  void initState() {
    super.initState();
    inicia();
    BackButtonInterceptor.add(myInterceptor);
    Dados.campos.clear();
    priVez =Get.arguments['primeiraVez'] ?? null;

    Dados.prepara(anuncio, 'titulo',titulo, true);
    Dados.prepara(anuncio, 'descricao',descricao, true);
    Dados.prepara(anuncio, 'categoriaId',div, true);
    Dados.prepara(anuncio, 'categoriaNome',div, true);
    Dados.prepara(anuncio, 'userId',div, true);

    Dados.prepara(anuncio, 'nome',div, true);
    Dados.prepara(anuncio, 'ufId',div, true);
    Dados.prepara(anuncio, 'ufNome',div, true);
    Dados.prepara(anuncio, 'cidadeId',div, true);
    Dados.prepara(anuncio, 'cidadeNome',div, true);
    Dados.prepara(anuncio, 'doadoPara',div, true);
    Dados.prepara(anuncio, 'solicitantes',div, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:'anuncios'.tr,center: priVez,),
        bottomNavigationBar:BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child:OutlinedButton(
              style: Utils.OutlinedButtonStlo(mostraCircular,0),
              child:mostraCircular?Circular():
              Texto(tit:'enviar'.tr,negrito: true,tam: 17,cor:Colors. white),
              onPressed: () {
                enviar();
              },
            ),
          ),
        ),

        body: Form(
            key: Utils.formKeyEmpresa,
            child:SingleChildScrollView(
                child: Column(
                 // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height : 10.0),
                    MkBoxDecoration(image:_image,url:url,carregaImg: true,),
                    Texto(tit:'Pressine o ícone acima para trocar a imagem',tam: 14,cor:Colors.grey),
                    SizedBox(height : 10.0),
                    Edit(label: 'titulo'.tr+' Ex.:Camisa tam 44 branca',hint: 'titulo'.tr,controle: titulo,
                      campo: 'titulo',),
                    SizedBox(height : 10.0),
                    Edit(label: 'descricao'.tr,hint: 'descricao'.tr+' Ex.: Camisa semi nova precisando de alguns reparos',
                      controle: descricao, campo: 'descricao',input: TextInputType.multiline,),
                    SizedBox(height : 10.0),
                    Card(
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      child:InkWell(
                        onTap: () {
                          pesquisaCategoria();
                        },
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 0),
                                child: Texto(tit: categoriaEscolhida,negrito: true,),
                              ),
                              IconButton(
                                icon: new Icon(Icons.arrow_forward,color: Colors.grey,),
                                onPressed: () {
                                  pesquisaCategoria();
                                  },
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }

  void enviar()async{

    if (Utils.formKeyEmpresa.currentState!.validate()) {

      if(idCat==null){
        Utils.snak('atencao'.tr, 'categorias_inf'.tr, true, Colors.red);
        return;
      }
      //PEGA OS DADOS DO USUÁRIO
      setState(() {
        if(Utils.store.read('imagem')!=null) {
          url = Utils.store.read('imagem');
        }
        mostraCircular=true;
      });

      //var user=await Dados.getUserFone(user.fone);

      Dados.setDadosParaGravaCliente('categoriaId', idCat);
      Dados.setDadosParaGravaCliente('categoriaNome', categoriaEscolhida);
      Dados.setDadosParaGravaCliente('userId', user.id);

      Dados.setDadosParaGravaCliente('nome', user.nome);
      Dados.setDadosParaGravaCliente('cidadeId', user.cidadeId);
      Dados.setDadosParaGravaCliente('cidadeNome', user.cidadeNome);
      Dados.setDadosParaGravaCliente('ufId', user.ufId);
      Dados.setDadosParaGravaCliente('ufNome', user.ufNome);
      Dados.setDadosParaGravaCliente('doadoPara', 'NINGUEM');
      Dados.setDadosParaGravaCliente('solicitantes', '');

      await Dados.inserirDados('anuncio', context, '');

      if(Utils.store.read('imagem')!=null) {
        url = Utils.store.read('imagem');
        Utils.store.remove('imagem');
      }

      setState(() {
        mostraCircular = false;
      });
      Get.back();
    }
  }

  void pesquisaCategoria()async{
    final nmServ = await Get.to(() => ListaPadrao(), arguments: {'tit': 'categorias'.tr,'TB':'categorias'});
    if (nmServ != null) {

      setState(() {
        if(datacount.read('imagem')!=null) {
          _image=File(datacount.read('imagem'));
        }
        var comVr = nmServ.toString().split('#');
        categoriaEscolhida = comVr[0];
        print(categoriaEscolhida);
        idCat = comVr[1];
      });
    }
  }
}