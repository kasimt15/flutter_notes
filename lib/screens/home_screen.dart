import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';
import 'package:flutter_notes/screens/create_note.dart';
import 'package:flutter_notes/widgets/note_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes= List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Notes"),
      ),
      
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index){
          return NoteCard(note: notes[index], index: index, onEditNote: onEditNote, onNoteDelete: onNoteDelete,);
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed:(){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CreateNote(onNewNoteCreated: onNewNoteCreated,)));
        },
        child: const Icon(Icons.add),),
    );
  }
  void onNewNoteCreated(Note note){
    notes.add(note);
    setState(() {
      
    });
  }

  void onNoteDelete(int index){
    notes.removeAt(index);
    setState(() {
      
    });
  }
  void onEditNote(){
    setState(() {
      
    });
  }
}