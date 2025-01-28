part of 'book_bloc.dart';

@immutable
abstract class BookEvent {}

class FetchBooksEvent extends BookEvent {}

class CreateBookEvent extends BookEvent {
  final BookEntity book;

  CreateBookEvent({required this.book});
}

class UpdateBookEvent extends BookEvent {
  final BookEntity book;

  UpdateBookEvent({required this.book});
}

class DeleteBookEvent extends BookEvent {
  final String bookId;

  DeleteBookEvent({required this.bookId});
}