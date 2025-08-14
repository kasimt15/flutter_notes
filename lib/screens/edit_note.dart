//this is used for converting to JSON
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';
import 'package:http/http.dart' as http;

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
  late final String old_note_title, old_note_body;
  
  @override
  void initState(){
    old_note_title = widget.note.title;
    old_note_body= widget.note.body;
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

        //adding the UID from google account if signed in
        final note= Note(uid:null, body: bodyController.text, title: titleController.text);
        if(note.uid == null && FirebaseAuth.instance.currentUser != null){
          note.uid= FirebaseAuth.instance.currentUser!.uid;
        }
        
        //editing the note
        sendPutRequest(note, old_note_body, old_note_title);
        widget.onEditNote();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      child: Icon(Icons.save),),
    );
  }

  Future<void> sendPutRequest(Note note, String old_note_body, String old_note_title) async{
    final user= await FirebaseAuth.instance.currentUser!;
    final userToken= await user.getIdToken();
    final url=  Uri.parse("insert-your-base-url/edit/note/");

    try{
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_token': userToken,
          'title': note.title,
          'body': note.body,
          'old_title': old_note_title,
          'old_body': old_note_body,
        }),
      );
      print(response.body);
    }catch(e, stack){
      print("token error: $e");
      print(stack);
      return;
    }
  }

}