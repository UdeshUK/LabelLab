import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile/data/api.dart';

class ClassifyScreen extends StatelessWidget {
  final File image;

  ClassifyScreen(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Placeholder(),
    );
  }

  void _uploadImage() {
    API().uploadImage(image).then((res) {
      // setState(() {
      //   _result = res.toString();
      // });
    }).catchError((err) {
      // setState(() {
      //   _result = err.toString();
      // });
      print(err.toString());
    }).whenComplete(() {
      // setState(() {
      //   _loading = false;
      // });
    });
  }
}
