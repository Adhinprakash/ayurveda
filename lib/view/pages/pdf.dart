
import 'package:ayurveda/controller/patient_registration.dart';
import 'package:ayurveda/model/branch_model.dart';
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

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with Logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'KUMARAKOM',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green700,
                        ),
                      ),
                      pw.Text(
                        branch?.address ?? 'Cheepunkal P.O, Kumarakom, Kottayam, Kerala - 686563',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'e-mail: ${branch?.mail ?? "unknown@gmail.com"}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        'Mob: ${branch?.phone ?? "+91 9876543210"}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      if (branch?.gst.isNotEmpty ?? false)
                        pw.Text(
                          'GST No: ${branch?.gst}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Patient Details
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
                      pw.Text('Name: $name'),
                      pw.SizedBox(height: 5),
                      pw.Text('Address: $address'),
                      pw.SizedBox(height: 5),
                      pw.Text('WhatsApp Number: $phone'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Booked On: $bookedOn'),
                      pw.SizedBox(height: 5),
                      pw.Text('Treatment Date: $treatmentDate'),
                      pw.SizedBox(height: 5),
                      pw.Text('Treatment Time: $treatmentTime'),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 30),

              // Treatment Table
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
                border: pw.TableBorder.all(color: PdfColors.grey400),
                children: [
                  // Header
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
                  // Data rows
                  ...treatments.map((t) {
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(t.treatment.name),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('₹${t.treatment.price}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${t.maleCount}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('${t.femaleCount}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('₹${t.total.toStringAsFixed(0)}'),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 20),

              // Amount Summary
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Total Amount: ₹${totalAmount.toStringAsFixed(0)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 5),
                    pw.Text('Discount: ₹${discount.toStringAsFixed(0)}'),
                    pw.SizedBox(height: 5),
                    pw.Text('Advance: ₹${advance.toStringAsFixed(0)}'),
                    pw.SizedBox(height: 5),
                    pw.Text('Balance: ₹${balance.toStringAsFixed(0)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),

              pw.Spacer(),

              // Thank you message
              pw.Center(
                child: pw.Column(
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
            ],
          );
        },
      ),
    );

    // Print or save PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }
}