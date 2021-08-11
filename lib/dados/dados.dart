import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doaruser/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:get/get.dart';
import 'campos.dart';
import 'campos_cidades.dart';
import 'campos_uf.dart';

class Dados {
  static final databaseReference = FirebaseFirestore.instance;
  static final datacount = GetStorage();

  static List<Campos> campos = [];
  static List<CamposUf> camposUf = [];
  static List<CamposUf> camposUfTmp = [];

  static List<CamposCidades> camposCidades = [];
  static List<CamposCidades> camposCidadesTmp = [];

  static populaUf(){
    try{
      camposUf.add(CamposUf('Acre', 'AC', '12'),);
      camposUf.add(CamposUf('Alagoas', 'AL', '27'),);
      camposUf.add(CamposUf('Amapá', 'AP', '16'),);
      camposUf.add(CamposUf('Amazonas', 'AM', '13'),);
      camposUf.add(CamposUf('Bahia', 'BA', '29'),);
      camposUf.add(CamposUf('Ceará', 'CE', '23'),);
      camposUf.add(CamposUf('Destrito Federal', 'DF', '53'),);
      camposUf.add(CamposUf('Espírito Santo', 'ES', '32'),);
      camposUf.add(CamposUf('Goiás', 'GO', '52'),);
      camposUf.add(CamposUf('Maranhão', 'MA', '21'),);
      camposUf.add(CamposUf('Mato Grosso', 'MT', '51'),);
      camposUf.add(CamposUf('Mato Grosso do Sul', 'MS', '50'),);
      camposUf.add(CamposUf('Minas Gerais', 'MG', '31'),);
      camposUf.add(CamposUf('Pará', 'PA', '15'),);
      camposUf.add(CamposUf('Paraíba', 'PB', '25'),);
      camposUf.add(CamposUf('Paraná', 'PR', '41'),);
      camposUf.add(CamposUf('Pernambuco', 'PE', '26'),);
      camposUf.add(CamposUf('Piauí', 'PI', '22'),);
      camposUf.add(CamposUf('Rio de Janeiro', 'RJ', '33'),);
      camposUf.add(CamposUf('Rio Grande do Norte', 'RN', '24'),);
      camposUf.add(CamposUf('Rio Grande do Sul', 'RS', '43'),);
      camposUf.add(CamposUf('Rondônia', 'RO', '11'),);
      camposUf.add(CamposUf('Roraime', 'RR', '14'),);
      camposUf.add(CamposUf('Santa Catarina', 'SC', '42'),);
      camposUf.add(CamposUf('São Paulo', 'SP', '34'),);
      camposUf.add(CamposUf('Sergipe', 'SE', '28'),);
      camposUf.add(CamposUf('Tocantins', 'TO', '17'),);
    } catch (e) {
    };
  }

  static solicitarDoacao(String idItem,String foneSolicitante,String solicitantes) async{
    if(solicitantes!='') {
      if (!solicitantes.contains('foneSolicitante')) {
        await Dados.databaseReference.collection('anuncio').doc(idItem).update({
          'solicitantes': foneSolicitante,
          'dtAlterado': FieldValue.serverTimestamp(),
        });
      }
    }
    await Dados.databaseReference
        .collection('anuncio')
        .doc(idItem)
        .collection("solicitantes")
        .add({
      'status':'A',
      'dtCriado': FieldValue.serverTimestamp(),
      'fone':foneSolicitante,

    });
  }

  static prepara(var dados,String campo,dynamic controle,bool obrigatorio){
    try{
      campos.add(Campos(campo, dados[campo],obrigatorio),);
      controle.text=dados[campo];
    } catch (e) {
      //não tem o campo
      campos.add(Campos(campo, '', obrigatorio),);
      controle.text='';
    };
  }

  static setDadosParaGravaCliente(String? cp,String? vr){
    final tile = campos.firstWhere((item) => item.campo == cp);
    tile.valor = vr!;
  }


