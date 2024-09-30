import 'dart:developer';

import 'package:invoice_generatorr/headers.dart';

// class InvoiceDetailPage extends StatelessWidget {
//   final Map<String, dynamic> invoice;
//
//   InvoiceDetailPage({required this.invoice});
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> items =
//         List<Map<String, dynamic>>.from(invoice['items']);
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back_ios)),
//         centerTitle: true,
//         title: Text(
//           invoice['invoiceName'] ?? 'Invoice Details',
//           style: TextStyle(
//             fontSize: 25,
//             letterSpacing: 1,
//           ),
//         ),
//         backgroundColor: Color(0xffE3F2FD),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () async {
//               final editedInvoice = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => InvoiceCreationPage(
//                     existingInvoice: invoice,
//                   ),
//                 ),
//               );
//
//               if (editedInvoice != null) {
//                 // Show dialog with original name before updating
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: Text('Confirm Changes'),
//                     content: Text(
//                       'Original Name: ${invoice['invoiceName']}\n\n'
//                       'New Name: ${editedInvoice['invoiceName'] ?? 'No name'}',
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pop(context); // Close dialog
//                         },
//                         child: Text('Cancel'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           // Replace the existing invoice with the edited one
//                           Navigator.pop(context); // Close dialog
//                           Navigator.pop(context, editedInvoice);
//                         },
//                         child: Text('Save Changes'),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             },
//           ),
//           SizedBox(
//             width: 8,
//           )
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '   Invoice Name: ${invoice['invoiceName'] ?? 'Invoice'}',
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 dataTextStyle: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 15.08,
//                 ),
//                 headingTextStyle: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                 ),
//                 headingRowColor: MaterialStateProperty.all(
//                   Color(0xFF0D47A1),
//                 ),
//                 columns: const [
//                   DataColumn(label: Text('Item Name')),
//                   DataColumn(label: Text('Quantity')),
//                   DataColumn(label: Text('Price')),
//                   DataColumn(label: Text('Total')),
//                 ],
//                 rows: items.map((item) {
//                   return DataRow(
//                     color: items.indexOf(item) % 2 == 0
//                         ? MaterialStateProperty.all(Color(0xffE3F2FD))
//                         : MaterialStateProperty.all(Color(0xffBBDEFB)),
//                     cells: [
//                       DataCell(Text(item['name'])),
//                       DataCell(Text(item['quantity'].toString())),
//                       DataCell(Text('\$${item['price'].toStringAsFixed(2)}')),
//                       DataCell(Text('\$${item['total'].toStringAsFixed(2)}')),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Total: \$${invoice['totalAmount'].toStringAsFixed(2)}',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF007BFF),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
//             child: SizedBox(
//               width: double.infinity,
//               child: FloatingActionButton.extended(
//                 backgroundColor: Colors.blue.shade200,
//                 onPressed: () {
//                   log('Invoice Data: $invoice');
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PdfInvoicePage(
//                         invoice: invoice,
//                         items: items,
//                         totalAmount: invoice['totalAmount'],
//                       ),
//                     ),
//                   );
//                 },
//                 label: Text('Generate PDF'),
//                 icon: Icon(Icons.picture_as_pdf),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class InvoiceDetailPage extends StatelessWidget {
  final Map<String, dynamic> invoice;

  InvoiceDetailPage({required this.invoice});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(invoice['items']);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          invoice['invoiceName'] ?? 'Invoice Details',
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xffE3F2FD),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final editedInvoice = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceCreationPage(
                    existingInvoice: invoice,
                  ),
                ),
              );

              if (editedInvoice != null) {
                // Show dialog with original name before updating
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Changes'),
                    content: Text(
                      'Original Name: ${invoice['invoiceName']}\n\n'
                      'New Name: ${editedInvoice['invoiceName'] ?? 'No name'}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Replace the existing invoice with the edited one
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context, editedInvoice);
                        },
                        child: Text('Save Changes'),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '   Invoice Name: ${invoice['invoiceName'] ?? 'Invoice'}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataTextStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.08,
                ),
                headingTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                headingRowColor: MaterialStateProperty.all(
                  Color(0xFF0D47A1),
                ),
                columns: const [
                  DataColumn(label: Text('Item Name')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Total')),
                ],
                rows: items.map((item) {
                  return DataRow(
                    color: items.indexOf(item) % 2 == 0
                        ? MaterialStateProperty.all(Color(0xffE3F2FD))
                        : MaterialStateProperty.all(Color(0xffBBDEFB)),
                    cells: [
                      DataCell(Text(item['name'])),
                      DataCell(Text(item['quantity'].toString())),
                      DataCell(Text('\$${item['price'].toStringAsFixed(2)}')),
                      DataCell(Text('\$${item['total'].toStringAsFixed(2)}')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Total: \$${invoice['totalAmount'].toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007BFF),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            child: SizedBox(
              width: double.infinity,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.blue.shade200,
                onPressed: () {
                  log('Invoice Data: $invoice');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfInvoicePage(
                        invoice: invoice,
                        items: items,
                        totalAmount: invoice['totalAmount'],
                      ),
                    ),
                  );
                },
                label: Text('Generate PDF'),
                icon: Icon(Icons.picture_as_pdf),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
