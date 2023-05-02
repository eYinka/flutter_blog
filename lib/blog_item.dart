import 'dart:convert';
import 'dart:math';

class UUID {
  Random _rng;
  UUID() : _rng = new Random();
  String generate() =>  (_rng.nextDouble() * 1e16).toInt().toRadixString(16).padRight(14, '0');
}

final uuid = UUID();

class BlogItem {
  String? id;
  String title;
  String date;
  String bodyText;
  String? imagePath;

  BlogItem({
    this.id,
    required this.title,
    required this.date,
    required this.bodyText,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': uuid.generate(),
      'title': title,
      'date': date,
      'bodyText': bodyText,
      'imagePath': imagePath,
    };
  }

  factory BlogItem.fromMap(Map<String, dynamic> map) {
    return BlogItem(
      id: map['id'],
      title: map['title'],
      date: map['date'],
      bodyText: map['bodyText'],
      imagePath: map['imagePath'],
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogItem.fromJson(String source) =>
      BlogItem.fromMap(json.decode(source));
}
