import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String author;
  final String content;
  final double? rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.author,
    required this.content,
    this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      rating: (json['author_details']?['rating'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  factory Review.fromFirestore(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '', // Firestore doc ID is not in the data
      author: json['author'],
      content: json['content'],
      rating: (json['rating'] as num?)?.toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
