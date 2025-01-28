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
  late final _descriptionController = TextEditingController(text: widget.book.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) => value!.isEmpty ? 'Enter author' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter description' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedBook = BookEntity(
                      id: widget.book.id,
                      title: _titleController.text,
                      author: _authorController.text,
                      description: _descriptionController.text,
                    );
                    context.read<BookBloc>().add(UpdateBookEvent(book: updatedBook));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}