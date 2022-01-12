import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pekerjaan/app/data/firebase/firestroreku.dart';
import 'package:pekerjaan/app/data/hive/ulangi.dart';

class Update {
  final _box = Hive.box('ulangi');

  void menambahUlangi(String id, Map model, List<DateTime> day) {
    Ulangi data = Ulangi(day, DateTime.now(), model, id);
    _box.add(data);
  }
  // bool a = DateFormat.E().format(DateTime.now()) ==
  //     DateFormat.E().format(pekerjaan[index].hariIni!);
  // print(a.toString());

  bersihkan(id) {
    for (var i = 0; i < _box.length; i++) {
      Ulangi ulangi = _box.getAt(i);
      if (ulangi.idcategory == id) {
        _box.deleteAt(i);
      }
    }
  }

  cekUlangi() {
    if (_box.isNotEmpty) {
      for (var i = 0; i < _box.length; i++) {
        Ulangi ulangi = _box.getAt(i);
        for (var a = 0; a < ulangi.ulangan.length; a++) {
          if (DateFormat.E().format(DateTime.now()) ==
                  DateFormat.E().format(ulangi.ulangan[a]) &&
              DateFormat.E().format(DateTime.now()) !=
                  DateFormat.E().format(ulangi.update)) {
            ulangi.update = DateTime.now();

            ulangi.model['hariini'] = DateTime.now();
            _box.putAt(i, ulangi);
            FirebaseFirestroreku()
                .documentTugas(ulangi.idcategory)
                .then((value) {
              FirebaseFirestroreku().menambahTugas(
                  id: ulangi.idcategory, idtugas: value.id, data: ulangi.model);
            });
          }
        }
      }
    }
  }
}
