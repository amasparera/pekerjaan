import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

membuatqr(String code, name) async {
  final pdf = pw.Document();

  var data =
      await rootBundle.load("assest/OpenSans-VariableFont_wdth,wght.ttf");
  var myFont = Font.ttf(data);

  pdf.addPage(pw.Page(
      margin: const pw.EdgeInsets.all(.4),
      pageFormat: const PdfPageFormat(4, 3),
      build: (pw.Context context) => pw.Container(
          width: 5,
          height: 3,
          child: pw.Row(children: [
            pw.Expanded(
              child: pw.SizedBox(
                  height: 2,
                  width: 2,
                  child: pw.BarcodeWidget(
                      textStyle: pw.TextStyle(font: myFont),
                      barcode: pw.Barcode.qrCode(),
                      data: code)),
            ),
            pw.SizedBox(width: .3),
            pw.Expanded(
                child: pw.Text(name,
                    maxLines: 5,
                    overflow: pw.TextOverflow.clip,
                    style: pw.TextStyle(
                        color: PdfColors.black, font: myFont, fontSize: 0.26)))
          ]))));

// menyimpan
  Uint8List btye = await pdf.save();

  // penyimpanan
  final lokasi = await getApplicationDocumentsDirectory();
  final file = File('${lokasi.path}/pekerjaan_$name.pdf');

  // timpa file kosong dengan file pdf
  await file.writeAsBytes(btye);

  // open pdf
  await OpenFile.open(file.path);
}
