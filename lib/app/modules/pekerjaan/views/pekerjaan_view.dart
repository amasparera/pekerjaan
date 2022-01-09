import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pekerjaan/app/data/model/model_pekerjaan.dart';

import '../controllers/pekerjaan_controller.dart';

class PekerjaanView extends GetView<PekerjaanController> {
  const PekerjaanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Semua Pekerjaan'),
      ),
      body: GestureDetector(
        child: Stack(
          children: [
            body(),
            menambahPekerjaan(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(controller.argumen)
        .collection('tugas')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('ERROR'),
            );
          } else {
            List<PekerjaanModel> pekerjaan = snapshot.data!.docs
                .map((e) => PekerjaanModel.fromJson(e.data()))
                .toList();
            return ListView.builder(
              itemCount: pekerjaan.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  controller.mengerjakan(pekerjaan[index].id);
                },
                leading: pekerjaan[index].status == false
                    ? const Icon(Icons.circle_outlined)
                    : const Icon(Icons.run_circle_rounded, color: Colors.blue),
                title: pekerjaan[index].status == false
                    ? Text(pekerjaan[index].name!)
                    : Text('(${pekerjaan[index].name!})',
                        style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough)),
                trailing: Text(pekerjaan[index].namePekerja!,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            );
          }
        });
  }

  Widget menambahPekerjaan() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            color: Colors.blue[200],
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert_rounded)),
                Expanded(
                  child: TextField(
                    onChanged: (val) {
                      // ignore: avoid_print
                      print(val);
                    },
                    controller: controller.input,
                    decoration: InputDecoration(
                        suffix: GestureDetector(
                            onTap: () {
                              controller.menambahkanPekerjan();
                            },
                            child: const Icon(Icons.send)),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Tambah tugas'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
