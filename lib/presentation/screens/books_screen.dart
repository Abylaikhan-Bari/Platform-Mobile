import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/domain/entities/book_entity.dart';
import 'package:platform/bloc/book_bloc.dart';
import '../../core/network/firebase_service.dart';
import 'components/create_book_component.dart';
import 'components/edit_book_component.dart';

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
    _refreshBooks(); // Fetch initial data
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

  Future<void> _refreshBooks() async {
    context.read<BookBloc>().add(FetchBooksEvent()); // Fetch latest books
  }

  void _showCreateBookPopup() {
    showDialog(
      context: context,
      builder: (context) => const CreateBookScreen(),
    ).then((_) => _refreshBooks()); // Refresh after closing
  }

  void _showEditBookPopup(BookEntity book) {
    showDialog(
      context: context,
      builder: (context) => EditBookScreen(book: book),
    ).then((_) => _refreshBooks()); // Refresh after closing
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🔥 isAdmin: $isAdmin");

    if (isAdmin == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.green, // ✅ Custom loading indicator color
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Books',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      floatingActionButton: isAdmin == true
          ? FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _showCreateBookPopup,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      body: RefreshIndicator(
        onRefresh: _refreshBooks, // ✅ Refresh on pull-down
        color: Colors.green, // ✅ Custom refresh indicator color
        child: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            if (state is BookLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.green, // ✅ Matches design
                ),
              );
            }
            if (state is BookError) {
              return Center(child: Text("Failed to fetch books: ${state.message}"));
            }
            if (state is BookLoaded) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: state.books.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85, // ✅ Adjusted for better layout
                  ),
                  itemBuilder: (context, index) {
                    final book = state.books[index];
                    return GestureDetector(
                      onTap: () => _showBookDetailsPopup(context, book),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  book.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  "Author: ${book.author}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isAdmin == true)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Wrap(
                                    spacing: 5,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditBookPopup(book),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _confirmDelete(context, book.id),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('No books available'));
          },
        ),
      ),
    );
  }

  void _showBookDetailsPopup(BuildContext context, BookEntity book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Author: ${book.author}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  book.content,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close", style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Confirm Delete",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to delete this book?",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<BookBloc>().add(DeleteBookEvent(bookId: bookId));
                        Navigator.of(context).pop();
                      },
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
