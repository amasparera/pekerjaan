import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pekerjaan/app/data/model/model_category.dart';

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

  pekerjaanAdd(nama, iduser) async {
    final resul = FirebaseFirestore.instance.collection('pekerjaan').doc();

    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = nama;
    data['idUser'] = [iduser];
    data['id'] = resul.id;
    return resul.set(data);
  }

  hapus(id) async {
    await FirebaseFirestore.instance.collection('pekerjaan').doc(id).delete();
  }

  tambahAnggota(CategoryModel model, iduser) {
    final DocumentReference resul = FirebaseFirestore.instance
        .collection('pekerjaan')
        .doc(model.idPekerjaan);

    resul.update({'idUser': []});
  }
}
