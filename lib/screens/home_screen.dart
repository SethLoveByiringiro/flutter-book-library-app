import 'package:book_library_app/app_state.dart';
import 'package:book_library_app/models/book.dart';
import 'package:book_library_app/providers/book_provider.dart';
import 'package:book_library_app/screens/add_edit_book_screen.dart';
import 'package:book_library_app/screens/book_detail_screen.dart';
import 'package:book_library_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    print('HomeScreen initState called');
    _loadBooks();
  }

  void _loadBooks() async {
    print('Loading books');
    await Provider.of<BookProvider>(context, listen: false).fetchBooks();
    print('Books loaded');
  }

  @override
  Widget build(BuildContext context) {
    print('HomeScreen build method called');
    final bookProvider = Provider.of<BookProvider>(context);
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Book Library'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildBookList(bookProvider, appState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddBook(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search books...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildBookList(BookProvider bookProvider, AppState appState) {
    if (bookProvider.books.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    List<Book> filteredBooks = bookProvider.books.where((book) {
      return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Apply sorting
    filteredBooks.sort((a, b) {
      switch (appState.sortingCriteria) {
        case 'title':
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case 'author':
          return a.author.toLowerCase().compareTo(b.author.toLowerCase());
        case 'rating':
          return b.rating.compareTo(a.rating);
        default:
          return 0;
      }
    });

    return ListView.builder(
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) {
        final book = filteredBooks[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          trailing: Text('Rating: ${book.rating.toStringAsFixed(1)}'),
          onTap: () => _navigateToBookDetails(context, book),
          onLongPress: () => _showBookOptions(context, book),
        );
      },
    );
  }

  void _showBookOptions(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToEditBook(context, book);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmationDialog(context, book);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context, Book book) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "${book.title}"?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await Provider.of<BookProvider>(context, listen: false)
                    .deleteBook(book.id);
                Navigator.of(context).pop();
                _loadBooks();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSettings(BuildContext context) async {
    print('Navigating to Settings');
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
    _loadBooks(); // Refresh list when returning from settings
  }

  void _navigateToAddBook(BuildContext context) async {
    print('Navigating to Add Book');
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen()),
    );
    _loadBooks(); // Refresh list after adding a book
  }

  void _navigateToEditBook(BuildContext context, Book book) async {
    print('Navigating to Edit Book for ${book.title}');
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
    );
    _loadBooks(); // Refresh list after editing a book
  }

  void _navigateToBookDetails(BuildContext context, Book book) async {
    print('Navigating to Book Details for ${book.title}');
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
    );
    _loadBooks(); // Refresh list after potentially editing a book
  }
}
