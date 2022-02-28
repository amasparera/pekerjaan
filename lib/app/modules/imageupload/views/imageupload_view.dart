import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/imageupload_controller.dart';

class ImageuploadView extends GetView<ImageuploadController> {
  const ImageuploadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff17182D),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Confirmasi'),
        centerTitle: true,
      ),
      body: GetBuilder<ImageuploadController>(
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              controller.image != null
                  ? Container(
                      // alignment: Alignment.topCenter,
                      width: double.infinity,
                      color: Colors.red,
                      height: MediaQuery.of(context).size.height * .6,
                      child: Image.file(
                        controller.image!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * .7,
                      child: const Center(
                          child: Text(
                        'Tidak ada Data',
                        style: TextStyle(color: Colors.white),
                      ))),
              controller.image != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 8, bottom: 4),
                      child: Text(
                        DateFormat.yMMMd().format(controller.waktuFoto!),
                        style: const TextStyle(
                            color: Color.fromARGB(185, 255, 255, 255)),
                      ),
                    )
                  : const SizedBox(),
              controller.image != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        DateFormat.Hm().format(controller.waktuFoto!),
                        style: const TextStyle(
                            color: Color.fromARGB(185, 255, 255, 255)),
                      ),
                    )
                  : const SizedBox(),
              controller.image != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        controller.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(239, 255, 255, 255),
                            fontSize: 17),
                      ),
                    )
                  : const SizedBox(),
              const Spacer(),
              bottom()
            ],
          );
        },
      ),
    );
  }

  Row bottom() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              controller.pickerimage();
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 12, bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add_a_photo),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: GestureDetector(
            onTap: () {
              if (controller.image != null) {
                controller.uploadPekerjaan();
              }
            },
            child: GetBuilder<ImageuploadController>(
              builder: (_) {
                return Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  decoration: BoxDecoration(
                      color: _.image == null ? Colors.grey : Colors.orange,
                      borderRadius: BorderRadius.circular(12)),
                  child: _.bottomLoading
                      ? const SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Kirim',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                _.image == null ? Colors.black : Colors.white,
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
