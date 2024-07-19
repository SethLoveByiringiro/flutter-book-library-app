class Book {
  late int id; // Marking id as late

  final String title;
  final String author;
  final double rating;
  final bool isRead;

  Book({
    required this.title,
    required this.author,
    required this.rating,
    required this.isRead,
    this.id = 0, // Provide a default value for id
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id' is omitted because SQLite will assign it
      'title': title,
      'author': author,
      'rating': rating,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'],
      author: map['author'],
      rating: map['rating'],
      isRead: map['isRead'] == 1,
    );
  }
}
