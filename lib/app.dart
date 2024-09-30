import 'package:flutter/material.dart';

import 'Views/DetailFormPage/details_form_invoice.dart';
import 'Views/HomePage/home_page.dart';
import 'Views/InvoiceCreationPage/invoice_creation_page.dart';
import 'Views/PDF_Page/pdf_page.dart';
import 'Views/invoice_detail_page/invoice_detail_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Invoice Generator',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/detailsForm': (context) => DetailsFormPage(
              onSave: (customerDetails, companyDetails, date, logo) {},
            ),
        '/create-invoice': (context) => InvoiceCreationPage(),
        '/saved-invoices': (context) {
          final invoice = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return InvoiceDetailPage(invoice: invoice);
        },
        '/pdf-invoice': (context) {
          final invoice = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return PdfInvoicePage(
            invoice: invoice,
            items: [],
            totalAmount: 0,
          );
        },
      },
    );
  }
}
