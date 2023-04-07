import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfView extends StatelessWidget {
  final String fullPath;

  const PdfView({super.key, required this.fullPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.grey,
      // You can use either PdfViewer.openFile, PdfViewer.openAsset, or PdfViewer.openData
      body: PdfViewer.openFile(
        fullPath,
      ),
    );
  }
}
