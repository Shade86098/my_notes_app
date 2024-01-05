import 'package:flutter/material.dart';
import 'package:my_notes_app/services/auth/auth_service.dart';
import 'package:my_notes_app/utils/generics/get_arguments.dart';
import 'package:my_notes_app/views/loading_view.dart';
import 'package:my_notes_app/services/cloud/cloud_note.dart';
import 'package:my_notes_app/services/cloud/firebase_cloud_storage.dart';

class CreateOrUpdateNoteView extends StatefulWidget {
  const CreateOrUpdateNoteView({super.key});

  @override
  State<CreateOrUpdateNoteView> createState() => _CreateOrUpdateNoteViewState();
}

class _CreateOrUpdateNoteViewState extends State<CreateOrUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _text;
  late final TextEditingController _title;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _text = TextEditingController();
    _title = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _text.text;
    final title = _title.text;
    await _notesService.updateNote(
      documentId: note.documentID,
      text: text,
      title: title,
    );
  }

  void _setupTextControllerListener() {
    _text.removeListener(_textControllerListener);
    _text.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _text.text = widgetNote.text;
      _title.text = widgetNote.title;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      // user should exist here when you end up here
      final currentUser = AuthService.firebase().currentUser!;
      final userId = currentUser.id;
      final newNote = await _notesService.createNewNote(ownerUserId: userId);
      _note = newNote;
      return newNote;
    }
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_text.text.isEmpty && _title.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentID);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _text.text;
    final title = _title.text;
    if (note != null && (text.isNotEmpty || title.isNotEmpty)) {
      await _notesService.updateNote(
        documentId: note.documentID,
        text: text,
        title: title,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return SizedBox(
                child: Column(
                  children: [
                    TextField(
                      controller: _title,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    TextField(
                      controller: _text,
                      keyboardType: TextInputType.multiline,
                      minLines: 10,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Start Typing your Note ...'),
                    ),
                  ],
                ),
              );
            default:
              return const LoadingView();
          }
        },
      ),
    );
  }
}
