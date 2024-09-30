import 'package:invoice_generatorr/headers.dart';

class DetailsFormPage extends StatefulWidget {
  final Function(Map<String, dynamic> customerDetails,
      Map<String, dynamic> companyDetails, DateTime date, File? logo) onSave;

  DetailsFormPage({required this.onSave});

  @override
  _DetailsFormPageState createState() => _DetailsFormPageState();
}

class _DetailsFormPageState extends State<DetailsFormPage> {
  final _formKey = GlobalKey<FormState>();
  final customerNameController = TextEditingController();
  final customerAddressController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  DateTime? _selectedDate;
  File? _logo;
  bool show = false;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickLogo(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _logo = File(pickedFile.path);
      });
    }
  }

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
          'Enter Details',
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xffE3F2FD), // Primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: customerAddressController,
                  decoration: InputDecoration(labelText: 'Customer Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: companyNameController,
                  decoration: InputDecoration(labelText: 'Company Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: companyAddressController,
                  decoration: InputDecoration(labelText: 'Company Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => _pickDate(context),
                      child: Text('Pick Date'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _logo == null
                        ? Text('No logo selected')
                        : Image.file(_logo!, width: 50, height: 50),
                    ElevatedButton.icon(
                      onPressed: () => _pickLogo(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text('Gallery'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickLogo(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Camera'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final customerDetails = {
                        'name': customerNameController.text,
                        'address': customerAddressController.text,
                      };
                      final companyDetails = {
                        'name': companyNameController.text,
                        'address': companyAddressController.text,
                      };
                      print(customerDetails);
                      print(companyDetails);
                      print(Globals.logo);
                      print(_selectedDate);

                      final newInvoice = {
                        'customerDetails': customerDetails,
                        'companyDetails': companyDetails,
                        'date': _selectedDate ?? DateTime.now(),
                        'logo': _logo,
                        'invoiceName':
                            'Invoice #${Globals.invoices.length + 1}', // Example name
                        'totalAmount':
                            0.0, // You might update this with actual calculations
                      };
                      // Store the details in Globals
                      Globals.customerDetails = customerDetails;
                      Globals.companyDetails = companyDetails;
                      Globals.selectedDate = _selectedDate ?? DateTime.now();
                      Globals.logo = _logo;

                      widget.onSave(
                        customerDetails,
                        companyDetails,
                        _selectedDate ?? DateTime.now(),
                        _logo,
                      );

                      setState(() {
                        show = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                  ),
                  child: Text('Save Details'),
                ),
                Visibility(
                  visible: show == true,
                  child: SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      extendedPadding: EdgeInsets.all(20),
                      backgroundColor: Colors.blue.shade200,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InvoiceCreationPage(),
                          ),
                        );
                      },
                      label: Text('Generate Invoice'),
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
