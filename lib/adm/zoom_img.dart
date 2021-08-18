import 'package:doaruser/widget/barra_status.dart';
import 'package:doaruser/widget/texto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class ZoomImg extends StatefulWidget {
  @override
  _ZoomImgState createState() => _ZoomImgState();
}

class _ZoomImgState extends State<ZoomImg> {
  var img,titulo;

  @override
  void initState() {
    img =Get.arguments['img'] ?? null;
    titulo=Get.arguments['titulo'] ?? null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BarraStatus(tit:titulo),
      body: Center(
        child: Column(
            children: <Widget>[
              SizedBox(height : 20.0),
              Container(
                  width: 220.0,
                  height: 250.0,
                  child: PhotoView(
                    imageProvider: NetworkImage(img),
                  )
              ),
              SizedBox(height : 10.0),
              Texto(tit:'Use os dedos para ampliar'),
            ]
        ),
      ),
    );
  }
}