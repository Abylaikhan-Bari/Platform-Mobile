import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/bloc/book_bloc.dart';
import 'create_book_screen.dart';
import 'edit_book_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(FetchBooksEvent()); // 🔥 Trigger fetch books
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Books')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateBookScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          if (state is BookLoaded) {
            return state.books.isEmpty
                ? const Center(child: Text('No books available'))
                : ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditBookScreen(book: book),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => context.read<BookBloc>().add(
                          DeleteBookEvent(bookId: book.id),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No books available'));
        },
      ),
    );
  }
}
