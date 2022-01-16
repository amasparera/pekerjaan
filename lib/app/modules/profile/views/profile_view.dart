import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  final String text = 'Sign in With Google';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            splashRadius: 24,
            icon: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black54),
                height: 40,
                width: 32,
                child: const Icon(Icons.arrow_back_ios_new_rounded)),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              splashRadius: 24,
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black54,
                ),
                height: 40,
                width: 40,
                child: const Icon(Icons.logout),
              ),
              onPressed: () {
                controller.logOut();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        AssetImage('assest/campaign-creators-gMsnXqILjp4.jpg')),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black87, Colors.black12],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .7,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          FadeInLeft(
                            animate: true,
                            delay: const Duration(milliseconds: 180),
                            duration: const Duration(milliseconds: 200),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 80,
                              child: CircleAvatar(
                                radius: 77,
                                backgroundImage:
                                    NetworkImage(controller.myUser.profileUrl!),
                              ),
                            ),
                          ),
                          FadeInLeft(
                            animate: true,
                            delay: const Duration(microseconds: 170),
                            duration: const Duration(milliseconds: 200),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Text(controller.myUser.name!.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            child: FadeInUp(
                              animate: true,
                              duration: const Duration(milliseconds: 200),
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(28),
                                    decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(38),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Email :',
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 2, bottom: 2),
                                          child: Text(controller.myUser.email!,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        const Text(
                                          'User ID :',
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, top: 2, bottom: 2),
                                          child: Text(controller.myUser.id!,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                            child: Row(
                                          children: [
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Total Pekerjaan :',
                                                  style: TextStyle(
                                                      color: Colors.white54),
                                                ),
                                                const SizedBox(height: 5),
                                                TweenAnimationBuilder(
                                                    duration: const Duration(
                                                        milliseconds: 900),
                                                    tween: IntTween(
                                                        begin: 0,
                                                        end:
                                                            controller.argumen),
                                                    builder: (context, value,
                                                        child) {
                                                      return Text(
                                                        value.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.amber,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 40),
                                                      );
                                                    })
                                              ],
                                            )),
                                            Padding(
                                              padding: const EdgeInsets.all(18),
                                              child: buildQr(context),
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildQr(context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration:
            BoxDecoration(border: Border.all(width: 5, color: Colors.white)),
        child: QrImage(
          data: controller.myUser.id!,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
