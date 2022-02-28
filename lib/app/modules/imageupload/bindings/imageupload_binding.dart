import 'package:get/get.dart';

import '../controllers/imageupload_controller.dart';

class ImageuploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageuploadController>(
      () => ImageuploadController(),
    );
  }
}
