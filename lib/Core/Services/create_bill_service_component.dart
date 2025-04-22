import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:printing/printing.dart';

class CreateBill {
  pw.Font? _font;
  User? auth_user = FirebaseAuth.instance.currentUser;

  Future<void> _loadFont() async {
    if (_font == null) {
      _font = await fontFromAssetBundle(
        'assets/fonts/NotoSans-VariableFont_wdth-wght.ttf',
      );
    }
  }

  Future<Uint8List> generateInvoicePdf({
    required String vendorName,
    required String invoiceNumber,
    required String invoiceDate,
    required String soldTo,
    required List<Map<String, dynamic>> items,
  }) async {
    await _loadFont();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                color: PdfColors.orangeAccent,
                width: double.infinity,
                padding: pw.EdgeInsets.all(10),
                child: pw.Text(
                  'Cash Memo',
                  style: pw.TextStyle(
                    font: _font,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                "Vendor Name: $vendorName",
                style: pw.TextStyle(font: _font),
              ),
              pw.Text(
                "Invoice Number: $invoiceNumber",
                style: pw.TextStyle(font: _font),
              ),
              pw.Text(
                "Invoice Date: $invoiceDate",
                style: pw.TextStyle(font: _font),
              ),
              pw.Text("To: $soldTo", style: pw.TextStyle(font: _font)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.orange100),
                    children: [
                      _tableHeader("Serial No"),
                      _tableHeader("Description"),
                      _tableHeader("Task Hours"),
                      _tableHeader("Total Amount"),
                    ],
                  ),
                  ...items.asMap().entries.map((entry) {
                    final i = entry.key + 1;
                    final item = entry.value;
                    return pw.TableRow(
                      children: [
                        _tableCell((entry.key + 1).toString()),
                        _tableCell(item['description']),
                        _tableCell(_formatNumber(item['taskHours'])),
                        _tableCell(_formatNumber(item['taskPrice'])),
                      ],
                    );
                  }),
                  // pw.TableRow(
                  //   children: [
                  //     pw.SizedBox(),
                  //     pw.SizedBox(),
                  //     pw.SizedBox(),
                  //     pw.SizedBox(),
                  //     pw.SizedBox(),
                  //     _tableCell("Total", isBold: true),
                  //     _tableCell(items[0]['taskPrice'], isBold: true),
                  //   ],
                  // ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _tableHeader(String text) => pw.Padding(
    padding: pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
      style: pw.TextStyle(font: _font, fontWeight: pw.FontWeight.bold),
    ),
  );

  pw.Widget _tableCell(String text, {bool isBold = false}) => pw.Padding(
    padding: pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        font: _font,
        fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
      ),
    ),
  );

  Future<String> uploadPdfFile(
    String fileName,
    String vendorName,
    String invoiceNumber,
    String invoiceDate,
    String soldTo,
    List<Map<String, dynamic>> items,
  ) async {
    print('Generate PDF NOW');
    try {
      final pdfBytes = await generateInvoicePdf(
        vendorName: vendorName,
        invoiceNumber: invoiceNumber,
        invoiceDate: invoiceDate,
        soldTo: soldTo,
        items: items,
      );

      final ref = FirebaseStorage.instance.ref().child(
        'pdfs/${auth_user?.uid ?? ""}$fileName',
      );
      final uploadTask = await ref.putData(
        pdfBytes,
        SettableMetadata(contentType: 'application/pdf'),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e, stackTrace) {
      print('Error generating PDF: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  String _safeToString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0.00';
    if (value is num) return value.toStringAsFixed(2);
    if (value is String) {
      final numValue = num.tryParse(value);
      return numValue?.toStringAsFixed(2) ?? '0.00';
    }
    return '0.00';
  }
}
