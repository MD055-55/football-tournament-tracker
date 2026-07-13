import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String tournamentId;
  final String title;
  final String content;
  final String? imageUrl;
  final String author;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  News({
    required this.id,
    required this.tournamentId,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory News.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return News(
      id: doc.id,
      tournamentId: data['tournamentId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      author: data['author'] ?? '',
      publishedAt: (data['publishedAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tournamentId': tournamentId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'author': author,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  News copyWith({
    String? id,
    String? tournamentId,
    String? title,
    String? content,
    String? imageUrl,
    String? author,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return News(
      id: id ?? this.id,
      tournamentId: tournamentId ?? this.tournamentId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
