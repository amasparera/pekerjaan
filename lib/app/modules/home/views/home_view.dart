import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/modules/home/controllers/home_controller.dart';
import 'package:pekerjaan/app/routes/app_pages.dart';
import 'package:glass/glass.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff17182D),
      floatingActionButton: buttonHomeFloating(context),
      body: SafeArea(
          child: Column(
        children: [
          appbar(),
          const Padding(
            padding: EdgeInsets.only(left: 4, right: 4, bottom: 0, top: 4),
            child: Divider(
              thickness: 4,
              color: Colors.orange,
            ),
          ),
          Expanded(child: listKategory()),
        ],
      )),

      //create appBar
    );
  }

  MaterialButton buttonHomeFloating(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        onPressed: () {
          showDialog(context: context, builder: (context) => dialog(context));
        },
        color: Colors.orange,
        padding: const EdgeInsets.only(right: 5, left: 20, top: 5, bottom: 5),
        child: SizedBox(
          height: 32,
          width: MediaQuery.of(context).size.width * 0.45,
          child: Row(
            children: [
              Text(
                'Tambah Pekerjaan',
                style: TextStyle(
                  color: Colors.orange.shade50,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.orange.shade300,
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(
                    Icons.add_business_rounded,
                    color: Colors.orange.shade50,
                  )),
            ],
          ),
        ));
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
                tintColor: Colors.orange,
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
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
                child: homeCart(pekerjaan, index, context),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Container homeCart(List<CategoryModel> pekerjaan, int index, context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.black),
      child: InkWell(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (context) => edit(context, pekerjaan[index]));
        },
        onTap: () {
          controller.toPekerjaan(pekerjaan[index]);
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              child: Image.asset('assest/iconcart/Charity.png'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pekerjaan[index].name!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'dibuat ${DateFormat.MMMd().format(pekerjaan[index].dibuat!)}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 10),
                        ),
                        Text(
                          '${pekerjaan[index].namauser!.length}  orang    -    ${pekerjaan[index].totalTugas!.toString()}  tugas',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dialog(contex) {
    return Dialog(
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Nama Pekerjan'),
            const SizedBox(height: 10),
            SizedBox(
              child: TextField(
                autofocus: true,
                controller: controller.text,
              ),
            ),
            const SizedBox(height: 20),
            // Expanded(
            //   child: DropdownButton<String>(
            //     isDense: true,
            //     // value: controller.setIcon,
            //     onChanged: (value) => controller.setIcon = value!,
            //     items: controller.icon
            //         .map((e) => DropdownMenuItem<String>(
            //             value: controller.setIcon,
            //             child: Image.asset(
            //               e,
            //               width: 20,
            //               height: 20,
            //             )))
            //         .toList(),
            //   ),
            // ),
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
