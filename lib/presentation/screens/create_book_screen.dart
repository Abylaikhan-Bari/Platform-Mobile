import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/domain/entities/book_entity.dart';
import 'package:platform/bloc/book_bloc.dart';

class CreateBookScreen extends StatefulWidget {
  const CreateBookScreen({super.key});

  @override
  _CreateBookScreenState createState() => _CreateBookScreenState();
}

class _CreateBookScreenState extends State<CreateBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Book')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.trim().isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) => value!.trim().isEmpty ? 'Enter author' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                validator: (value) => value!.trim().isEmpty ? 'Enter content' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newBook = BookEntity(
                      id: "", // Provide default empty ID, backend will generate it
                      title: _titleController.text.trim(),
                      author: _authorController.text.trim(),
                      content: _contentController.text.trim().isNotEmpty
                          ? _contentController.text
                          : "", // Ensure content is not null
                    );
                    context.read<BookBloc>().add(CreateBookEvent(book: newBook));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
