import 'package:book_library_app/models/book.dart';
import 'package:book_library_app/services/database_helper.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> fetchBooks() async {
    print("Fetching books from storage...");
    List<Book> fetchedBooks = await DatabaseHelper().storageService.getBooks();
    _books.clear(); // Clear existing books
    _books.addAll(fetchedBooks); // Add fetched books to the list
    print("Books fetched: ${_books.length}");
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    print("Attempting to add new book: ${book.title}");
    try {
      final newBook = await DatabaseHelper().storageService.insertBook(book);
      _books.add(newBook);
      print("New book added with ID: ${newBook.id}");
      notifyListeners();
    } catch (e) {
      print("Error adding book: $e");
    }
  }

  Future<void> updateBook(Book book) async {
    print("Attempting to update book: ${book.title} with ID: ${book.id}");
    final updatedBook = await DatabaseHelper().storageService.updateBook(book);
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = updatedBook;
      notifyListeners();
    }
  }

  Future<void> deleteBook(int id) async {
    print("Attempting to delete book with ID: $id");
    await DatabaseHelper().storageService.deleteBook(id);
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}
