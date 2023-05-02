import 'dart:io';
import 'package:flutter/material.dart';
import 'blog_item.dart';
import 'package:intl/intl.dart';

class BlogDetails extends StatelessWidget {
  final BlogItem blogItem;

  BlogDetails({required this.blogItem});

  @override
  Widget build(BuildContext context) {
    // Format the date in a more human-readable format. Package: Intl

    // blogItem.date throws an error when we pass it directly to Intl package's DateFormat.
    // So we need to convert it to the required datatype (DateTime from the json
    DateTime convertedDate = DateTime.parse(blogItem.date);

    // I got the format parameters from: https://api.flutter.dev/flutter/intl/DateFormat-class.html
    String formattedDate =
        DateFormat('MMM d, yyyy, HH:mm a').format(convertedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(blogItem.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blogItem.imagePath != null && blogItem.imagePath!.isNotEmpty)
                Image.file(
                  File(blogItem.imagePath!),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16),
              Text(
                blogItem.title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              SizedBox(height: 8),
              Text(
                formattedDate,
                style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              Text(
                blogItem.bodyText,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
