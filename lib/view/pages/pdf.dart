
import 'package:ayurveda/controller/patient_registration.dart';
import 'package:ayurveda/model/branch_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfService {
  static Future<void> generatePatientPdf({
    required String name,
    required String address,
    required String phone,
    required String bookedOn,
    required String treatmentDate,
    required String treatmentTime,
    required List<TreatmentSelection> treatments,
    required double totalAmount,
    required double discount,
    required double advance,
    required double balance,
    required Branch? branch,
  }) async {
    final pdf = pw.Document();
    final imageLogo = pw.MemoryImage(
      (await rootBundle.load('assets/images/app logo ayurveda.png')).buffer.asUint8List(),
    );
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            children: [
              
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [

                  pw.Image(imageLogo,height: 70,width: 70),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'KUMARAKOM',
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                      pw.Text(
                        branch?.address ?? 'Cheepunkal P.O, Kumarakom, Kottayam, Kerala - 686563',
                        style: const pw.TextStyle(fontSize: 10,color: PdfColors.grey),
                      ),
                      pw.Text(
                        'e-mail: ${branch?.mail ?? "unknown@gmail.com"}',
                        style:  pw.TextStyle(fontSize: 10,color: PdfColors.grey),
                      ),
                      pw.Text(
                        'Mob: ${branch?.phone ?? "+91 9876543210"}',
                        style: const pw.TextStyle(fontSize: 10,color: PdfColors.grey),
                      ),
                      if (branch?.gst.isNotEmpty ?? false)
                        pw.Text(
                          'GST No: ${branch?.gst}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text("GST NO: 32AABCU9603R1ZW",style: pw.TextStyle(fontSize: 12,))
                    ],
                  ),
                ],
              ),
                 pw.SizedBox(height:25),

pw.Divider( thickness:  0.3,color: PdfColors.grey),
              pw.SizedBox(height: 25),

              pw.Text(
                'Patient Details',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
              pw.SizedBox(height: 10),
              
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Name: $name',style: pw.TextStyle(color: PdfColors.black)),
                      pw.SizedBox(height: 5),
                      pw.Text('Address: $address',style: pw.TextStyle(color: PdfColors.black)),
                      pw.SizedBox(height: 5),
                      pw.Text('WhatsApp Number: $phone',style: pw.TextStyle(color: PdfColors.black)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Booked On: $bookedOn',style: pw.TextStyle(color: PdfColors.black)),
                      pw.SizedBox(height: 5),
                      pw.Text('Treatment Date: $treatmentDate',style: pw.TextStyle(color: PdfColors.black)),
                      pw.SizedBox(height: 5),
                      pw.Text('Treatment Time: $treatmentTime',style: pw.TextStyle(color: PdfColors.black)),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              pw.Text(
                'Treatment',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Table(
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Treatment', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Male', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Female', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...treatments.map((t) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(t.treatment.name,style: pw.TextStyle(color: PdfColors.grey)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('₹ ${t.treatment.price}',style: pw.TextStyle(color: PdfColors.grey)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${t.maleCount}',style: pw.TextStyle(color: PdfColors.grey)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${t.femaleCount}',style: pw.TextStyle(color: PdfColors.grey)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('₹ ${t.total.toStringAsFixed(0)}',style: pw.TextStyle(color: PdfColors.grey)),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
pw.Divider(thickness:  0.5,color: PdfColors.grey),              pw.SizedBox(height:40),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Total Amount: ₹ ${totalAmount.toStringAsFixed(0)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text('Discount: ₹ ${discount.toStringAsFixed(0)}'),
                    pw.SizedBox(height: 5),
                    pw.Text('Advance: ₹ ${advance.toStringAsFixed(0)}'),
                    pw.SizedBox(height: 5),
                    pw.Text('Balance: ₹ ${balance.toStringAsFixed(0)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),

              pw.Spacer(),

             pw.Align(
              alignment: pw.Alignment.centerRight,
              child:  pw.Column(
                children: [
                  pw.Text(
                    'Thank you for choosing us',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green700,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Your well-being is our commitment, and we\'re honored',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                  ),
                  pw.Text(
                    'you\'ve entrusted us with your health journey',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                  ),
                ],
              ),
             ),

             pw.SizedBox(height: 40),
             pw.Divider(thickness: 0.5,color: PdfColors.grey),
             pw.Text("“Booking amount is non-refundable, and it's important to arrive on the allotted time for your treatment”",style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey))
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}