import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<BookModel> books = [];

  // Load all books from Firestore
  Future<void> loadBooks() async {
    final snapshot = await _firestore.collection('books').get();
    books = snapshot.docs
        .map((doc) => BookModel.fromJson(doc.data(), id: doc.id))
        .toList();
    notifyListeners();
  }

  // Add a new book
  Future<void> addBook(BookModel book) async {
    await _firestore.collection('books').add(book.toJson());
    print("Book added: ${book.title}");
    await loadBooks(); // refresh the list
  }

  // Update existing book
  Future<void> updateBook(String docId, BookModel book) async {
    await _firestore.collection('books').doc(docId).update(book.toJson());
    await loadBooks();
  }

  // Delete book
  Future<void> deleteBook(String docId) async {
    await _firestore.collection('books').doc(docId).delete();
    await loadBooks();
  }

  // Toggle issued/available
  Future<void> toggleIssued(String docId, BookModel current) async {
    final updated = BookModel(
      title: current.title,
      author: current.author,
      isbn: current.isbn,
      quantity: current.quantity,
      status: current.status.toLowerCase() == "issued" ? "Available" : "Issued",
    );
    await _firestore.collection('books').doc(docId).update(updated.toJson());
    await loadBooks();
  }
}
