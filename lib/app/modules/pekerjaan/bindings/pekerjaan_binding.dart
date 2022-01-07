import 'package:get/get.dart';

import '../controllers/pekerjaan_controller.dart';

class PekerjaanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PekerjaanController>(
      () => PekerjaanController(),
    );
  }
}
