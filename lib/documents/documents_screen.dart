import 'dart:io';
import 'dart:math';

import 'package:flutter_application_demo/utils/storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_demo/documents/images_grid.dart';

class DocumentsScreen extends StatefulWidget {
  static String routeId = "home";
  final List<String> documents;

  const DocumentsScreen({super.key, required this.documents});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool _isLoading = false;
  late List<String> _documents;

  @override
  void initState() {
    super.initState();
    _documents = widget.documents;
  }

  void _onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted || pictures.isEmpty) return;
      setState(() {
        _documents.addAll(pictures);
      });
    } catch (exception) {
      // Handle exception here
    }
  }

  void _onReturn() {
    Navigator.of(context).pop();
  }

  Future<void> _createPdfFromImages(List<String> documents) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final pdf = pw.Document();

      for (final imagePath in documents) {
        final image = pw.MemoryImage(
          File(imagePath).readAsBytesSync(),
        );

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image),
              ); // Center
            },
          ),
        );
      }

      final rndName = Random(DateTime.now().millisecondsSinceEpoch)
          .nextInt(10000)
          .toString();

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/$rndName.pdf");

      final pdfFile = await file.writeAsBytes(await pdf.save());

      await Storage.uploadPdf(pdfFile);

      _onReturn();
    } catch (exception) {
      // Handle exception here
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onRemove(String filePath) {
    setState(() {
      _documents.remove(filePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: !_isLoading ? () => Navigator.pop(context) : null,
        ),
        actions: [
          IconButton(
              onPressed: !_isLoading
                  ? () {
                      _createPdfFromImages(_documents);
                    }
                  : null,
              icon: const Icon(Icons.save))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: !_isLoading ? _onPressed : null,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ImagesGrid(images: _documents, onRemoveImage: _onRemove),
      ),
    );
  }
}
