import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin;
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'op_filtro.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Utils {
  static final databaseReference = FirebaseFirestore.instance;
  static final Color corApp=HexColor("#F4AE00");//123.717.730-86
  static final Color corMsg=HexColor("#e2ffc7");
  static const kGoogleApiKey = "AIzaSyDy-E-2iAD-jlYqaJH2BK9ZJQCZGYcJW9Y";
  static final formKeyEmpresa = GlobalKey<FormState>();
  static final formKeyPerfilPadrao = GlobalKey<FormState>();
  static final formKeyProdutosItens = GlobalKey<FormState>();

  static List<OpcaoFilto> opcaoFilto = [];
  static final picker = ImagePicker();
  static final store = GetStorage();


  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
    //showSnackbar('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
  };

  static ButtonStyle OutlinedButtonStlo(bool mostraCircular, double elevacao){
    return OutlinedButton.styleFrom(
        padding: mostraCircular?EdgeInsets.symmetric(horizontal: 50, vertical: 15)
            :EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: Utils.corApp,
        elevation: elevacao,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),)
    );
  }

  static String? validaDoc(String cpf,String cnpj){
    String doc='';
    bool valida=false;
    if(cnpj==''){
      doc=cpf;
      valida=UtilBrasilFields.isCPFValido(doc);
    }else{
      doc=cnpj;
      valida=UtilBrasilFields.isCNPJValido(doc);
    }
    if(valida){
      return doc;
    }else{
      return '';
    }
  }

  static void tiraFocus(FocusScopeNode currentFocus) {
    if(currentFocus!=null) {
      if (!currentFocus.hasPrimaryFocus) {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }
  }

  static  Future<File?> getImage() async {
    ImageSource source=ImageSource.gallery;
    final image = await picker.getImage(source: source);
    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }

  static Future<String>  uploadFile(String? id,String _image,String tabela,BuildContext context,
      String tipo,String extensao) async {

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'enviando'.tr);

    String cam='';
    if(tipo=='DOC'){
      cam='DOC/'+id!+extensao;
    }else{
      cam='11_imagens/'+id!+extensao;
    }
    store.remove('imagem');
    UploadTask uploadTask=FirebaseStorage.instance.ref().child(cam).putFile(File(_image));
    var imageUrl = await (await uploadTask).ref.getDownloadURL();

    pd.close();
    final imagem = GetStorage();
    imagem.write('imagem', imageUrl);
    await updateData(id,imageUrl,tabela);

    throw '';
  }

  static deletaImagem(String idImagem,String extensao) async{
    FirebaseStorage.instance.ref().child('DOC/'+idImagem+extensao).delete();
  }

  static updateData(String id,String img,String tabela) async {
    try {
      await databaseReference.collection(tabela).doc(id).update({'img': img});
    } catch (e) {
    }
  }

  static showDlg(String titulo,String frase,String botao1,BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          title: new Text(titulo,
            style: TextStyle(fontWeight: FontWeight.bold,color: Utils.corApp,fontSize: 17.00),),
          content: new Text(frase),
          actions: <Widget>[
            FlatButton(
              child: Text(botao1,
                style: TextStyle(fontWeight: FontWeight.bold,color: Utils.corApp,fontSize: 17.00)
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ));
  }

  static double dist(double lat2,double lon2,double userLat,double userLon)   {

    var p = 0.017453292519943295;
    var c = cos;

    var a = 0.5 - c((lat2 - userLat) * p) / 2 +
        c(userLat * p) * c(lat2 * p) * (1 - c((lon2 - userLon) * p)) / 2;

    double d=12742 * asin(sqrt(a));
    return d;
  }

  static Future<String> download(String url,BuildContext context,String nmDoc,String extensao) async{
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    //await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
    throw '';
  }

  static showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  static getPermission() async {
    print("getPermission");

    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }

  static Widget execute(BuildContext context,String tit,String TB,String destino) {
    return FloatingActionButton(
        heroTag: null,
        backgroundColor: Utils.corApp,
        child: Icon(Icons.add,),
        onPressed: () {
          Get.toNamed(destino,arguments: {'dados':null,'TB':TB,'tit':tit});
        }
    );
  }

  static Widget menus(dynamic dados,BuildContext context,String TB,String destino,String tit,String sub) {
    return PopupMenuButton(
        onSelected: (value) {
          switch(value) {
            case 1://DESATIVAR
              Dados.ativarDesativar(dados.id,dados['status'],TB,sub);
              break;
            case 2:
              Get.toNamed(destino,arguments: {'tit':tit,'TB':TB,'dados':dados});
              break;
            case 3: // EXCLUIR
              Dados.del(dados.id,TB,context,sub);
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
                    child: Icon(Icons.autorenew),
                  ),
                  Text(dados['status']=='A'?'desativar'.tr:'ativar'.tr)
                ],
              )),
          PopupMenuItem(
              value: 2,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.auto_fix_normal),
                  ),
                  Text('edit'.tr)
                ],
              )),
          PopupMenuItem(
              value: 3,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                    child: Icon(Icons.delete_outline),
                  ),
                  Text('del'.tr)
                ],
              )),
        ]);
  }

  static snak(String tit,String frase,bool dismiss,Color corFundo){
    return Get.snackbar(
      tit,
      frase,
      icon: Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: corFundo,
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      isDismissible: false,
      //showProgressIndicator:true,
      //dismissDirection: SnackDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,

    );
  }
}//466