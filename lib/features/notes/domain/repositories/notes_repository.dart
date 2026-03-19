import '../entities/note.dart';

abstract class NotesRepository {
  Future<List<Note>> getAllNotes();
  Future<List<Note>> searchNotes(String query);
  Future<List<Note>> getNotesByTag(String tag);
  Future<Note?>      getNoteById(String id);
  Future<void>       saveNote(Note note);
  Future<void>       deleteNote(String id);
  Future<void>       deleteAllNotes();
  Future<List<String>> getAllTags();
}
