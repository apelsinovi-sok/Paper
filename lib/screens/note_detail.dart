

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:papers/models/note.dart';
import 'package:papers/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const NoteDetail(this.appBarTitle, this.note, {super.key});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {


  // static final _priorities = ['High', 'Low'];
  static final _priorities = ['Low', 'High'];

  late String appBarTitle = widget.appBarTitle;

  late Note note = widget.note;

  DatabaseHelper helper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description!;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStingItem) {
                  return DropdownMenuItem<String>(
                      value: dropDownStingItem, child: Text(dropDownStingItem));
                }).toList(),
                value: getPriorityAsString(note.priority),
                onChanged: (valueSelectedByUser) {
                  setState(() {
                    updatePriorityAsInt(valueSelectedByUser!);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                onChanged: (value) {
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                onChanged: (value) {
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 1.5)),
                    child: const Text(
                      'Save',
                      textScaleFactor: 10,
                    ),
                    onPressed: () {
                      _save();
                    },
                  )),
                  Container(
                    width: 6.0,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,
                        textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 1.5)),
                    child: const Text(
                      'Delete',
                      textScaleFactor: 10,
                    ),
                    onPressed: () {
                      _delete();
                    },
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getPriorityAsString(int value) {
    late String priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority;
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Low':
        note.priority = 1;
        break;
      case 'High':
        note.priority = 2;
        break;
    }
  }

  void updateTitle(){
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;

    if(note.title.isEmpty) {
      note.title = 'void';
    }

    if(note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    if(result !=0) {
      _showAlertDialog('Status', 'Saved');
    } else {
      _showAlertDialog('Status', 'No Saving');
    }

  }

  void _delete() async {

    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }


    int result = await helper.deleteNote(note.id!);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

}
