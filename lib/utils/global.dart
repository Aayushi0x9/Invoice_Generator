import 'dart:io';

class Globals {
  Globals._(); // Private constructor to prevent instantiation
  static Globals globals = Globals._();
  static List<String> savedPdfPaths = [];
  // Global list to store invoices
  static List<Map<String, dynamic>> invoices = [];

  // You can add other global variables here, for example:
  static Map<String, dynamic>? customerDetails;
  static Map<String, dynamic>? companyDetails;
  static DateTime? selectedDate;
  static File? logo;
}
