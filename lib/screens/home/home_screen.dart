import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../models/book_model.dart';
import '';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showBookForm(BuildContext context, {BookModel? book}) {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController = TextEditingController(text: book?.author ?? '');
    final isbnController = TextEditingController(
      text: book?.isbn.toString() ?? '',
    );
    final quantityController = TextEditingController(
      text: book?.quantity.toString() ?? '',
    );
    String selectedStatus = book?.status ?? "Available";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(book == null ? "Add Book" : "Edit Book"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(labelText: "Author"),
              ),
              TextFormField(
                controller: isbnController,
                decoration: const InputDecoration(labelText: "ISBN"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: "Quantity"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                items: ["Available", "Issued"]
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) => selectedStatus = value!,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newBook = BookModel(
                  title: titleController.text,
                  author: authorController.text,
                  isbn: int.tryParse(isbnController.text) ?? 0,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  status: selectedStatus,
                );

                final provider = Provider.of<BookProvider>(
                  context,
                  listen: false,
                );

                if (book == null) {
                  provider.addBook(newBook);
                } else {
                  provider.updateBook(book.id!, newBook);
                }

                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    final totalBooks = bookProvider.books.length;
    final issuedBooks = bookProvider.books
        .where((book) => book.status.toLowerCase() == "issued")
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Library Management"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // summary cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    "Total Books",
                    totalBooks.toString(),
                    Colors.indigo,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    "Issued Books",
                    issuedBooks.toString(),
                    const Color.fromRGBO(2, 102, 34, 1),
                  ),
                ),
              ],
            ),
          ),
          // table
          Expanded(
            child: bookProvider.books.isEmpty
                ? const Center(child: Text("No books available"))
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.indigo.shade100,
                        ),
                        columns: const [
                          DataColumn(label: Text("Title")),
                          DataColumn(label: Text("Author")),
                          DataColumn(label: Text("ISBN")),
                          DataColumn(label: Text("Quantity")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: bookProvider.books.map((book) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Image.asset(
                                  "assets/images/image1.jpg",
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              DataCell(Text(book.title)),
                              DataCell(Text(book.author)),
                              DataCell(Text(book.isbn.toString())),
                              DataCell(Text(book.quantity.toString())),
                              DataCell(Text(book.status)),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () =>
                                          _showBookForm(context, book: book),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        Provider.of<BookProvider>(
                                          context,
                                          listen: false,
                                        ).deleteBook(book.id!);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.swap_horiz,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        Provider.of<BookProvider>(
                                          context,
                                          listen: false,
                                        ).toggleIssued(book.id!, book);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () => _showBookForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
