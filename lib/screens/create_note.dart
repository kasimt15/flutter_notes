import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key, required this.onNewNoteCreated});
  final Function(Note) onNewNoteCreated;
  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New note"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 28,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title"
                ),
              ),
        
              const SizedBox(height: 20,),
        
              TextFormField(
                controller: bodyController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Body",
                ),
                maxLines: null,
                minLines: 16,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
                if(titleController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Note must contain a title"), duration: const Duration(seconds: 2),));
                  return;
                }
            
                if(bodyController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Note must contain a body"), duration: const Duration(seconds: 2),));
                  return;
                }
                final note= Note(body: bodyController.text, title: titleController.text);
                widget.onNewNoteCreated(note);
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.save),
      ),
    );
  }
}