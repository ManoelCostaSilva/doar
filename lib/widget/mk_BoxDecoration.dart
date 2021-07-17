import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:doaruser/utils/utils.dart';

class MkBoxDecoration extends StatefulWidget {
  File? image;
  var url,img;
  double? width,height;
  bool? carregaImg;

  MkBoxDecoration({
    this.image,
    this.url,
    this.img,
    this.width,
    this.height,
    this.carregaImg,
  });

  @override
  _MkBoxDecorationState createState() => _MkBoxDecorationState();
}

class _MkBoxDecorationState extends State<MkBoxDecoration> with SingleTickerProviderStateMixin {
  var im;
  double? altura=170,largura=160;
  bool carregaIm=false;

  @override
  void initState() {
    if(widget.width!=null){
      altura=widget.width;
      largura=widget.height;
    }
    if(widget.carregaImg!){
      carregaIm=true;
    }
    if(widget.img==null){
      im='images/camera_desligada.png';
    }else{
      im=widget.img;
    }
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if(carregaIm) {
            chama();
          }
          },
        child:Container(
          width: altura, height: largura,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: widget.image != null ? FileImage(widget.image!) :
              widget.url != '' && widget.url!=null ? NetworkImage(widget.url) : AssetImage(im) as ImageProvider,
            ),
          ),
        ),
    );
  }

  void chama()async{
    File? img=await Utils.getImage();
    final imagem = GetStorage();
    imagem.write('imagem', img!.path);
    setState(() {
      widget.image=img;
    });
  }
}