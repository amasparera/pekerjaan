import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/modules/home/controllers/home_controller.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';
import 'package:glass/glass.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff17182D),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffFF6600),
        onPressed: () {
          showDialog(context: context, builder: (contex) => dialog(contex));
        },
        child: const Icon(Icons.add_business_rounded),
      ),
      body: SafeArea(
          child: Column(
        children: [
          appbar(),
          Expanded(child: listKategory()),
        ],
      )),

      //create appBar
    );
  }

  Widget appbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: FadeInLeftBig(
              duration: const Duration(seconds: 1),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8, spreadRadius: 1, color: Colors.white12)
                    ],
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Image.asset(
                  'assest/logo a.png',
                  height: 30,
                ),
              ).asGlass(
                tintColor: Colors.transparent,
                clipBorderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
            ),
          ),
          FadeInRightBig(
            duration: const Duration(seconds: 1),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 29,
                  onPressed: () {
                    Get.toNamed(Routes.PROFILE, arguments: controller.total);
                  },
                  icon: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(controller.profileurl))),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget listKategory() {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('pekerjaan')
        .where('idUser', arrayContains: controller.userIdSaya)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else {
          List<CategoryModel> pekerjaan = snapshot.data!.docs
              .map((e) => CategoryModel.fromJson(e.data()))
              .toList();
          controller.total = pekerjaan.length;
          pekerjaan.sort((a, b) => a.name!.compareTo(b.name!));

          return ListView.builder(
            padding:
                const EdgeInsets.only(bottom: 4, right: 2, left: 2, top: 12),
            itemCount: pekerjaan.length,
            itemBuilder: (context, index) {
              return FadeInRightBig(
                duration: const Duration(milliseconds: 700),
                delay: Duration(milliseconds: (index + 1) * 40),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  color: Colors.white,
                  child: ListTile(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              edit(context, pekerjaan[index]));
                    },
                    onTap: () =>
                        controller.toPekerjaan(pekerjaan[index].idPekerjaan),
                    title: Text(
                      pekerjaan[index].name!,
                      style: const TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                    leading: const Icon(Icons.work),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget dialog(contex) {
    return Dialog(
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Nama Pekerjan'),
            TextField(
              autofocus: true,
              controller: controller.text,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red,
                    child: InkWell(
                      onTap: () {
                        controller.batal();
                      },
                      child: const Center(
                        child: Text(
                          'Batal',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.blue,
                    child: InkWell(
                      onTap: () {
                        controller.addPekerjaan();
                      },
                      child: const Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget edit(context, CategoryModel model) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 350,
        child: Column(
          children: [
            Text('Angota - ${model.name}'),
            const SizedBox(height: 8),
            Text(
              'ID - ${model.idPekerjaan}',
              style: const TextStyle(color: Colors.blue),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
            Expanded(
                child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: model.idUser!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(2),
                child: Text('${index + 1}. ${model.namauser![index]}'),
              ),
            )),
            model.admin == controller.userIdSaya
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.blue,
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.SEACRH, arguments: model);
                            },
                            child: const Center(
                              child: Text(
                                'Tambahkan Angota',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            model.admin == controller.userIdSaya
                ? Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.all(12),
                          child: InkWell(
                            onTap: () {
                              controller.hapus(model.idPekerjaan);
                              Get.back();
                            },
                            child: const Center(
                              child: Text(
                                'hapus',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
