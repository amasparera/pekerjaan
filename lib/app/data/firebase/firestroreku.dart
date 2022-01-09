import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';
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
    return resul.set(data);
  }

  hapus(id) async {
    await FirebaseFirestore.instance.collection('pekerjaan').doc(id).delete();
  }

  getUserModel(id) async {
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

  tambahAnggota(iddocument, iduser) {
    FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(iddocument)
        .update({'idUser': iduser});
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
}
