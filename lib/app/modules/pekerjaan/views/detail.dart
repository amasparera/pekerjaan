import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pekerjaan/app/data/firebase/cloud.dart';
import 'package:pekerjaan/app/data/model/model_pekerjaan.dart';

class Detail extends StatelessWidget {
  const Detail({Key? key, required this.title, required this.model})
      : super(key: key);
  final String title;
  final PekerjaanModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff17182D),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            title,
          ),
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<String>(
                future: Storage().dowloadUrl(model.image!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      // alignment: Alignment.topCenter,
                      width: double.infinity,
                      color: Colors.red,
                      height: MediaQuery.of(context).size.height * .6,
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    );
                  } else {
                    return const Center(
                      child: Text('Image error'),
                    );
                  }
                }),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 4),
              child: Text(
                DateFormat.yMMMd().format(model.wktumengerjakkan!),
                style:
                    const TextStyle(color: Color.fromARGB(185, 255, 255, 255)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4),
              child: Text(
                DateFormat.Hm().format(model.wktumengerjakkan!),
                style:
                    const TextStyle(color: Color.fromARGB(185, 255, 255, 255)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                model.namePekerja!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(239, 255, 255, 255),
                    fontSize: 17),
              ),
            )
          ],
        ));
  }
}
