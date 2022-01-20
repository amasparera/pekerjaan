import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seacrh_controller.dart';

class SeacrhView extends GetView<SeacrhController> {
  const SeacrhView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff17182D),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.orange),
        titleSpacing: 0,
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          onChanged: (value) {
            controller.searchUser();
          },
          maxLines: 1,
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Search "name"',
              hintStyle: TextStyle(color: Colors.white70)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
                onTap: () {
                  controller.searchUser();
                },
                child: const Icon(
                  Icons.search,
                )),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.listdata.length,
          itemBuilder: (context, index) => FadeInDown(
            animate: true,
            duration: const Duration(microseconds: 300),
            delay: Duration(microseconds: index * 50),
            child: ListTile(
              onTap: () => controller.tambahAnggota(controller.listdata[index]),
              title: Text(
                controller.listdata[index].name!,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(controller.listdata[index].email!,
                  style: const TextStyle(color: Colors.white70)),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(controller.listdata[index].profileUrl!),
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.person_add_alt_1,
                color: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
