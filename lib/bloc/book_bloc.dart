import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:platform/domain/use_cases/book_use_cases.dart';

import '../domain/entities/book_entity.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookUseCases bookUseCases;

  BookBloc({required this.bookUseCases}) : super(BookInitial()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<CreateBookEvent>(_onCreateBook);
    on<UpdateBookEvent>(_onUpdateBook);
    on<DeleteBookEvent>(_onDeleteBook);
  }

  Future<void> _onFetchBooks(
      FetchBooksEvent event,
      Emitter<BookState> emit,
      ) async {
    emit(BookLoading());
    try {
      final books = await bookUseCases.getBooks();
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookError(message: e.toString()));
    }
  }

  Future<void> _onCreateBook(
      CreateBookEvent event,
      Emitter<BookState> emit,
      ) async {
    try {
      await bookUseCases.createBook(event.book);
      final books = await bookUseCases.getBooks();
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookError(message: "Failed to create book: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateBook(
      UpdateBookEvent event,
      Emitter<BookState> emit,
      ) async {
    try {
      await bookUseCases.updateBook(event.book);
      final books = await bookUseCases.getBooks();
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookError(message: "Failed to update book: ${e.toString()}"));
    }
  }

  Future<void> _onDeleteBook(
      DeleteBookEvent event,
      Emitter<BookState> emit,
      ) async {
    try {
      await bookUseCases.deleteBook(event.bookId);
      final books = await bookUseCases.getBooks();
      emit(BookLoaded(books: books));
    } catch (e) {
      emit(BookError(message: "Failed to delete book: ${e.toString()}"));
    }
  }

}