import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/domain/entities/book_entity.dart';
import 'package:platform/bloc/book_bloc.dart';

class EditBookScreen extends StatefulWidget {
  final BookEntity book;

  const EditBookScreen({super.key, required this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(text: widget.book.title);
  late final _authorController = TextEditingController(text: widget.book.author);
  late final _contentController = TextEditingController(text: widget.book.content ?? "");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Edit Book",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 15),
                _buildTextField(_titleController, "Title"),
                const SizedBox(height: 10),
                _buildTextField(_authorController, "Author"),
                const SizedBox(height: 10),
                _buildTextField(_contentController, "Content", maxLines: 4),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final updatedBook = BookEntity(
                            id: widget.book.id,
                            title: _titleController.text.trim(),
                            author: _authorController.text.trim(),
                            content: _contentController.text.trim(),
                          );
                          context.read<BookBloc>().add(UpdateBookEvent(book: updatedBook));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      maxLines: maxLines,
      validator: (value) => value!.trim().isEmpty ? "Enter $label" : null,
    );
  }
}
