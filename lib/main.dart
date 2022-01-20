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
  runApp(FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else {
          return const Main();
        }
      }));
}

class Main extends StatelessWidget {
  const Main({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pekerjaan",
      initialRoute: AppPages.INITIAL(),
      getPages: AppPages.routes,
    );
  }
}

class Loading extends GetView<LoadingController> {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tesla Service',
      home: Scaffold(
        body: Center(
            child: GetBuilder<LoadingController>(
          init: LoadingController(),
          initState: (_) {},
          builder: (_) {
            return AnimatedScale(
              duration: const Duration(milliseconds: 500),
              scale: _.active ? 1 : 2,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _.active ? 1 : 0,
                child: Image.asset(
                  'assest/ic_launcher.png',
                  width: 80,
                ),
              ),
            );
          },
        )),
      ),
    );
  }
}

class LoadingController extends GetxController {
  bool active = false;

  @override
  void onReady() {
    active = true;
    update();
    super.onReady();
  }
}
