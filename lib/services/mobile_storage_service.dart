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
      version: 2, // Increment the version
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE books(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, author TEXT, rating DOUBLE, imagePath TEXT, isRead INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE books ADD COLUMN imagePath TEXT');
        }
      },
    );
  }

  @override
  Future<Book> insertBook(Book book) async {
    try {
      final db = await database;
      int id = await db.insert('books', book.toMap());
      Book newBook = Book(
        id: id,
        title: book.title,
        author: book.author,
        rating: book.rating,
        imagePath: book.imagePath,
        isRead: book.isRead,
      );
      print("Inserted book with ID: $id");
      return newBook;
    } catch (e) {
      print("Error inserting book: $e");
      throw e;
    }
  }

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

    return maps.map((map) => Book.fromMap(map)).toList();
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

    return maps.map((map) => Book.fromMap(map)).toList();
  }

  @override
  bool get supportsSorting => true;
}
