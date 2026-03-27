import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(String email, String password) async {
    await _db.collection('users').doc(email).set({
      'email': email,
      'password': password, // ⚠️ In real apps, hash/encrypt this!
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Validate login by checking Firestore
  Future<bool> validateUser(String email, String password) async {
    final doc = await _db.collection('users').doc(email).get();
    if (!doc.exists) return false;
    final data = doc.data();
    return data?['password'] == password;
  }

  /// Add a book to Firestore
  Future<void> addBook(BookModel book) async {
    await _db.collection('books').add(book.toJson());
  }

  /// Update a book
  Future<void> updateBook(String docId, BookModel book) async {
    await _db.collection('books').doc(docId).update(book.toJson());
  }

  /// Delete a book
  Future<void> deleteBook(String docId) async {
    await _db.collection('books').doc(docId).delete();
  }

  /// Load all books
  Stream<List<BookModel>> getBooks() {
    return _db
        .collection('books')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BookModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
