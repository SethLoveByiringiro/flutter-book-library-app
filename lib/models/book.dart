class Book {
  final int? id; // Change to nullable
  final String title;
  final String author;
  final double rating;
  final String imagePath;
  final bool isRead;

  Book({
    this.id, // Remove 'required' keyword
    required this.title,
    required this.author,
    required this.rating,
    required this.imagePath,
    required this.isRead,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'author': author,
      'rating': rating,
      'imagePath': imagePath,
      'isRead': isRead ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id!;
    }
    return map;
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      author: map['author'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      imagePath: map['imagePath'] as String? ?? '',
      isRead: map['isRead'] == 1,
    );
  }
}
