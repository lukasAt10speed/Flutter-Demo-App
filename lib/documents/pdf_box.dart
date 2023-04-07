
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_demo/common/box_loader_placeholder.dart';
import 'package:flutter_application_demo/documents/pdf_view.dart';
import 'package:flutter_application_demo/utils/storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class PdfBox extends StatefulWidget {
  final String fullPath;
  const PdfBox({super.key, required this.fullPath});

  @override
  State<PdfBox> createState() => _PdfBoxState();
}

class _PdfBoxState extends State<PdfBox> {
  late Future<String> _pdfDocumentURLFuture;

  @override
  void initState() {
    super.initState();
    _pdfDocumentURLFuture = _getDownloadURL();
  }

  Future<String> _getDownloadURL() async {
    return Storage.storage.ref(widget.fullPath).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _pdfDocumentURLFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final pdfDocumentURL = snapshot.data!;

        return FutureBuilder<File>(
          future: DefaultCacheManager().getSingleFile(pdfDocumentURL),
          builder: (context, snapshot) => snapshot.hasData
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfView(
                          fullPath: snapshot.data!.path,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: PdfDocumentLoader.openFile(
                        snapshot.data!.path,
                        pageNumber: 1,
                      ),
                    ),
                  ),
                )
              : const BoxLoaderPlaceholder(),
        );
      },
    );
  }
}
