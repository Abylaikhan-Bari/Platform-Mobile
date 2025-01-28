class Book {
  final String id;
  final String title;
  final String author;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'description': description,
  };
}