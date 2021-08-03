import 'package:flutter/material.dart';

class Img extends StatefulWidget {
  var tit;
  double? tam;
  Color? cor;

  Img({
    this.tit,
    this.tam,
    this.cor,
  });

  @override
  _ImgState createState() => _ImgState();
}

class _ImgState extends State<Img> with SingleTickerProviderStateMixin {
  var vazio='';

  @override
  void initState() {
    vazio='https://firebasestorage.googleapis.com/v0/b/beleza-b3e97.appspot.com/o/DOC%2FNE8etfleO61F2teGzimR.jpeg?alt=media&token=9ce1035e-777e-4f1c-b7ea-fc9f7512164b';
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: ClipOval(
        child: Image.network(
            widget.tit==''?vazio:widget.tit,
            width: widget.tam==null?50:widget.tam,
            fit: BoxFit.fill
        ),
      ),
      radius: widget.tam==null?50:widget.tam,
    );
  }
}