import 'package:invoice_generatorr/Views/DetailFormPage/details_form_invoice.dart';
import 'package:invoice_generatorr/headers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Invoice Generator'),
        backgroundColor: const Color(0xffE3F2FD),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: Globals.savedPdfPaths.isEmpty
          ? const Center(
              child: Text(
                'No invoices created yet',
                style: TextStyle(fontSize: 18, color: Color(0xFF333333)),
              ),
            )
          : ListView.builder(
              itemCount: Globals.savedPdfPaths.length,
              itemBuilder: (context, index) {
                final filePath = Globals.savedPdfPaths[index];
                final fileName = filePath.split('/').last;

                return Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    left: 16,
                    top: 10,
                  ),
                  child: Dismissible(
                    key: Key(filePath),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        Globals.savedPdfPaths.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$fileName deleted'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xffE3F2FD),
                        maxRadius: 30,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      tileColor: const Color(0xffBBDEFB),
                      title: Text(fileName),
                      subtitle: Text('Saved Path: $filePath'),
                      onTap: () {
                        OpenFile.open(filePath);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff64B5F6),
        onPressed: () async {
          final newInvoice = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsFormPage(
                onSave: (customerDetails, companyDetails, date, logo) {},
              ),
            ),
          );
          // Check if a new invoice was returned from the DetailsFormPage
          if (newInvoice != null && newInvoice is Map<String, dynamic>) {
            setState(() {
              Globals.invoices.add(newInvoice);
            });
          }
        },
        label: const Text('New Invoice'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
