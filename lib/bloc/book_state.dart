part of 'book_bloc.dart';

@immutable
abstract class BookState {}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<BookEntity> books;

  BookLoaded({required this.books});
}

class BookError extends BookState {
  final String message;

  BookError({required this.message});
}