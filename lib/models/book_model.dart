class BookModel {
  final String? id;
  final String title;
  final String author;
  final int isbn;
  final int quantity;
  final String status;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.quantity,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'isbn': isbn,
      'quantity': quantity,
      'status': status,
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return BookModel(
      id: id,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      isbn: json['isbn'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'Available',
    );
  }
}
