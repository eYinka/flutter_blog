import 'dart:convert';
import 'dart:io';
import 'blog_item.dart';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/blog_items.json');
  }

  Future<List<BlogItem>> readBlogItems() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => BlogItem.fromJson(json as String)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> writeBlogItems(List<BlogItem> blogItems) async {
    final file = await _localFile;
    List<String> jsonList =
        blogItems.map((blogItem) => blogItem.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }
}
