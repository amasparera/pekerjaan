import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
import 'package:pekerjaan/app/data/model/model_pekerjaan.dart';
import 'package:pekerjaan/app/data/model/myuser.dart';

class FirebaseFirestroreku {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  streamPekerjaan(String myId) async {
    return _firestore
        .collection('pekerjaan')
        .doc()
        // .where('listname', arrayContains: myId)
        .snapshots();
  }

  Future addUserInfoToDb(String userid, Map<String, dynamic> userData) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .set(userData);
  }

  pekerjaanAdd(nama, iduser, listnama) async {
    final resul = FirebaseFirestore.instance.collection('pekerjaan').doc();

    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = nama;
    data['idUser'] = [iduser];
    data['listnama'] = [listnama];
    data['id'] = resul.id;
    data['admin'] = iduser;
    return resul.set(data);
  }

  hapus(id) async {
    await FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(id)
        .collection('tugas')
        .get()
        .then((value) {
      for (var element in value.docs) {
        final data = PekerjaanModel.fromJson(element.data());
        FirebaseFirestore.instance
            .collection('pekerjaan')
            .doc(id)
            .collection('tugas')
            .doc(data.id)
            .delete();
      }
    });
    await FirebaseFirestore.instance.collection('pekerjaan').doc(id).delete();
  }

  Future<UserModel?> getUserModel(id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((value) {
      if (value.exists) {
        return UserModel.fromJson(value.data()!);
      }
    });
  }

  getCatergoryModel(idpekerjaan) async {
    await FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(idpekerjaan)
        .get()
        .then((value) {
      if (value.exists) {
        CategoryModel.fromJson(value.data());
      }
    });
  }

  tambahAnggota(iddocument, iduser, listnama) {
    FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(iddocument)
        .update({'idUser': iduser, 'listnama': listnama});
  }

  Future<CategoryModel?> gabung(id) async {
    await FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc('wGg8Nz4p4IgSnYc9YU1V')
        .get()
        .then((value) {
      if (value.exists) {
        return CategoryModel.fromJson(value.data());
      } else {
        Get.snackbar('Error', 'Data tidak ditemukan');
        return null;
      }
    });
  }

  Future<DocumentReference<Map<String, dynamic>>> documentTugas(id) async {
    final result = FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(id)
        .collection('tugas')
        .doc();

    return result;
  }

  menambahTugas({id, idtugas, data}) {
    FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(id)
        .collection('tugas')
        .doc(idtugas)
        .set(data);
  }

  mengerjakan({id, idtugas, namapekerja}) async {
    return FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(id)
        .collection('tugas')
        .doc(idtugas)
        .update({'status': true, 'namapekerja': namapekerja});
  }

  belumDikerjaan({
    id,
    idtugas,
  }) async {
    return FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(id)
        .collection('tugas')
        .doc(idtugas)
        .update({'status': false, 'namapekerja': ''});
  }

  hapusTugas({id, idtugas}) {
    return FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(id)
        .collection('tugas')
        .doc(idtugas)
        .delete();
  }
}
