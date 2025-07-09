import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';

class EditNote extends StatefulWidget {
  EditNote({super.key, required this.note, required this.onEditNote});
  final Function() onEditNote;
  Note note;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  
  @override
  void initState(){
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    bodyController = TextEditingController(text: widget.note.body); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit the note"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                //initialValue: titleController.text,
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
                //initialValue: bodyController.text,
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
        widget.note.title= titleController.text;
        widget.note.body= bodyController.text;
        widget.onEditNote();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: Icon(Icons.save),),
    );
  }
}