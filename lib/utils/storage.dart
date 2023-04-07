import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Storage {
  static FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: dotenv.get('BUCKET'));

  static UploadTask uploadPdf(File file) {
    String filePath = "pdfs/${DateTime.now()}.pdf";

    return storage.ref().child(filePath).putFile(file);
  }

  static Future<ListResult> listPdfs() async =>
      await storage.ref("pdfs").list();
}
