class Book {
  final String? id; // Make nullable to prevent issues
  final String title;
  final String author;
  final String? content; // Allow content to be null

  Book({
    this.id, // Nullable
    required this.title,
    required this.author,
    this.content, // Nullable
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'] as String?,
      title: json['title'] as String? ?? "Untitled", // Default title if missing
      author: json['author'] as String? ?? "Unknown", // Default author if missing
      content: json['content'] as String?, // Allow content to be null
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'title': title,
      'author': author,
      'content': content ?? "", // Convert null to empty string
    };
    if (id != null) data['_id'] = id!; // Include ID only if it's not null
    return data;
  }
}
