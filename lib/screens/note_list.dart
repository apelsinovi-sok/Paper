import 'package:flutter/material.dart';
import 'package:papers/screens/note_detail.dart';
import 'package:papers/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Note>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // noteList ??= <Note>[Note('', '', 1)];
    updateListView();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paper'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(context, Note('', '', 1, ''), 'Add Note');
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList![position].priority),
              child: getPriorityIcon(noteList![position].priority),
            ),
            title: Text(noteList![position].title, style: const TextStyle()),
            subtitle: Text(noteList![position].date),
            trailing: GestureDetector(
              child: const Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, noteList![position]);
              },
            ),
            onTap: () {
              navigateToDetail(context, noteList![position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.red;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);

      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      if (mounted) {
        _showSnackBar(context, 'Delete');
        updateListView();
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      var noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }

  void navigateToDetail(BuildContext context, Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title, note);
    }));
    if (result == true) {
      updateListView();
    }
  }
}
