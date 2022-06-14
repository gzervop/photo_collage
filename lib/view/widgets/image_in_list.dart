import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImageInList extends StatelessWidget {
  const ImageInList({Key? key, required this.file}) : super(key: key);
final File file;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: Image.file(file));
  }
}
