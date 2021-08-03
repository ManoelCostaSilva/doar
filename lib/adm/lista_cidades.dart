import 'package:brasil_fields/brasil_fields.dart';
import 'package:doaruser/dados/campos_cidades.dart';
import 'package:doaruser/dados/dados.dart';
import 'package:doaruser/widget/barra_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListaCidades extends StatefulWidget {
  @override
  _ListaCidadesState createState() => _ListaCidadesState();
}

class _ListaCidadesState extends State<ListaCidades> with AutomaticKeepAliveClientMixin<ListaCidades> {
  var uf;
  dynamic dataList;

  @override
  void initState() {
    uf =Get.arguments['UF'] ?? null;
    dataList=Dados.camposCidades;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: BarraStatus(tit:uf),
      body: Column(
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
                  return InkWell(
                    onTap: () {
                      Get.back(result: dataList[index].id.toString()+'#'+dataList[index].nome.toString());
                      },
                    child:Card(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(dataList[index].nome.toString()),
                      ),
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
      Dados.camposCidadesTmp.clear();
      for (var x = 0; x < Dados.camposCidades.length; x++) {
        String xUf = Dados.camposCidades[x].nome.toUpperCase();
        if (xUf.contains(tex.toUpperCase())) {
          Dados.camposCidadesTmp.add(CamposCidades(Dados.camposCidades[x].nome, Dados.camposCidades[x].id.toString()),);
        }
      }
      dataList=Dados.camposCidadesTmp;
      setState(() {});
    }

  }

  @override
  bool get wantKeepAlive => true;
}