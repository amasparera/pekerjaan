import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:pekerjaan/app/data/hive/ulangi.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init();
  var document = await path.getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter<Ulangi>(UlangiAdapter());
  await Hive.openBox('ulangi');
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pekerjaan",
      initialRoute: Routes.ONBOARD,
      getPages: AppPages.routes,
    ),
  );
}
