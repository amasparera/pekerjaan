import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pekerjaan/app/data/firebase/cloud.dart';
import 'package:pekerjaan/app/data/model/model_pekerjaan.dart';
import 'package:pekerjaan/app/modules/pekerjaan/views/ulangi.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';

import '../controllers/pekerjaan_controller.dart';
import 'detail.dart';

class PekerjaanView extends GetView<PekerjaanController> {
  const PekerjaanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff17182D),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(controller.argumen.name!),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          body(),
          menambahPekerjaan(context),
        ],
      ),
    );
  }

  Widget body() {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(controller.argumen.idPekerjaan)
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
            pekerjaan.sort((a, b) => a.hariIni!.compareTo(b.hariIni!));
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: pekerjaan.length,
              itemBuilder: (context, index) =>
                  cardTile(context, pekerjaan, index),
            );
          }
        });
  }

  Widget cardTile(
      BuildContext context, List<PekerjaanModel> pekerjaan, int index) {
    return Column(
      children: [
        ListTile(
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) => dialogEdit(context, pekerjaan[index]));
          },
          onTap: () async {
            if (pekerjaan[index].barcode == true &&
                pekerjaan[index].status == false) {
              Get.toNamed(Routes.IMAGEUPLOAD, arguments: pekerjaan[index].id!);
            } else if (pekerjaan[index].status == false) {
              controller.mengerjakan(pekerjaan[index].id);
            }
          },
          leading: pekerjaan[index].status == false
              ? const Icon(
                  Icons.circle_outlined,
                  color: Colors.white70,
                )
              : const Icon(Icons.run_circle_rounded, color: Colors.orange),
          title: pekerjaan[index].status == false
              ? Text(pekerjaan[index].name!,
                  style: const TextStyle(color: Colors.white))
              : Text(
                  pekerjaan[index].name!,
                  style: const TextStyle(
                      color: Colors.white60,
                      decoration: TextDecoration.lineThrough,
                      decorationStyle: TextDecorationStyle.solid),
                ),
          subtitle: Text(
            DateFormat.MMMd().format(pekerjaan[index].hariIni!),
            style: const TextStyle(
                color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          trailing: (pekerjaan[index].barcode == true &&
                  pekerjaan[index].namePekerja == '')
              ? const Icon(
                  Icons.add_a_photo,
                  color: Colors.white70,
                )
              : GestureDetector(
                  onTap: () {
                    if (pekerjaan[index].barcode == true) {
                      Get.to(Detail(
                        title: pekerjaan[index].name!,
                        model: pekerjaan[index],
                      ));
                    }
                  },
                  child: Text(pekerjaan[index].namePekerja!,
                      style: const TextStyle(
                          color: Colors.orange, fontWeight: FontWeight.bold)),
                ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Divider(
            color: Colors.white24,
          ),
        )
      ],
    );
  }

//  ${DateFormat.E().format(DateTime.now())}
  Dialog dialogEdit(context, PekerjaanModel model) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: 240,
          child: Column(
            children: [
              const Text(
                'Pilihan Mengedit',
                style: TextStyle(fontSize: 18),
              ),
              const Padding(
                padding: EdgeInsets.all(4),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          controller.belumDikerjakan(model.id);
                          if (model.barcode! && model.status!) {
                            Storage().delete(model.image!);
                          }
                          Get.back();
                        },
                        child: const Center(
                          child: Text(
                            'Belum Dikerjakan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.red,
                      child: InkWell(
                        onTap: () {
                          // controller.rangeWaktu(context, model);
                          controller.indexUlangi.clear();

                          Get.to(const Ulangi());
                        },
                        child: const Center(
                          child: Text(
                            'Ulangi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      color: Colors.red,
                      child: InkWell(
                        onTap: () {
                          controller.hapusTugas(model.id);
                          if (model.barcode! && model.status!) {
                            Storage().delete(model.image!);
                          }
                          Get.back();
                        },
                        child: const Center(
                          child: Text(
                            'Hapus Tugas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  Widget menambahPekerjaan(context) => FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(
              () => controller.open.value == false
                  ? const SizedBox()
                  : requesTanggal(context),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18 / 2,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 32,
                    color: const Color(0xFF087949).withOpacity(0.08),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.open.value = !controller.open.value;
                      },
                      child: const Icon(Icons.more_vert_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18 * 0.75,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sentiment_satisfied_alt_outlined,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                            const SizedBox(width: 18 / 4),
                            Expanded(
                              child: TextField(
                                controller: controller.input,
                                decoration: const InputDecoration(
                                  hintText: "Name tugas",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(width: 18 / 4),
                            GestureDetector(
                              onTap: () {
                                controller.menambahkanPekerjan();
                              },
                              child: const Icon(
                                Icons.send_rounded,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget requesTanggal(context) {
    return Container(
      height: 104,
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Text('Tanggal :'),
                const Spacer(),
                Text(
                  DateFormat.yMMMd().format(controller.waktuDipilih.value),
                ),
                TextButton(
                    onPressed: () {
                      controller.orderTime(context);
                    },
                    child: const Text('edit'))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Text('Camera :'),
                const Spacer(),
                Obx(() => Text(
                      controller.barcode.value == false ? 'tidak' : 'perlu',
                      style: const TextStyle(color: Colors.black),
                    )),
                const SizedBox(width: 6),
                Obx(
                  () => Switch(
                    value: controller.barcode.value,
                    onChanged: (val) {
                      controller.barcode.value = val;
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
