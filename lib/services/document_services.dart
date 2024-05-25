import 'dart:io';
import 'dart:typed_data';
import 'package:labcure/models/patient.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

class DocumentServices {
  static Future<File> create({required Patient patient}) async {
    Document document = Document();
    document.addPage(
      MultiPage(
        pageTheme: theme(
          await PdfGoogleFonts.interRegular(),
          await PdfGoogleFonts.interBold(),
          await PdfGoogleFonts.interTightItalic(),
        ),
        header: (context) => PatientContent.header(),
        build: (context) => [PatientContent.content(patient)],
      ),
    );
    return save(name: '${patient.name}.pdf', document: document);
  }

  static PageTheme theme(Font base, Font bold, Font italic) {
    return PageTheme(margin: EdgeInsets.zero, theme: ThemeData.withFont(base: base, bold: bold, italic: italic));
  }

  static Future<File> save({required String name, required Document document}) async {
    Uint8List bytes = await document.save();
    Directory directory = await getApplicationDocumentsDirectory();
    File file = await File('${directory.path}/$name').writeAsBytes(bytes);
    await OpenFilex.open(file.path);
    return file;
  }
}

class PatientContent {
  static Widget header() => SizedBox(height: 80);

  static Widget content(Patient patient) {
    TextStyle textStyle = const TextStyle(fontSize: 8);
    SizedBox horizSpace = SizedBox(width: 30.0);
    List<String> headers = ['Test', 'Result', 'Unit', 'Optimal Ranges'];
    Map<int, TableColumnWidth> columnWidths = {
      0: const FlexColumnWidth(3),
      1: const FlexColumnWidth(3),
      2: const FlexColumnWidth(2),
      3: const FlexColumnWidth(3),
    };

    return Column(
      children: [
        DefaultTextStyle(
          style: textStyle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (index) {
                        List<String> labels = ['Name', 'Gender', 'Birthday', 'Patient ID'];
                        return Padding(padding: const EdgeInsets.only(bottom: 5.0), child: Text(labels[index]));
                      }),
                    ),
                    horizSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (index) {
                        List<String> data = [
                          '${patient.title} ${patient.name}',
                          patient.gender,
                          patient.age,
                          patient.pid
                        ];
                        return Padding(padding: const EdgeInsets.only(bottom: 5.0), child: Text(data[index]));
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (index) {
                        List<String> labels = ['Organization', 'Unique ID', 'Admission Date', 'Report Date'];
                        return Padding(padding: const EdgeInsets.only(bottom: 5.0), child: Text(labels[index]));
                      }),
                    ),
                    horizSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(4, (index) {
                        List<String> labels = ['Self', patient.uid, patient.admissionDate!, patient.reportDate!];
                        return Padding(padding: const EdgeInsets.only(bottom: 5.0), child: Text(labels[index]));
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Table(
          columnWidths: columnWidths,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: PdfColors.grey200),
              children: List.generate(headers.length, (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                  alignment: index == 0 ? Alignment.centerLeft : Alignment.center,
                  child: Text(headers[index], style: textStyle.copyWith(fontSize: 10, fontWeight: FontWeight.bold)),
                );
              }),
            ),
          ],
        ),
        Table(
          columnWidths: columnWidths,
          children: List.generate(patient.tests.length, (index) {
            List<String> test = [
              patient.tests[index].label,
              patient.tests[index].result ?? '',
              patient.tests[index].unit,
              ''
            ];
            return TableRow(
              children: List.generate(test.length, (index) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
                  alignment: index == 0 ? Alignment.centerLeft : Alignment.center,
                  child: Text(test[index], style: textStyle),
                );
              }),
            );
          }),
        )
      ],
    );
  }
}
