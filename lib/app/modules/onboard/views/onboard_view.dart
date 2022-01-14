import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

import '../controllers/onboard_controller.dart';

class OnboardView extends GetView<OnboardController> {
  final List<dynamic> _furnitures = [
    {
      'title': 'Solusi\nDunia Kerja',
      'sub_title':
          'Mengingat apa yang harus ingat, melupakan apa yang sudah dikerjakan.',
      'image': 'assest/photo-1521737711867-e3b97375f902.jpg'
    },
    {
      'title': 'Quality\nTime\'s',
      'sub_title':
          'Menegement waktu dalam genggaman, devinisi rumit tapi mudah.',
      'image': 'assest/photo-1432888498266-38ffec3eaf0a.png'
    },
    {
      'title': 'Time\'s\nIs Money',
      'sub_title': 'Waktu anda Keberhasilan Anda,\nMulai sekarang.',
      'image': 'assest/photo-1507679799987-c73779587ccf.jpg'
    },
  ];

  OnboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        onPageChanged: (int index) {
          controller.controller.value = 0.0;
          controller.controller.forward();
          controller.posisi = index;
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: ScaleTransition(
                  scale: controller.animation,
                  child: Image.asset(
                    _furnitures[index]['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.black.withOpacity(0.8),
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.1)
                        ])),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInDown(
                            duration: const Duration(milliseconds: 500),
                            child: Text(
                              _furnitures[index]['title'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeInDown(
                              delay: const Duration(milliseconds: 100),
                              duration: const Duration(milliseconds: 800),
                              child: Text(
                                _furnitures[index]['sub_title'],
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 18,
                                ),
                              )),
                          const SizedBox(
                            height: 50,
                          ),
                          FadeInLeft(
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 1000),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  onPressed: () {
                                    if (controller.posisi != 2) {
                                      controller.page.nextPage(
                                          duration: const Duration(
                                              microseconds: 1000),
                                          curve: Curves.easeInToLinear);
                                    } else {
                                      Get.offAllNamed(Routes.LOGIN);
                                    }
                                  },
                                  color: Colors.orange,
                                  padding: const EdgeInsets.only(
                                      right: 5, left: 30, top: 5, bottom: 5),
                                  child: SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Row(
                                      children: [
                                        Text(
                                          'Get Started',
                                          style: TextStyle(
                                            color: Colors.orange.shade50,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.orange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(40)),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.orange.shade100,
                                            )),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ])),
              )
            ],
          );
        },
        itemCount: _furnitures.length,
        controller: controller.page,
      ),
    );
  }
}
