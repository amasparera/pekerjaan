import 'package:get/get.dart';

import '../controllers/seacrh_controller.dart';

class SeacrhBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeacrhController>(
      () => SeacrhController(),
    );
  }
}