  static Future<dynamic> inserirUser(String fone) async {
    DocumentReference ref;
    ref=await databaseReference.collection('user').add({
      'fone':fone,
      'img':'',
      'nome':'',
      'termo':'',
      'status':'A',
      'dtCriado': FieldValue.serverTimestamp(),
      'dtAtualizado': FieldValue.serverTimestamp(),
    },);
    datacount.write('idUser',ref.id.toString());
  }

  static Future<dynamic> inserirDados(String TB,BuildContext context,String idItem) async {

    Map<String,String> toGravar={};

    for (var x = 0; x < campos.length; x++) {
      if (campos[x].valor !='') {
        toGravar[campos[x].campo]=campos[x].valor;
      }
    }
    //GRAVA OS DADOS OPCIONAIS
    DocumentReference ref;
    if(idItem=='') {
      ref = await Dados.databaseReference.collection(TB).add(toGravar,);
    }else{
      ref=await Dados.databaseReference
          .collection(TB)
          .doc(idItem)
          .collection("itens")
          .add(toGravar);
      String ch=ref.id.toString();

      await Dados.databaseReference.collection(TB).doc(idItem).collection('itens').doc(ch).update({
        'status': 'A',
        'doadoPara': '',
        'dtCriado': FieldValue.serverTimestamp(),
        'dtAlterado': FieldValue.serverTimestamp(),
      });
    }

    String chave=ref.id.toString();

    if(idItem=='') {
      //GRAVA OS DADOS PADRÕES
      await Dados.databaseReference.collection(TB).doc(chave).update({
        'status': 'A',
        'img': '',
        'dtCriado': FieldValue.serverTimestamp(),
        'dtAlterado': FieldValue.serverTimestamp(),
      });
    }

    if(Utils.store.read('imagem')!=null){
      String img=Utils.store.read('imagem');
      await Utils.uploadFile(ref.id, img, TB, context,'DOC','.jpeg');
    }else{
     // Utils.snak('parabens'.tr, 'sucesso'.tr, true,Colors.green);
    }
    return chave;
  }

  static Future<dynamic> atualizaDados(String TB,BuildContext context,String? id) async {
    Map<String,String> toGravar={};
    toGravar.clear();
    for (var x = 0; x < campos.length; x++) {
      if (campos[x].valor !='') {
        toGravar[campos[x].campo]=campos[x].valor;
      }
    }

    await Dados.databaseReference.collection(TB).doc(id).update(toGravar);
    await Dados.databaseReference.collection(TB).doc(id).update({'dtAtualizado':FieldValue.serverTimestamp()});

    if(Utils.store.read('imagem')!=null){
      String img=Utils.store.read('imagem');
      await Utils.uploadFile(id, img, TB, context,'DOC','.jpeg');
    }else{
      Utils.snak('parabens'.tr, 'sucesso'.tr, false, Colors.green);
    }
  }

  static setIdProduto(String idPro){
    datacount.write('idProduto',idPro);
  }

  static getIdProduto(){
    String id=datacount.read('idProduto');
    return id;
  }

  static getIdEmpresa(){
    String id=datacount.read('idDoc');
    return id;
  }

  static Future<dynamic> getUserFone(String fone) async {
    var user;
    user = await Dados.getData('user', 'fone', fone, 'nome');
    if(user==null){
      return null;
    }else {
      return user;
    }
  }

  static atualizaSenha(String TB,String senha,String ID)async {
    await Dados.databaseReference.collection(TB).doc(
        ID).update({'senha': senha, 'dtAlterado': FieldValue.serverTimestamp()});
  }

