import 'package:flutter/material.dart';
import 'package:flutter_application_demo/documents/image_box.dart';
import 'package:flutter_application_demo/documents/photo_view.dart';

class ImagesGrid extends StatelessWidget {
  final List<String> images;
  final Function(String) onRemoveImage;

  const ImagesGrid(
      {super.key, required this.images, required this.onRemoveImage});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: List<Widget>.generate(
        images.length,
        (index) => InkWell(
          onTap: () {
            // Navigate to the photo view screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewScreen(
                  imagePath: images[index],
                  onRemove: onRemoveImage,
                ),
              ),
            );
          },
          child: ImageBox(
            filePath: images[index],
          ),
        ),
      ),
    );
  }
}
