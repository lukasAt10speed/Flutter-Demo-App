import 'dart:io';

import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  final String filePath;

  const ImageBox({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Colors.grey.shade300,
        ),
        image: DecorationImage(
          image: FileImage(
            File(filePath),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
