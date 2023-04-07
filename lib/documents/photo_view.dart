import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  final String imagePath;
  final Function onRemove;

  const PhotoViewScreen(
      {super.key, required this.imagePath, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: OutlinedButton.icon(
        onPressed: () {
          onRemove(imagePath);
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
        icon: const Icon(Icons.delete),
        label: const Text("Delete"),
      ),
      body: PhotoView(
        imageProvider: FileImage(
          File(imagePath),
        ),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black87,
        ),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 2,
      ),
    );
  }
}
