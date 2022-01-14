import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardController extends GetxController
    with GetTickerProviderStateMixin {
  late final AnimationController controller =
      AnimationController(duration: const Duration(seconds: 20), vsync: this)
        ..repeat(reverse: true);

  late final Animation<double> animation = Tween<double>(begin: 1.0, end: 1.5)
      .animate(CurvedAnimation(parent: controller, curve: Curves.linear));

  PageController page = PageController(viewportFraction: 1.0);

  int posisi = 0;
  @override
  void onClose() {
    controller.dispose();
    page.dispose();
    super.onClose();
  }
}
