import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/cep/municipios.dart';
import 'package:doaruser/dados/campos_cidades.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/msg/msg.dart';
import 'package:doaruser/msg/msg_solicitantes.dart';
import 'package:doaruser/notificacao/bloc.dart';
import 'package:doaruser/user/user_anuncio.dart';
import 'package:doaruser/user/user_localizacao.dart';
import 'package:doaruser/user/user_login.dart';
import 'package:doaruser/user/user_termo.dart';
import 'package:doaruser/widget/circular.dart';
import 'package:doaruser/widget/img.dart';
import 'package:doaruser/widget/sem_registro.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:doaruser/empresas/emprese_settings.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/texto.dart';
import 'lista_cidades.dart';
import 'lista_padrao.dart';
import 'lista_uf.dart';
import 'package:intl/intl.dart';
import 'zoom_img.dart';

class AdmPedidos extends StatefulWidget {
  @override
  _AdmPedidosState createState() => _AdmPedidosState();
}

class _AdmPedidosState extends State<AdmPedidos> {
  dynamic dataList,lista,anuncios;
  TextEditingController editingController = TextEditingController();
  bool mostraCircular=false;
  var ufEscolhida='uf'.tr,cidadeEscolhida='',categoriaEscolhida='categorias'.tr, idCategoria;
  var texto,userFone='',user;
  var bloc = BlocHome();
  bool mostra=false,mostraSolicitante=false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> getAnuncios(String cidade) async {
    if(cidade!='') {
      dataList = Dados.databaseReference.collection('anuncio')
          .where('cidadeId', isEqualTo: cidade)
          .where('status', isEqualTo: 'A')
          .orderBy('dtCriado', descending: true).snapshots();
    }else{

      dataList = Dados.databaseReference.collection('anuncio')
          .where('status', isEqualTo: 'A')
          .orderBy('dtCriado', descending: true).snapshots();
    }
  }
  inicia()async {
    user =  await Utils.getUserData();
    setState(() {
    if(user!=null) {
      if (user!.ufId != null) {
        getAnuncios(user.cidadeId);
        cidadeEscolhida = user.cidadeNome;
        ufEscolhida = user.ufNome;
        userFone = user.fone.toString();
      } else {
        getAnuncios('');
      }
    }else{
      getAnuncios('');
    }
    });
  }

