import 'package:flutter/material.dart';
import 'dart:io';

class FullSizeImage extends StatelessWidget{

  File _image;

  FullSizeImage(this._image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Image.file(_image),
      )
    );
  }
}