import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pekerjaan/app/data/firebase/cloud.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/getstore/myuser.dart';
import 'package:pekerjaan/app/modules/pekerjaan/controllers/pekerjaan_controller.dart';

class ImageuploadController extends GetxController {
  DateTime? waktuFoto;

  File? image;
  String? name;

  String argumen = Get.arguments;
  bool bottomLoading = false;

  Future pickerimage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.camera);
    waktuFoto = DateTime.now();
    final imagetemporary = File(result!.path);
    image = imagetemporary;
    update();
  }

  uploadPekerjaan() {
    bottomLoading = true;
    update();
    Storage().uploadFile(image!.path, name! + argumen).then((value) {
      final conttroller = Get.find<PekerjaanController>();
      FirebaseFirestroreku().mengerjakanCamera(
          id: conttroller.argumen.idPekerjaan,
          idtugas: argumen,
          namapekerja: name,
          wktu: waktuFoto,
          image: name! + argumen);
      Get.back();
    });
  }

  @override
  void onInit() {
    name = Myuser().loadDisplayName();
    super.onInit();
  }

  @override
  void onReady() {
    pickerimage();
    super.onReady();
  }
}
