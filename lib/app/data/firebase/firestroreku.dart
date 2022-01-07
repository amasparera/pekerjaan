import 'package:cloud_firestore/cloud_firestore.dart';

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = nama;
    data['idUser'] = [iduser];

    final resul =
        await FirebaseFirestore.instance.collection('pekerjaan').add(data);
    return await FirebaseFirestore.instance
        .collection('listid')
        .add({'id': resul.id.toString()});
  }

  hapus(id) async {
    await FirebaseFirestore.instance.collection('pekerjaan').doc(id).delete();
  }
}
