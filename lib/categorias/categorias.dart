import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/edit.dart';
import 'package:doaruser/widget/mk_BoxDecoration.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Categorias extends StatefulWidget {
  @override
  CategoriasState createState() => CategoriasState();
}

class CategoriasState extends State<Categorias> with AutomaticKeepAliveClientMixin<Categorias> {
  var url='',TB='',ID='',categorias;
  final nome = TextEditingController();
  File? _image;
  bool mostraCircular=false;
  Stream? dataList;

  @override
  void initState() {
    Utils.store.remove('imagem');
    Utils.getPermission();
    TB='categorias';
    try {
      categorias=Get.arguments['dados'] ?? null;
      url=categorias['img'];
      Dados.campos.clear();
      Dados.prepara(categorias, 'nome',nome, true);
    } catch (e) {
       print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: BarraStatus(tit:'categorias'.tr),
        bottomNavigationBar:BottomAppBar(
          child:Padding(
            padding: EdgeInsets.only(top: 1,bottom: 5,left:8,right: 8),
            child:OutlinedButton(
              style: Utils.OutlinedButtonStlo(mostraCircular,0),
              child: Texto(tit:'salvar'.tr,negrito: true,tam: 17,cor:Colors. white),
              onPressed: () {
                mostraCircular=true;
                //setState(() {});
                salvar();
              },
            ),
          ),
        ),
        body:Form(
            key: Utils.formKeyEmpresa,
            child:SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height : 20.0),
                  MkBoxDecoration(image:_image,url:url,carregaImg: true,),

                  Texto(tit:'dica_foto'.tr),
                  SizedBox(height : 30.0),
                  Padding(
                    padding: EdgeInsets.only(top: 0,bottom: 0,left:2,right: 2),
                    child:Edit(label: 'nome'.tr.tr,hint: 'nome'.tr.tr,controle: nome,
                    campo:'nome'),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void salvar() async {
    if (!Utils.formKeyEmpresa.currentState!.validate()) {
      Utils.snak('atencao'.tr, 'verifique_campos'.tr,true,Colors.red);
      return;
    }
    DocumentReference ref;
    if(categorias==null) {
      ref = await Dados.databaseReference.collection(TB).add({
        'nome': nome.text,
        'dtAlterado': FieldValue.serverTimestamp(),
        'status':'A',
        'img':'',
      });
      ID=ref.id.toString();

    }else{
      ID=categorias.id;
      await Dados.databaseReference.collection(TB).doc(ID).update(
          {'nome': nome.text, 'dtAlterado': FieldValue.serverTimestamp()});
    }

    if(Utils.store.read('imagem')!=null){
      String img=Utils.store.read('imagem');
      await Utils.uploadFile(ID, img, TB, context,'DOC','.jpeg');
    }
    mostraCircular=false;
    //Get.back();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}