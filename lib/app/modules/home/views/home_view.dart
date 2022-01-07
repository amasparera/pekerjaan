import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';

import 'package:pekerjaan/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    final Stream<QuerySnapshot> usersStream =
        FirebaseFirestore.instance.collection('pekerjaan').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        } else {
          List<CategoryModel> pekerjaan = snapshot.data!.docs
              .map(
                (e) => CategoryModel.fromJson(e.data()),
              )
              .toList();

          return ListView.builder(
            itemCount: pekerjaan.length,
            itemBuilder: (context, index) {
              return ListTile(
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (context) => edit(context,
                          'LZspgNxZdw7tqU1FN4Fs', pekerjaan[index].name!));
                },
                onTap: () => controller.toPekerjaan(index),
                title: Text(pekerjaan[index].name!),
              );
            },
          );
        }
      },
    );
  }

  Container bottomAdd(context) {
    return Container(
      height: 50,
      color: Colors.blue[200],
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {
              showDialog(context: context, builder: (contex) => dialog(contex));
            },
            child: Row(
              children: const [
                Icon(Icons.add),
                Text('Add list'),
              ],
            ),
          ),
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
              controller: controller.text,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                    onPressed: () {
                      controller.addPekerjaan();
                    },
                    child: const Text('Simpan'))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget edit(context, id, name) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        child: Column(
          children: [
            Text('Angota - $name'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
                height: 4,
              ),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  color: Colors.blue,
                  padding: const EdgeInsets.all(10),
                  child: const InkWell(
                    child: Text(
                      'Tambahkan Angota',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  color: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                  child: InkWell(
                    onTap: () {
                      controller.hapus(id);
                      Get.back();
                    },
                    child: const Text(
                      'hapus',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
