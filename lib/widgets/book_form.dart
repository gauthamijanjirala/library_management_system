import 'package:flutter/material.dart';

class BookForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController isbnController;
  final TextEditingController qtyController;
  final VoidCallback onSubmit;

  const BookForm({
    super.key,
    required this.titleController,
    required this.authorController,
    required this.isbnController,
    required this.qtyController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Book"),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// BOOK IMAGE
            Image.asset("assets/images/book.png", height: 80),

            const SizedBox(height: 20),

            /// TITLE
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            /// AUTHOR
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: "Author",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            /// ISBN
            TextField(
              controller: isbnController,
              decoration: const InputDecoration(
                labelText: "ISBN",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            /// QUANTITY
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),

      actions: [TextButton(onPressed: onSubmit, child: const Text("Save"))],
    );
  }
}
