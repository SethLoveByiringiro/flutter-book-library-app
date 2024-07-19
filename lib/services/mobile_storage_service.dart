import 'package:book_library_app/models/book.dart';
import 'package:book_library_app/services/storage_service.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MobileStorageService implements StorageService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, rating DOUBLE, isRead INTEGER)',
        );
      },
    );
  }

  @override
  Future<Book> insertBook(Book book) async {
    try {
      final db = await database;
      int id = await db.insert('books', book.toMap());
      book.id = id; // Assign the generated ID back to the book object
      print("Inserted book with ID: $id");
      return book;
    } catch (e) {
      print("Error inserting book: $e");
      throw e; // Rethrow the exception to handle it further up the chain
    }
  }

  // Implement other methods like updateBook, deleteBook, getBooks, etc.

  @override
  Future<Book> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
    print("Updated book with ID: ${book.id}");
    return book;
  }

  @override
  Future<void> deleteBook(int id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    print("Deleted book with ID: $id");
  }

  @override
  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    print("Fetched ${maps.length} books from database");

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        rating: maps[i]['rating'],
        isRead: maps[i]['isRead'] == 1,
      );
    });
  }

  @override
  Future<List<Book>> getBooksSorted(String sortingCriteria) async {
    final db = await database;
    String orderBy;
    switch (sortingCriteria) {
      case 'title':
        orderBy = 'title ASC';
        break;
      case 'author':
        orderBy = 'author ASC';
        break;
      case 'rating':
        orderBy = 'rating DESC, title ASC';
        break;
      default:
        orderBy = 'title ASC';
        break;
    }

    final List<Map<String, dynamic>> maps =
        await db.query('books', orderBy: orderBy);
    print("Fetched ${maps.length} sorted books from database");

    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        rating: maps[i]['rating'],
        isRead: maps[i]['isRead'] == 1,
      );
    });
  }

  @override
  bool get supportsSorting => true;
}
