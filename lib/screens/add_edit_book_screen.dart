import 'package:book_library_app/models/book.dart';
import 'package:book_library_app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditBookScreen extends StatefulWidget {
  final Book? book;

  AddEditBookScreen({this.book});

  @override
  _AddEditBookScreenState createState() => _AddEditBookScreenState();
}

class _AddEditBookScreenState extends State<AddEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _author;
  late double _rating;
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _title = widget.book?.title ?? '';
    _author = widget.book?.author ?? '';
    _rating = widget.book?.rating ?? 0.0;
    _isRead = widget.book?.isRead ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
        actions: widget.book != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showConfirmationDialog(context, bookProvider);
                  },
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the book title',
                ),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _author,
                decoration: InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the author\'s name',
                ),
                onSaved: (value) => _author = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an author';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                initialValue: _rating.toString(),
                decoration: InputDecoration(
                  labelText: 'Rating',
                  border: OutlineInputBorder(),
                  hintText: 'Enter the rating (0.0 - 5.0)',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    _rating = double.parse(value);
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rating';
                  }
                  double rating = double.tryParse(value) ?? -1;
                  if (rating < 0 || rating > 5) {
                    return 'Please enter a valid rating (0.0 - 5.0)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Read'),
                value: _isRead,
                onChanged: (value) {
                  setState(() {
                    _isRead = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (widget.book == null) {
                      print("Attempting to add new book: $_title");
                      var newBook = Book(
                        id: 0, // Replace with appropriate logic for generating ID
                        title: _title,
                        author: _author,
                        rating: _rating,
                        isRead: _isRead,
                      );
                      await bookProvider.addBook(newBook);
                    } else {
                      print("Attempting to update book: $_title");
                      var updatedBook = Book(
                        id: widget.book!.id,
                        title: _title,
                        author: _author,
                        rating: _rating,
                        isRead: _isRead,
                      );
                      await bookProvider.updateBook(updatedBook);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.book == null ? 'Add Book' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to show confirmation dialog for deleting a book
  Future<void> _showConfirmationDialog(
      BuildContext context, BookProvider bookProvider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this book?'),
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
                // Directly use widget.book!.id assuming widget.book is not null
                await bookProvider.deleteBook(widget.book!.id);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
