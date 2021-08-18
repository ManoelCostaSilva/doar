import 'package:brasil_fields/brasil_fields.dart';
import 'package:doaruser/user/user_struc.dart';
import 'package:doaruser/widget/texto.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'op_filtro.dart';
import 'package:get/get.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Utils {
  static final datacount = GetStorage();
  static final databaseReference = FirebaseFirestore.instance;
  //static final Color corApp=HexColor("#F4AE00");//123.717.730-86
  static final Color corApp=HexColor("#00b100");

  static final Color corMsg=HexColor("#e2ffc7");
  static const kGoogleApiKey = "AIzaSyDy-E-2iAD-jlYqaJH2BK9ZJQCZGYcJW9Y";
  static final formKeyEmpresa = GlobalKey<FormState>();
  static final formKeyPerfilPadrao = GlobalKey<FormState>();
  static final formKeyProdutosItens = GlobalKey<FormState>();

  static List<OpcaoFilto> opcaoFilto = [];
  static final picker = ImagePicker();
  static final store = GetStorage();

  static setUserData(var user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = UserStruc.encode([
      UserStruc(cidadeId: user['cidadeId'], cidadeNome: user['cidadeNome'],
          ufId:user['ufId'] ,ufNome: user['ufNome'], fone:user['fone'],
          img:user['img'],nome:user['nome'],status:user['status'], termo:user['termo'],
          id: user.id ),
    ]);
    await prefs.setString('user', encodedData);
  }

  static  getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? users = await prefs.getString('user');
    if(users==null){
      return null;
    }
    final List<UserStruc>? user = UserStruc.decode(users!);
    return user![0];
  }

  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
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

  static ButtonStyle TextButtoniconStyle(double elevacao){
    return TextButton.styleFrom(
      primary: Utils.corApp,
      backgroundColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      elevation: elevacao,
      side: BorderSide(color: Colors.grey, width: 1),
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

  static Future<String?>  uploadFile(String? id,String _image,String tabela,BuildContext context,
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

  static showDlg(String titulo,String frase,BuildContext context) async{
    bool volta=false;
    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: Utils.corApp,
              width: 1.0,
            ),
          ),
          title: Texto(tit:titulo,tam: 17,negrito: true,cor:corApp ,),
          content: new Text(frase),
          actions: <Widget>[

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButtonStlo(false,6),
                    child: Texto(tit:'nao'.tr,negrito: true,tam: 17,cor:Colors.white),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      volta=false;
                    },
                  ),
                  OutlinedButton(
                    style: OutlinedButtonStlo(false,6),
                    child: Texto(tit:'sim'.tr,negrito: true,tam: 17,cor:Colors.red),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      volta=true;
                    },
                  ),
            ]
        ),


          ],
        ));
    return volta;
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
