import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'blog_item.dart';

class AddEditBlogItem extends StatefulWidget {
  final BlogItem? blogItem;

  AddEditBlogItem({this.blogItem});

  @override
  _AddEditBlogItemState createState() => _AddEditBlogItemState();
}

class _AddEditBlogItemState extends State<AddEditBlogItem> {
  String _title = '';
  String _bodyText = '';
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.blogItem != null) {
      _title = widget.blogItem!.title;
      _bodyText = widget.blogItem!.bodyText;
      _imagePath = widget.blogItem!.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = pickedFile?.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.blogItem == null ? 'Add Blog Item' : 'Edit Blog Item'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Blog Title'),
                onChanged: (value) => _title = value,
                initialValue: _title,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Blog body content...'),
                onChanged: (value) => _bodyText = value,
                initialValue: _bodyText,
                maxLines: 10,
              ),
              SizedBox(height: 16),
              if (_imagePath != null)
                Image.file(
                  File(_imagePath!),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_title.isNotEmpty && _bodyText.isNotEmpty) {
            final blogItem = BlogItem(
              title: _title,
              date: DateTime.now().toString(),
              bodyText: _bodyText,
              imagePath: _imagePath,
            );
            Navigator.pop(context, blogItem);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
