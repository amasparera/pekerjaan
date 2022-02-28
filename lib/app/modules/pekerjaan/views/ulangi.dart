import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/pekerjaan_controller.dart';

class Ulangi extends StatelessWidget {
  const Ulangi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PekerjaanController>();
    return Scaffold(
      backgroundColor: const Color(0xff17182D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Ulangi',
        ),
        elevation: 0,
      ),
      body: GetBuilder<PekerjaanController>(
        builder: (_) {
          return Column(
            children: List.generate(
                controller.day.length,
                (index) => listday(controller.indexUlangi.contains(index),
                        controller.day[index], () {
                      controller.ontap(index);
                      print(controller.indexUlangi);
                    })),
          );
        },
      ),
    );
  }

  ListTile listday(bool status, String hari, GestureTapCallback onTap) {
    return ListTile(
      title: Text(
        hari,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(221, 255, 255, 255)),
      ),
      trailing: Icon(
        Icons.check_circle,
        color: status ? Colors.orange : Colors.white70,
      ),
      onTap: onTap,
    );
  }
}
