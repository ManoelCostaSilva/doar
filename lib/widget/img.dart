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

  @override
  void initState() {
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
            widget.tit,
            width: widget.tam==null?50:widget.tam,
            fit: BoxFit.fill
        ),
      ),
      radius: widget.tam==null?50:widget.tam,
    );
  }
}