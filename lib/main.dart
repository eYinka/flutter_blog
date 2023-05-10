import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'blog_item.dart';
import 'json_storage.dart';
import 'add_edit_blog_item.dart';
import 'blog_details.dart';
import 'package:intl/intl.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    title: 'My Blog App',
    theme: ThemeData(primarySwatch: Colors.deepPurple),
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  List<BlogItem> _blogItems = [];
  String searchText = '';
  final StorageClass _storageFunction = StorageClass();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBlogItems();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _storageFunction.writeBlogItems(_blogItems);
    }
  }

  Future<void> _loadBlogItems() async {
    List<BlogItem> blogItems = await _storageFunction.readBlogItems();
    setState(() {
      _blogItems = blogItems;
    });
  }

  void _addBlogItem(BlogItem newBlogItem) {
    setState(() {
      _blogItems.add(newBlogItem);
    });
  }

  void _editBlogItem(int index, BlogItem editedBlogItem) {
    setState(() {
      _blogItems[index] = editedBlogItem;
    });
  }

  void _deleteBlogItem(int index) {
    setState(() {
      _blogItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the results if user has searched for something in the blog
    // Idea from little javascript knowledge :)

    final filteredBlogItems = _blogItems.where((blogItem) {
      return blogItem.title.toLowerCase().contains(searchText.toLowerCase()) ||
          blogItem.bodyText.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: TextField(
        decoration: InputDecoration(
          hintText: ' Click to search blog items...',
          hintStyle: TextStyle(color: Colors.white, fontSize: 14),
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          contentPadding: EdgeInsets.all(20),
        ),
        maxLines: 1,
        autofocus: false,
        cursorColor: Colors.white,
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        style: TextStyle(color: Colors.white),
      )),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        itemCount: filteredBlogItems.length,
        itemBuilder: (context, index) {
          final blogItem = filteredBlogItems[index];

          // Format the date in a more human-readable format. Package: Intl

          // blogItem.date throws an error when we pass it directly to Intl package's DateFormat.
          // So we need to convert it to the required datatype (DateTime from the json)
          DateTime convertedDate = DateTime.parse(blogItem.date);

          // I got the format parameters from: https://api.flutter.dev/flutter/intl/DateFormat-class.html
          String formattedDate =
              DateFormat('MMM d, yyyy, HH:mm a').format(convertedDate);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogDetails(blogItem: blogItem),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blogItem.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Pubished: ${formattedDate}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () async {
                            final editedBlogItem = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditBlogItem(
                                  blogItem: blogItem,
                                ),
                              ),
                            );
                            if (editedBlogItem != null) {
                              _editBlogItem(index, editedBlogItem);
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.deepPurple),
                          onPressed: () {
                            _deleteBlogItem(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.deepPurple),
                          onPressed: () {
                            final String content =
                                '${blogItem.title}\n\n${blogItem.bodyText}';
                            Share.share(content);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBlogItem = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditBlogItem(),
            ),
          );
          if (newBlogItem != null) {
            _addBlogItem(newBlogItem);
          }
        },
        tooltip: 'Add Blog Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
