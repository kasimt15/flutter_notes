import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';
import 'package:flutter_notes/screens/note_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteCard extends StatelessWidget {
  NoteCard({super.key, required this.note, required this.index, required this.onEditNote, required this.onNoteDelete});

  Note note;
  final int index;
  final Function(int) onNoteDelete;
  final Function() onEditNote;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NoteView(note: note, index: index, onEditNote: onEditNote)));
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: "Delete",
              onPressed: (context){
                onNoteDelete(index);
              },
            )
          ],
        ),
        child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 20
                        ),
                      ),
                        
                      const SizedBox( height: 10,),
                        
                      Text(
                      note.body,
                      style: const TextStyle(
                        fontSize: 20
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis
                      ),
                    ],
                  )
                )
              ),
      ),
    );
  }
}