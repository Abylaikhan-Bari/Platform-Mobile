class Book {
  final String id;
  final String title;
  final String author;
  final String content; // Changed from 'description' to 'content'

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      content: json['content'], // Changed from 'description' to 'content'
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'content': content, // Changed from 'description' to 'content'
  };
}
