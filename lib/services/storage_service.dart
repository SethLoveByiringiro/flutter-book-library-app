import 'package:book_library_app/models/book.dart';

abstract class StorageService {
  Future<Book> insertBook(Book book);
  Future<Book> updateBook(Book book);
  Future<void> deleteBook(int id);
  Future<List<Book>> getBooks();
  Future<List<Book>> getBooksSorted(String sortingCriteria);
  bool get supportsSorting;
}
