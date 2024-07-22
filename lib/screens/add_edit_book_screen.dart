import 'dart:io';

import 'package:book_library_app/models/book.dart';
import 'package:book_library_app/providers/book_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  late String _imagePath;
  bool _isRead = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _title = widget.book?.title ?? '';
    _author = widget.book?.author ?? '';
    _rating = widget.book?.rating ?? 0.0;
    _imagePath = widget.book?.imagePath ?? '';
    _isRead = widget.book?.isRead ?? false;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
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
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imagePath.isEmpty
                      ? Center(child: Text('Tap to select image'))
                      : kIsWeb
                          ? Image.network(_imagePath, fit: BoxFit.cover)
                          : Image.file(File(_imagePath), fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16.0),
              Text('Rating', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8.0),
              _buildRatingIcons(),
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
                      var newBook = Book(
                        title: _title,
                        author: _author,
                        rating: _rating,
                        imagePath: _imagePath,
                        isRead: _isRead,
                      );
                      await bookProvider.addBook(newBook);
                    } else {
                      var updatedBook = Book(
                        id: widget.book!.id,
                        title: _title,
                        author: _author,
                        rating: _rating,
                        imagePath: _imagePath,
                        isRead: _isRead,
                      );
                      await bookProvider.updateBook(updatedBook);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.book == null ? 'Add Book' : 'Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build rating icons
  Widget _buildRatingIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            _rating >= index + 1 ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () {
            setState(() {
              _rating = (index + 1).toDouble();
            });
          },
        );
      }),
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
                if (widget.book?.id != null) {
                  await bookProvider.deleteBook(widget.book!.id!);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
