// lib/screens/book_detail_screen.dart
import 'package:book_library_app/models/book.dart';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  BookDetailScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title: ${book.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Author: ${book.author}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Rating: ${book.rating}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Read: ${book.isRead ? 'Yes' : 'No'}',
                style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
