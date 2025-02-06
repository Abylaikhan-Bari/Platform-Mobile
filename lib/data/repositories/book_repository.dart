import 'package:platform/core/network/api_service.dart';
import 'package:platform/data/models/book.dart';
import 'package:platform/domain/entities/book_entity.dart';
import 'package:platform/domain/use_cases/book_use_cases.dart';

class BookRepository implements BookUseCases {
  final ApiService _apiService = ApiService();

  @override
  Future<List<BookEntity>> getBooks() async {
    final books = await _apiService.getBooks();
    return books.map((book) => Book.fromJson(book).toEntity()).toList();
  }

  @override
  Future<BookEntity> createBook(BookEntity book) async {
    final newBook = await _apiService.createBook(book.toJson());
    return Book.fromJson(newBook).toEntity();
  }

  @override
  Future<BookEntity> updateBook(BookEntity book) async {
    final updatedBook = await _apiService.updateBook(
      book.id ?? "", // Ensure non-null id
      book.toJson(),
    );
    return Book.fromJson(updatedBook).toEntity();
  }

  @override
  Future<void> deleteBook(String id) async => await _apiService.deleteBook(id);
}

extension BookEntityExtension on Book {
  BookEntity toEntity() => BookEntity(
    id: id ?? "", // Ensure id is not null
    title: title,
    author: author,
    content: content ?? "", // Ensure content is not null
  );
}

extension BookJsonExtension on BookEntity {
  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    if (content != null) 'content': content, // Only include content if it's non-null
  };
}
