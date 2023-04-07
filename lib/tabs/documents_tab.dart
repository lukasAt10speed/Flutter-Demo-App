import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_demo/documents/pdf_box.dart';
import 'package:flutter_application_demo/utils/storage.dart';

class DocumentsTab extends StatefulWidget {
  const DocumentsTab({super.key});

  @override
  State<DocumentsTab> createState() => _DocumentsTabState();
}

class _DocumentsTabState extends State<DocumentsTab> {
  late Future<ListResult> _listPdfsFuture;

  @override
  void initState() {
    super.initState();
    _listPdfsFuture = Storage.listPdfs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _listPdfsFuture,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.707,
              ),
              itemCount: snapshot.data!.items.length,
              itemBuilder: (context, index) {
                return PdfBox(fullPath: snapshot.data!.items[index].fullPath);
              },
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container();
      }),
    );
  }
}
