import 'package:flutter/material.dart';
import 'package:flutter_notes/models/note_model.dart';
import 'package:flutter_notes/screens/create_note.dart';
import 'login_screen.dart';
import 'package:flutter_notes/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  // ADDED: Callback to allow HomeScreen to change the app's theme
  final Function(ThemeMode) setThemeMode;
  // ADDED: Current theme mode to display appropriate toggle icon
  final ThemeMode currentThemeMode;

  const HomeScreen({
    super.key,
    required this.setThemeMode, // CHANGED: setThemeMode is now required
    required this.currentThemeMode, // CHANGED: currentThemeMode is now required
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Notes"),
        actions: [
          // ADDED: IconButton for theme toggling
          IconButton(
            icon: Icon(
              // Dynamically change icon based on current theme mode
              widget.currentThemeMode == ThemeMode.dark
                  ? Icons.light_mode // Show sun if currently dark
                  : Icons.dark_mode, // Show moon if currently light or system
            ),
            onPressed: () {
              // Toggle logic: dark -> system -> light -> dark
              if (widget.currentThemeMode == ThemeMode.light) {
                widget.setThemeMode(ThemeMode.dark); // Switch to dark
              } else if (widget.currentThemeMode == ThemeMode.dark) {
                widget.setThemeMode(ThemeMode.system); // Switch to system
              } else {
                widget.setThemeMode(ThemeMode.light); // Switch to light
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteCard(
            note: notes[index],
            index: index,
            onEditNote: onEditNote,
            onNoteDelete: onNoteDelete,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateNote(
                    onNewNoteCreated: onNewNoteCreated,
                  )));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onNewNoteCreated(Note note) {
    notes.add(note);
    setState(() {});
  }

  void onNoteDelete(int index) {
    notes.removeAt(index);
    setState(() {});
  }

  void onEditNote() {
    setState(() {
      // This function needs to receive the updated note and its index/id
      // to properly update the notes list.
      // Example:
      // void onEditNote(Note updatedNote, int originalIndex) {
      //   notes[originalIndex] = updatedNote;
      //   setState(() {});
      // }
    });
  }
}