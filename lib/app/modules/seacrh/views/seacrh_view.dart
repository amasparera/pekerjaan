import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/seacrh_controller.dart';

class SeacrhView extends GetView<SeacrhController> {
  const SeacrhView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.blue),
        titleSpacing: 0,
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: TextField(
          autofocus: true,
          onChanged: (value) {
            controller.searchUser();
          },
          maxLines: 1,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search "name"',
          ),
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
              title: Text(controller.listdata[index].name!),
              subtitle: Text(controller.listdata[index].email!),
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(controller.listdata[index].profileUrl!),
              ),
              trailing: const Icon(Icons.person_add_alt_1),
            ),
          ),
        ),
      ),
    );
  }
}
