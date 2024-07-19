import 'package:book_library_app/models/book.dart';
import 'package:book_library_app/services/storage_service.dart';

class WebStorageService implements StorageService {
  List<Book> _books = [];

  @override
  Future<Book> insertBook(Book book) async {
    // Ensure the book ID is unique
    final newId = _books.isNotEmpty ? _books.last.id + 1 : 1;
    final newBook = Book(
      id: newId,
      title: book.title,
      author: book.author,
      rating: book.rating,
      isRead: book.isRead,
    );
    _books.add(newBook);
    print("Inserted book with ID: ${newBook.id}");
    return newBook;
  }

  @override
  Future<Book> updateBook(Book book) async {
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = book;
      print("Updated book with ID: ${book.id}");
    }
    return book;
  }

  @override
  Future<void> deleteBook(int id) async {
    _books.removeWhere((b) => b.id == id);
    print("Deleted book with ID: $id");
  }

  @override
  Future<List<Book>> getBooks() async {
    print("Fetched ${_books.length} books from memory");
    return _books;
  }

  @override
  Future<List<Book>> getBooksSorted(String sortingCriteria) async {
    List<Book> sortedBooks = List.from(_books);
    sortedBooks.sort((a, b) {
      switch (sortingCriteria) {
        case 'title':
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case 'author':
          return a.author.toLowerCase().compareTo(b.author.toLowerCase());
        case 'rating':
          int ratingCompare = b.rating.compareTo(a.rating);
          return ratingCompare != 0
              ? ratingCompare
              : a.title.toLowerCase().compareTo(b.title.toLowerCase());
        default:
          return 0;
      }
    });
    print("Fetched ${sortedBooks.length} sorted books from memory");
    return sortedBooks;
  }

  @override
  bool get supportsSorting => true;
}
