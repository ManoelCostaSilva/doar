import 'package:doaruser/cep/ufs.dart';
import 'package:doaruser/dados/campos_uf.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListaUf extends StatefulWidget {
  @override
  _ListaUfState createState() => _ListaUfState();
}

class _ListaUfState extends State<ListaUf> {
  dynamic dataList;

  @override
  void initState() {

    Dados.populaUf();
    dataList=Dados.camposUf;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // super.build(context);
    return Scaffold(
      appBar: BarraStatus(tit:'uf'.tr),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
            child: TextField(
              onChanged: (text) {
                pesquisa(text);
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => {},
                    icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            ),
          ),

          Expanded(
            child:ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 0, left: 10, right: 10),
                    child: InkWell(
                      onTap: () {
                        Get.back(result: dataList[index].id+'#'+dataList[index].nome);
                      },
                      child:Card(
                        elevation: 6,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(dataList[index].nome),
                        ),
                      )
                    ),
                  );
                }),
          ),
        ],
      )
    );
  }
  void pesquisa(String tex){
    Dados.camposUf.clear();
    Dados.populaUf();
    if(tex==''){
      setState(() {
        dataList=Dados.camposUf;
      });
    }else {
      Dados.camposUfTmp.clear();
      for (var x = 0; x < Dados.camposUf.length; x++) {
        String xUf = Dados.camposUf[x].nome.toUpperCase();
        if (xUf.contains(tex.toUpperCase())) {
          Dados.camposUfTmp.add(CamposUf(Dados.camposUf[x].nome, Dados.camposUf[x].sigla, Dados.camposUf[x].id),);
        }
      }
      dataList=Dados.camposUfTmp;
      setState(() {});
    }
  }
}