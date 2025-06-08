import 'dart:io';
import 'package:csv/csv.dart';
import 'package:dongi/modules/expense/domain/controllers/category_controller.dart';
import 'package:dongi/modules/home/domain/controllers/home_transactions_controller.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  // Get a directory that's guaranteed to be accessible
  Future<Directory> _getSafeDirectory() async {
    try {
      // First try to get the cache directory - this doesn't need permissions on any Android version
      return await getTemporaryDirectory();
    } catch (e) {
      // If that fails, try the app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      return appDir;
    }
  }

  // Function to export transactions as PDF
  Future<File?> exportToPdf(List<RecentTransactionModel> transactions,
      List<Category> categories) async {
    final pdf = pw.Document();

    // Add title page
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Transaction History',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.15),
                  1: const pw.FractionColumnWidth(0.2),
                  2: const pw.FractionColumnWidth(0.2),
                  3: const pw.FractionColumnWidth(0.15),
                  4: const pw.FractionColumnWidth(0.15),
                  5: const pw.FractionColumnWidth(0.15),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Date',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Title',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Category',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Amount',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Type',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Status',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...transactions.map((transaction) {
                    final category = categories.firstWhere(
                      (c) => c.id == transaction.categoryId,
                      orElse: () => Category(
                        name: 'Other',
                        icon: 'others',
                      ),
                    );

                    String formattedDate = '';
                    try {
                      if (transaction.createdAt.isNotEmpty) {
                        formattedDate = DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(transaction.createdAt));
                      }
                    } catch (e) {
                      formattedDate = 'Unknown';
                    }

                    return pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(formattedDate),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(transaction.title),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(category.name),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              '\$${transaction.cost.toStringAsFixed(2)}'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child:
                              pw.Text(transaction.equal ? 'Equal' : 'Unequal'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              transaction.isSettled ? 'Settled' : 'Unsettled'),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );

    try {
      // Save the PDF file to a safe directory
      final output = await _getSafeDirectory();
      final file = File(
          '${output.path}/transactions_${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());
      return file;
    } catch (e) {
      print('Error saving PDF file: $e');
      return null;
    }
  }

  // Function to export transactions as CSV
  Future<File?> exportToCsv(List<RecentTransactionModel> transactions,
      List<Category> categories) async {
    // Prepare CSV data
    List<List<dynamic>> csvData = [];

    // Add header row
    csvData.add([
      'Date',
      'Title',
      'Description',
      'Category',
      'Amount',
      'Equal Split',
      'Status',
      'Created By',
      'Paid By'
    ]);

    // Add data rows
    for (var transaction in transactions) {
      final category = categories.firstWhere(
        (c) => c.id == transaction.categoryId,
        orElse: () => Category(
          name: 'Other',
          icon: 'others',
        ),
      );

      String formattedDate = '';
      try {
        if (transaction.createdAt.isNotEmpty) {
          formattedDate = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(transaction.createdAt));
        }
      } catch (e) {
        formattedDate = 'Unknown';
      }

      csvData.add([
        formattedDate,
        transaction.title,
        transaction.description ?? '',
        category.name,
        '\$${transaction.cost.toStringAsFixed(2)}',
        transaction.equal ? 'Equal' : 'Unequal',
        transaction.isSettled ? 'Settled' : 'Unsettled',
        transaction.creatorId,
        transaction.payerId,
      ]);
    }

    // Convert to CSV string
    String csv = const ListToCsvConverter().convert(csvData);

    try {
      // Save CSV file to a safe directory
      final output = await _getSafeDirectory();
      final file = File(
          '${output.path}/transactions_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);
      return file;
    } catch (e) {
      print('Error saving CSV file: $e');
      return null;
    }
  }

  // Function to export transactions as Excel
  Future<File?> exportToExcel(List<RecentTransactionModel> transactions,
      List<Category> categories) async {
    // Create a new Excel document
    final excel = Excel.createExcel();
    final sheet = excel['Transactions'];

    // Add header row with styling
    final headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    final headers = [
      'Date',
      'Title',
      'Description',
      'Category',
      'Amount',
      'Equal Split',
      'Status',
      'Created By',
      'Paid By'
    ];

    // Add headers
    for (var i = 0; i < headers.length; i++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Add data rows
    for (var i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];
      final category = categories.firstWhere(
        (c) => c.id == transaction.categoryId,
        orElse: () => Category(
          name: 'Other',
          icon: 'others',
        ),
      );

      String formattedDate = '';
      try {
        if (transaction.createdAt.isNotEmpty) {
          formattedDate = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(transaction.createdAt));
        }
      } catch (e) {
        formattedDate = 'Unknown';
      }

      final rowData = [
        formattedDate,
        transaction.title,
        transaction.description ?? '',
        category.name,
        '\$${transaction.cost.toStringAsFixed(2)}',
        transaction.equal ? 'Equal' : 'Unequal',
        transaction.isSettled ? 'Settled' : 'Unsettled',
        transaction.creatorId,
        transaction.payerId,
      ];

      // Add row data
      for (var j = 0; j < rowData.length; j++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
          ..value = TextCellValue(rowData[j]);
      }
    }

    // Auto fit columns
    for (var i = 0; i < headers.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    try {
      // Save Excel file to a safe directory
      final output = await _getSafeDirectory();
      final file = File(
          '${output.path}/transactions_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(excel.encode()!);
      return file;
    } catch (e) {
      print('Error saving Excel file: $e');
      return null;
    }
  }

  // Function to share the exported file
  Future<void> shareFile(File file) async {
    try {
      print('Sharing file: ${file.path}');
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      print('Error sharing file: $e');
    }
  }

  // This method is kept for backward compatibility but no longer used
  Future<bool> requestStoragePermission() async {
    return true; // Always return true since we're using a different approach now
  }
}
