//this is used for converting to JSON
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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
                
                //adding the UID from google account if signed in
                final note= Note(uid:null, body: bodyController.text, title: titleController.text);
                if(note.uid == null && FirebaseAuth.instance.currentUser != null){
                  note.uid= FirebaseAuth.instance.currentUser!.uid;
                }

                //creating the note
                sendPostRequest(note);
                widget.onNewNoteCreated(note);
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> sendPostRequest(Note note) async{
    final user= await FirebaseAuth.instance.currentUser!;
    final userToken= await user.getIdToken();
    final url=  Uri.parse("insert-your-base-url/create/note/");
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_token': userToken,
          'title': note.title,
          'body': note.body,
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