  @override
  void initState() {
    //bloc.initOneSignal();
    inicia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child:TextField(
                      style: TextStyle(color: Colors.white,fontSize: 14),
                      controller: editingController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => pesquisa(editingController.text),
                            icon: Icon(Icons.search,color: Colors.white,),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(20.0) ))
                      ),
                    ),
                  ),

                  //CONFIGURA????ES *****************************************
                  Transform.translate(
                    offset: Offset(15, 0),
                    child:IconButton(
                      color: Colors.white, icon: new Icon(Icons.settings,),
                      onPressed: () {
                        if(user!=null) {
                          if(user.termo!='Aceito'){
                            Get.offAll(() => UserTermo(), arguments: {'tipo':'configuracoes'});
                          }else{
                            if(user.ufId==null){
                              Get.offAll(() => UserLocalizacao(), arguments: {'tipo':'configuracoes'});
                            }else{
                              enviaParaEmpresa();
                            }
                          }
                        }else{
                          Get.to(() => LoginPage(), arguments: {'tipo':'configuracoes'});
                        }
                      },
                    ),
                  ),
                ],
              ),
            ]
        ),
        backgroundColor: Utils.corApp,
      ),

      //QUERO DOAR **********************************************************
      bottomNavigationBar:BottomAppBar(
        child:Padding(
          padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
          child:OutlinedButton(
            style: Utils.OutlinedButtonStlo(mostraCircular,0),
            child: mostraCircular?Circular():Texto(tit:'quero_doar'.tr,negrito: true,tam: 17,cor:Colors. white),
            onPressed: () {
              if(user!=null) {
                if(user.termo!='Aceito'){
                  Get.offAll(() => UserTermo(), arguments: {'tipo':'doar'});
                }else{
                  if(user.ufId==null){
                    Get.offAll(() => UserLocalizacao(), arguments: {'tipo':'doar'});
                  }else{
                    Get.to(() => UserAnuncio(), arguments: {'primeiraVez': false});
                  }
                }
              }else{
                Get.to(() => LoginPage(), arguments: {'tipo':'doar'});
              }
              //mostraCircular=true;
            },
          ),
        ),
      ),

      body:Column(
          children: <Widget>[
            ExpansionTile(
              title:Row(
                  children: <Widget>[
                    Texto(tit:'filtro'.tr,negrito: true,tam: 18,),
                    Texto(tit:userFone,tam: 14,),
                  ]
              ),

              //OP????ES DE FILTRO ******************
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 1,bottom: 5,left:10,right: 8),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //BOT??O DA UF *******************************
                              TextButton.icon(
                                style: Utils.TextButtoniconStyle(5),
                                icon: Icon(Icons.place_outlined), // Your icon here
                                label: Text(ufEscolhida), // Your text here
                                onPressed: (){getUf();},
                              ),
                              //NOME DA CIDADE ****************************
                              Padding(
                                padding: EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 0),
                                child:Texto(tit:cidadeEscolhida,tam: 11,negrito: true,),
                              ),
                            ]
                        ),

                        //CATEGORIAS **************************************
                        Column(
                            children: <Widget>[
                              TextButton.icon(
                                style: Utils.TextButtoniconStyle(5),
                                icon: Icon(Icons.album_outlined), // Your icon here
                                label: Text(categoriaEscolhida), // Your text here
                                onPressed: (){getCategoria();},
                              ),
                              Texto(tit:'',tam: 11,),
                            ]
                        ),
                      ]
                  ),
                ),
              ],
            ),

            //LISTA TODOS OS ANUNCIOS
            Expanded(
              child:StreamBuilder(
                stream: dataList,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return SemRegistro(tit:'Erro inesperado');
                  }

                  if (!snapshot.hasData) {
                    return SemRegistro(tit:'Nenhum an??ncio');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SemRegistro(tit:'aguarde'.tr);
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        DateTime dateTime = ds["dtCriado"].toDate();

                        if(user!=null){
                          mostraSolicitante = ds['solicitantes'].toString().contains(user.fone.toString());
                        }

                        if(categoriaEscolhida!='categorias'.tr){
                          //FOI ESCOLHIDO UMA CATEGORIA
                          if(ds['categoriaId']==idCategoria){
                            if(texto!=null){
                              if(ds['titulo'].toString().toUpperCase().contains(texto.toString().toUpperCase())){
                                mostra=true;
                              }else{
                                mostra=false;
                              }
                            }else{
                              mostra=true;
                            }
                          }else{
                            mostra=false;
                          }
                        }else{
                          //N??O FOI ESCOLHIDO UMA CATEGORIA
                          if(texto!=null) {
                            if (ds['titulo'].toString().toUpperCase().contains(texto.toString().toUpperCase())) {
                              mostra=true;
                            }else{
                              mostra=false;
                            }
                          }else{
                            mostra=true;
                          }
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 0, left: 5, right: 5),
                          child: mostra?cartao(ds,dateTime) :Container(),
                        );
                      });
                },
              ),
            ),
          ]
      ),
    );
  }

  void getUf()async{
    final ufVolta = await Get.to(() => ListaUf(),);
    if (ufVolta != null) {
      var ufs = ufVolta.toString().split('#');
      ufEscolhida=ufs[1];
      getMunicipo(ufs[0]);
      //ufID=ufs[0];
    }
  }

  getMunicipo(String UF)async{
    var municipios = await Municipios.getMunicipio(municipio: UF);
    Dados.camposCidades.clear();
    for (var x = 0; x < municipios.length; x++) {
      Dados.camposCidades.add(CamposCidades(municipios[x].nome,municipios[x].id.toString(),),);
    }
    final cidadeVolta = await Get.to(() => ListaCidades(), arguments: {'UF':ufEscolhida});
    if (cidadeVolta != null) {
      setState(() {
        var cidade = cidadeVolta.toString().split('#');
        ufEscolhida=ufEscolhida;
        cidadeEscolhida=cidade[1];
        getAnuncios(cidade[0]);
      });
    }
  }

  void getCategoria()async{
    final nmServ = await Get.to(() => ListaPadrao(), arguments: {'tit': 'categorias'.tr,'TB':'categorias'});
    if (nmServ != null) {
      setState(() {
        var comVr = nmServ.toString().split('#');
        idCategoria=comVr[1];
        categoriaEscolhida = comVr[0];
      });
    }
  }

  Widget menus(dynamic anuncios,BuildContext context) {
    return PopupMenuButton(
        onSelected: (value) {
          switch(value) {
            case 1://ACEITAR DOA????O
              verificaDoacao(anuncios);
              break;
            case 2:
            //Get.toNamed(destino,arguments: {'tit':tit,'TB':TB,'dados':dados});
              break;

            case 3://ENVIAR MSG
              if(user==null){
                Get.to(() => LoginPage(), arguments: {'tipo':'msg','anuncio':anuncios});
              }else {
                if (anuncios['userId'].toString() == user.id.toString()) {
                  //QUEM VAI MANDAR A MENSAGEM ?? O DOADOR
                  //DIRECIONA PARA ELE ESCOLHER ALGU??M
                  Get.to(() => MsgSolicitantes(), arguments: {'anuncio':anuncios});
                }
                else {
                  //QUEM VAI MANDAR A MSG ?? O SOLICITANTE
                  //VAI DIRETO PRA MSG
                  Get.to(() => Msg(), arguments: {
                    'idAnuncio': anuncios.id,
                    'de': user.fone,
                    'para': anuncios['userId'],
                    'titulo': anuncios['titulo']
                  });
                }
              }
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.volunteer_activism,color: Colors.red,),
                  ),
                  Texto(tit:'Aceitar doa????o',cor:Colors.blue),
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.voice_over_off),
                  ),
                  Texto(tit:'Denunciar',cor: Colors.red,),
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.message_outlined),
                  ),
                  Texto(tit:'msg_enviar'.tr,),
                ],
              )),
        ]);
  }

  verificaDoacao(var anuncio){
    if(user!=null) {
      if(user.id==anuncio['userId']){
        Utils.snak('atencao'.tr, 'doacao_minha'.tr, true, Colors.red);
        return;
      }
      if (anuncio['solicitantes'].contains(user.fone)) {
        Utils.snak('atenacao'.tr, 'aguarde_solicitacao'.tr, false, Colors.red);
        return;
      }

      if(user.termo!='Aceito'){
        Get.offAll(() => UserTermo(), arguments: {'tipo':'aceitar'});
      }else{
        if(user.ufId==null){
          Get.offAll(() => UserLocalizacao(), arguments: {'tipo':'aceitar'});
        }else{
          Utils.snak('parabens'.tr, 'aguarde_contato'.tr, false, Colors.green);
          Dados.solicitarDoacao(anuncio,user.fone);
        }
      }
    }else{
      //gsUser.write('idDoacao',anuncio.id);
      Get.to(() => LoginPage(), arguments: {'tipo':'aceitar','anuncio':anuncio});
    }
  }

  pesquisa(String tex){
    texto=tex;
    setState(() {
    });
  }

  Widget cartao(dynamic ds,DateTime dateTime){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Utils.corApp,
          width: 1.0,
        ),
      ),

      elevation: 6,
      child:Column(
          children: <Widget>[
            ListTile(
              dense:true,
              contentPadding: EdgeInsets.only(top: 5, bottom: 5, left: 1, right: 1),

              //IMAGEM **************************************************
              leading: Transform.translate(
                offset: Offset(-5, 10),
                child:InkWell(
                  onTap: () {
                    Get.to(() => ZoomImg(), arguments: {'img':ds['img'],'titulo':ds['titulo']});
                    },
                  child:Tooltip(
                    message: 'Pressione para ampliar',
                    child: Img(tit:ds['img'],radio: 40,largura: 50,altura: 100,),
                  ),
                ),
              ),

              //T??TULO E DATA *******************************************
              title: Transform.translate(
                offset: Offset(-25, 10),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Texto(tit:ds["titulo"],tam:16.0),
                      Texto(tit:DateFormat('dd/MM/yy hh:mm').format(dateTime)+' = '+ds['cidadeNome'],tam: 12,)
                    ]
                ),
              ),

              // DESCRI????O **********************************************
              subtitle:Transform.translate(
                offset: Offset(-25, 10),
                child: Texto(tit:ds['descricao']),
              ),

              //MENUS ***************************************************
              trailing:Visibility(
                //visible: idUser!=ds['userId'],
                visible: true,
                child:new Container(
                    child: menus(ds,context,)
                ),
              ),
            ),

            Visibility(
                visible: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
                      child: Texto(tit: 'Pressione para ampliar',cor:Colors.green,tam:10),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 10, left: 0, right: 10),
                      child: mostraSolicitante?Texto(tit: 'aguarde_solicitacao'.tr,cor:Colors.red,tam:10):Text(''),
                    ),
                    ]
                ),
            ),
          ]
      ),
    );
  }
  enviaParaEmpresa()async{
    anuncios = await Dados.databaseReference.collection('anuncio')
        .where('status', isEqualTo: 'A')
        .orderBy('dtCriado', descending: true).snapshots();

    Utils.datacount.write('anuncios', anuncios) ;
    Get.to(() => EmpresaSettings(), arguments: {'anuncios': anuncios});
  }
}