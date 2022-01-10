import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textTile('Nama :', controller.myUser.name),
            textTile('Username :', controller.myUser.username),
            textTile('Email :', controller.myUser.email),
            textTile('User ID :', controller.myUser.id),
            const SizedBox(height: 24),
            buildQr(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => dialogGabung());
                    },
                    child: const Text(' Gabung ')),
                ElevatedButton(
                    onPressed: () {
                      controller.logOut();
                    },
                    child: const Text('Log Out')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Dialog dialogGabung() => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: controller.input,
                decoration: const InputDecoration(hintText: 'input id'),
              ),
              Row(
                children: [
                  Obx(() => Text(
                        '${controller.masukaninput}',
                        style: const TextStyle(color: Colors.red),
                      )),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        controller.gabung();
                      },
                      child: const Text('Simpan')),
                ],
              )
            ],
          ),
        ),
      );

  Widget textTile(nama, usernama) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nama,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            usernama,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
          )
        ],
      ),
    );
  }

  Widget buildQr(context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.width * .7,
        width: MediaQuery.of(context).size.width * .7,
        decoration:
            BoxDecoration(border: Border.all(width: 5, color: Colors.black)),
        child: QrImage(data: controller.myUser.id!),
      ),
    );
  }
}
