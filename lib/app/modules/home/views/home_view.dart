import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:clipboard/clipboard.dart';

import 'package:pekerjaan/app/modules/home/controllers/home_controller.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Kategori Pekerjaan'),
      ),
      bottomNavigationBar: bottomAdd(context),
      body: listKategory(),

      //create appBar
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

          return ListView.builder(
            padding:
                const EdgeInsets.only(bottom: 50, right: 2, left: 2, top: 2),
            itemCount: pekerjaan.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(4),
                color: Colors.white,
                child: ListTile(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => edit(context, pekerjaan[index]));
                  },
                  onTap: () =>
                      controller.toPekerjaan(pekerjaan[index].idPekerjaan),
                  title: Text(
                    pekerjaan[index].name!,
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  leading: const Icon(Icons.work),
                ),
              );
            },
          );
        }
      },
    );
  }

  Container bottomAdd(context) {
    return Container(
      padding: const EdgeInsets.only(right: 12),
      height: 50,
      color: Colors.blue,
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {
              showDialog(context: context, builder: (contex) => dialog(contex));
            },
            child: Row(
              children: const [
                Icon(Icons.add, color: Colors.white),
                Text(
                  'Tambah pekerjaan',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
              splashRadius: 15,
              onPressed: () {
                Get.toNamed(Routes.PROFILE);
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ))
        ],
      ),
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
                          )))),
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
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () async {
                        FlutterClipboard.copy(model.idPekerjaan!).then((value) {
                          Get.back();
                          Get.snackbar('Berhasil Disalin', model.idPekerjaan!);
                        });
                      },
                      child: const Center(
                        child: Text(
                          'Salin Id',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.blue,
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () async {
                        controller.tambahAnggota(model);
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
            ),
            Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
