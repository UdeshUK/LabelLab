import 'dart:io';

import 'package:flutter/material.dart';

class SelectedImage extends StatelessWidget {
  final File image;
  final double width;
  final double height;

  SelectedImage({this.image, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: image != null
          ? Image(
              image: FileImage(image),
              height: height != null ? height : 240,
              fit: BoxFit.cover,
            )
          : Container(
              width: width != null ? width : 240,
              height: height != null ? height : 240,
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.not_interested),
                  Text("No image selected")
                ],
              ),
            ),
    );
  }
}
