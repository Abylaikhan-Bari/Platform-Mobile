import 'package:platform/domain/entities/book_entity.dart';

abstract class BookUseCases {
  Future<List<BookEntity>> getBooks();
  Future<BookEntity> createBook(BookEntity book);
  Future<BookEntity> updateBook(BookEntity book);
  Future<void> deleteBook(String id);
}