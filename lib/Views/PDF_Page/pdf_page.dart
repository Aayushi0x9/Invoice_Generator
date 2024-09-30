import 'package:invoice_generatorr/headers.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfInvoicePage extends StatefulWidget {
  final Map<String, dynamic> invoice;
  final List<Map<String, dynamic>> items;
  final double totalAmount;

  PdfInvoicePage({
    required this.invoice,
    required this.items,
    required this.totalAmount,
  });

  @override
  State<PdfInvoicePage> createState() => _PdfInvoicePageState();
}

class _PdfInvoicePageState extends State<PdfInvoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text(
          'Invoice PDF',
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xffE3F2FD), // Primary color
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format, widget.invoice),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final pdfData =
                await _generatePdf(PdfPageFormat.a4, widget.invoice);
            await _savePdf(context, pdfData);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to generate the PDF: ${e.toString()}'),
              ),
            );
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, Map<String, dynamic> invoice) async {
    final pdf = pw.Document();

    final logo =
        invoice['logo'] != null && File(invoice['logo']!.path).existsSync()
            ? File(invoice['logo']!.path)
            : null;

    final customerDetails = invoice['customerDetails'] ?? {};
    final companyDetails = invoice['companyDetails'] ?? {};
    final items = invoice['items'] ?? [];
    final totalAmount = invoice['totalAmount'] ?? 0.0;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 100,
                    height: 100,
                    decoration: pw.BoxDecoration(
                      shape: pw.BoxShape.circle,
                      color: PdfColors.grey300,
                    ),
                    child: logo != null
                        ? pw.ClipRRect(
                            horizontalRadius: 50,
                            verticalRadius: 50,
                            child: pw.Image(
                              pw.MemoryImage(logo.readAsBytesSync()),
                              width: 80,
                              height: 80,
                            ),
                          )
                        : pw.Center(
                            child: pw.Stack(
                              alignment: pw.Alignment.center,
                              children: [
                                pw.Container(
                                  width: 50,
                                  height: 50,
                                  decoration: pw.BoxDecoration(
                                    shape: pw.BoxShape.circle,
                                    color: PdfColors.white,
                                  ),
                                ),
                                pw.Container(
                                  width: 20,
                                  height: 4,
                                  color: PdfColors.blue,
                                ),
                                pw.Container(
                                  width: 4,
                                  height: 20,
                                  color: PdfColors.blue,
                                ),
                              ],
                            ),
                          ),
                  ),
                  pw.SizedBox(width: 50),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Invoice',
                        style: pw.TextStyle(
                          fontSize: 32,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Date          : ${Globals.selectedDate != null ? Globals.selectedDate?.toLocal().toString().split(' ')[0] : 'N/A'}',
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Customer : ${Globals.customerDetails?.entries.elementAt(0).value ?? 'N/A'}',
                      ),
                      pw.Text(
                        'Address   : ${Globals.customerDetails?.entries.elementAt(1).value ?? 'N/A'}',
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Company :  ${Globals.companyDetails?.entries.elementAt(0).value ?? 'N/A'}',
                      ),
                      pw.Text(
                        'Address   :  ${Globals.companyDetails?.entries.elementAt(1).value ?? 'N/A'}',
                      ),
                    ],
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Invoice Items',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Description', 'Quantity', 'Unit Price', 'Total'],
                data: items.map<List<dynamic>>((item) {
                  return [
                    item['name'] ?? 'N/A',
                    item['quantity'].toString(),
                    '\$${item['price'].toStringAsFixed(2)}',
                    '\$${item['total'].toStringAsFixed(2)}',
                  ];
                }).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blue,
                ),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerRight,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                },
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _savePdf(BuildContext context, Uint8List pdfData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/Invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
      setState(() {
        Globals.savedPdfPaths.add(filePath);
        // Add invoice to global list
        Globals.invoices.add({
          'invoiceName': widget.invoice['invoiceName'] ??
              'Invoice ${Globals.invoices.length + 1}',
          'totalAmount': widget.totalAmount,
          'filePath': filePath,
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice saved successfully!'),
        ),
      );

      Navigator.pop(context, true);
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save the invoice: ${e.toString()}'),
        ),
      );
    }
  }
}