  static ativarDesativar(String id,String st,String TB,String sub) async{
    try {
      String stTmp;
      if(st=='A'){
        stTmp='I';
      }else{
        stTmp='A';
      }
      if(TB=='man_produtos_add'){
        await databaseReference.collection(TB).doc(sub).collection('itens').doc(id) .update({'status': stTmp});
      }else {
        await databaseReference.collection(TB).doc(id).update({'status': stTmp});
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static del(String id,String TB,BuildContext context,String sub) async{
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: new Texto(tit:'atencao'.tr,negrito: true,cor: Utils.corApp,tam: 20,),
          content: new Text('del_confirm'.tr),
          actions: <Widget>[
            OutlinedButton(
              style: Utils.OutlinedButtonStlo(false,6),
              child: Texto(tit:'nao'.tr,tam: 15,cor:Colors.white),
              onPressed: () {
                Get.back();
              },
            ),

            OutlinedButton(
            style: Utils.OutlinedButtonStlo(false,0),
              child: Texto(tit:'sim'.tr,tam: 15,cor:Colors.white),
              onPressed: () {
              Get.back();
              if(TB=='man_produtos_add'){
                databaseReference.collection(TB).doc(sub).collection('itens').doc(id).delete();
              }else{
                databaseReference.collection(TB).doc(id).delete();
              }
              },
            ),
          ],
        ));
  }

  static Future<dynamic> getData(String TB,String CAMPO,String ID,String ORDER) async {
    QuerySnapshot qn = await databaseReference.collection(TB)
        .where(CAMPO, isEqualTo: ID).orderBy(ORDER)
        .get();

    var dados;
    for (int i = 0; i < qn.docs.length; i++) {
      dados = qn.docs[i];
    }
    return dados;
  }

  static Future<dynamic> getLogado(String TB,String USER,String SENHA,String ORDER) async {
    QuerySnapshot qn = await databaseReference.collection(TB)
        .where('nome', isEqualTo: USER)
        .where('senha', isEqualTo: SENHA).orderBy(ORDER)
        .get();
    return qn.docs;
  }

  static Future<dynamic> getCom2Where(String TB,String CP1,String VR1,
      String CP2,String VR2,String ORDER) async {

    QuerySnapshot qn = await databaseReference.collection(TB)
        .where(CP1, isEqualTo: VR1)
        .where(CP2, isEqualTo: VR2).orderBy(ORDER)
        .get();
    return qn.docs;
  }

  static chamaPedidos(String status, String idPedido,BuildContext context,String cpfCliente
  ,List<dynamic>? tabs,bool admin,String tipoPedido,bool adm) async {

    var dadosPedido = await Dados.getData('man_pedidos', 'idPedido', idPedido, 'dtAtualizado');
    var dadosCliente = await Dados.getData('man_clientes', 'cpf', cpfCliente, 'nmCli');


    switch (dadosPedido['tipoPedido']) {
      case 'C6Pay':
        //final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => C6PayMain(
          //dadosCliente: dadosCliente,dadosPedido:dadosPedido,cpf: cpfCliente,individual: admin,adm: adm,)));
        break;

      /*
        case 'Refinanciamento':
          final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => RefinanciamentoMain(
            dadosCliente: dadosCliente,dadosPedido:dadosPedido,tabs: tabs,cpf: cpfCliente,admin: admin,)));
          break;
        case 'Empréstimo Pessoal':
          final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => MainPedidosForm(
            dadosCliente: dadosCliente,dadosPedido:dadosPedido,tabs: tabs,cpf: cpfCliente,admin: admin,)));
          break;

        case 'Consignado':
          final nmServ = await Navigator.push(context, MaterialPageRoute(builder: (context) => ConsignadoMain(
            dadosCliente: dadosCliente,dadosPedido:dadosPedido,tabs: tabs,cpf: cpfCliente,admin: admin,idPedido: idPedido,)));
          break;

       */
      }
  }

  static String doubleToReal(double vr) {
    var oCcy = new NumberFormat("#,##0.00", "pt_BR");
    var vrM = "R\$ " + oCcy.format(vr);
    return vrM;
  }

  static double vrDouble(String vr){
    String v='';
    v = vr.replaceAll('.', '#');
    v = v.replaceAll(',', '.');
    v = v.replaceAll('#', '');
    return double.parse(v);
  }
}// 262