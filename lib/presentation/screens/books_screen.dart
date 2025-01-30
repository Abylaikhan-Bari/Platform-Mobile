import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/domain/entities/book_entity.dart';
import 'package:platform/bloc/book_bloc.dart';
import '../../core/network/firebase_service.dart';
import 'create_book_screen.dart';
import 'edit_book_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  bool? isAdmin;

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
    context.read<BookBloc>().add(FetchBooksEvent()); // Fetch books
  }

  Future<void> _fetchUserRole() async {
    try {
      final role = await FirebaseService().getUserRole();
      debugPrint("🔥 User role fetched: $role");
      if (mounted) {
        setState(() {
          isAdmin = role == "admin";
        });
      }
    } catch (e) {
      debugPrint("🔥 Error fetching user role: $e");
      if (mounted) {
        setState(() {
          isAdmin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🔥 isAdmin: $isAdmin");

    if (isAdmin == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Books')),
      floatingActionButton: isAdmin == true
          ? FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateBookScreen()),
        ),
        child: const Icon(Icons.add),
      )
          : null,
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          if (state is BookLoaded) {
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: isAdmin == true
                      ? Row(
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
                        onPressed: () => _confirmDelete(context, book.id),
                      ),
                    ],
                  )
                      : null, // Hide for non-admins
                );
              },
            );
          }
          return const Center(child: Text('No books available'));
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this book?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                context.read<BookBloc>().add(DeleteBookEvent(bookId: bookId));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
