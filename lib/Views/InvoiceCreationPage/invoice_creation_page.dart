import 'package:invoice_generatorr/headers.dart';

class InvoiceCreationPage extends StatefulWidget {
  final Map<String, dynamic>? existingInvoice;

  InvoiceCreationPage({this.existingInvoice});

  @override
  _InvoiceCreationPageState createState() => _InvoiceCreationPageState();
}

class _InvoiceCreationPageState extends State<InvoiceCreationPage> {
  List<Map<String, dynamic>> items = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.existingInvoice != null) {
      items = List<Map<String, dynamic>>.from(widget.existingInvoice!['items']);
      totalAmount = widget.existingInvoice!['totalAmount'];
    }
  }

  void _addItem(Map<String, dynamic> item) {
    setState(() {
      items.add(item);
      totalAmount += item['total'];
    });
  }

  void _removeItem(int index) {
    setState(() {
      totalAmount -= items[index]['total'];
      items.removeAt(index);
    });
  }

  void _saveInvoice() async {
    TextEditingController invoiceNameController = TextEditingController();
    invoiceNameController.text = widget.existingInvoice?['invoiceName'] ?? '';

    final invoiceName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: const Text('Enter Invoice Name'),
          content: TextField(
            controller: invoiceNameController,
            decoration: const InputDecoration(
              hintText: 'Invoice Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFBBDEFB)),
              ),
              onPressed: () {
                Navigator.pop(context,
                    invoiceNameController.text); // Return the invoice name
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (invoiceName != null && invoiceName.isNotEmpty) {
      final invoice = {
        'invoiceName': invoiceName,
        'invoiceNumber': widget.existingInvoice?['invoiceNumber'] ??
            DateTime.now().millisecondsSinceEpoch,
        'items': items,
        'totalAmount': totalAmount,
      };
      Navigator.pop(context);
      Navigator.pop(context, invoice);
    }
  }

  void _showAddItemDialog() {
    TextEditingController itemNameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFBBDEFB)),
              ),
              onPressed: () {
                final itemName = itemNameController.text;
                final quantity = int.parse(quantityController.text);
                final price = double.parse(priceController.text);
                final total = quantity * price;

                _addItem({
                  'name': itemName,
                  'quantity': quantity,
                  'price': price,
                  'total': total,
                });

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: const Text(
          'Generate Invoice',
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xffE3F2FD),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
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
                  rows: items.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> item = entry.value;
                    return DataRow(
                      color: index % 2 == 0
                          ? MaterialStateProperty.all(Color(0xffE3F2FD))
                          : MaterialStateProperty.all(Color(0xffBBDEFB)),
                      cells: [
                        DataCell(Text(item['name'])),
                        DataCell(Text(item['quantity'].toString())),
                        DataCell(Text('${item['price'].toStringAsFixed(2)}')),
                        DataCell(Text('${item['total'].toStringAsFixed(2)}')),
                      ],
                      onLongPress: () => _removeItem(index),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Total: ${totalAmount.toStringAsFixed(2)} Rs.',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF007BFF),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FloatingActionButton.extended(
                          heroTag: 'invoiceSaveFab',
                          backgroundColor: Colors.blue.shade200,
                          onPressed: _saveInvoice,
                          label: Text('Save Invoice'),
                          icon: Icon(Icons.save),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FloatingActionButton.extended(
                          backgroundColor: Colors.blue.shade200,
                          heroTag: 'addItemsFab',
                          onPressed: _showAddItemDialog,
                          label: Text('Add Items'),
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'generatePdfFab',
                    backgroundColor: Colors.blue.shade200,
                    onPressed: () {
                      final invoice = {
                        'invoiceName': 'Invoice', // Default or custom name
                        'invoiceNumber': DateTime.now().millisecondsSinceEpoch,
                        'items': items,
                        'totalAmount': totalAmount,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfInvoicePage(
                            invoice: invoice,
                            items: items,
                            totalAmount: totalAmount,
                          ),
                        ),
                      );
                    },
                    label: Text('Generate PDF'),
                    icon: Icon(Icons.picture_as_pdf),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
