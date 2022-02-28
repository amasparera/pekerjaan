import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    await storage.ref('test/$fileName').putFile(file);
  }

  Future<void> delete(String fileName) async {
    await storage.ref('test/$fileName').delete();
  }

  Future<ListResult> listfile() async {
    ListResult result = await storage.ref('test').listAll();

    for (var element in result.items) {
      print('found file : $element');
    }
    return result;
  }

  Future<String> dowloadUrl(String image) async {
    String dowload = await storage.ref('test/$image').getDownloadURL();
    return dowload;
  }
}
