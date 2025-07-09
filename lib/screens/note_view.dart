import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';
import 'package:flutter_notes/screens/edit_note.dart';

class NoteView extends StatelessWidget {
  NoteView({super.key, required this.note, required this.index, required this.onEditNote});

  Note note;
  final int index;
  final Function() onEditNote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note View"),
      ),

      body: InkWell(
        onTap:() {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditNote(note: note, onEditNote: onEditNote,)));
        },
        onLongPress: (){
          
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                note.body,
                style: const TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}