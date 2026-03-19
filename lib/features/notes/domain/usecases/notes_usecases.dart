import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class GetAllNotes {
  final NotesRepository _repo;
  GetAllNotes(this._repo);
  Future<List<Note>> call() => _repo.getAllNotes();
}

class SearchNotes {
  final NotesRepository _repo;
  SearchNotes(this._repo);
  Future<List<Note>> call(String query) => _repo.searchNotes(query);
}

class GetNotesByTag {
  final NotesRepository _repo;
  GetNotesByTag(this._repo);
  Future<List<Note>> call(String tag) => _repo.getNotesByTag(tag);
}

class GetNoteById {
  final NotesRepository _repo;
  GetNoteById(this._repo);
  Future<Note?> call(String id) => _repo.getNoteById(id);
}

class SaveNote {
  final NotesRepository _repo;
  SaveNote(this._repo);
  Future<void> call(Note note) => _repo.saveNote(note);
}

class DeleteNote {
  final NotesRepository _repo;
  DeleteNote(this._repo);
  Future<void> call(String id) => _repo.deleteNote(id);
}

class DeleteAllNotes {
  final NotesRepository _repo;
  DeleteAllNotes(this._repo);
  Future<void> call() => _repo.deleteAllNotes();
}

class GetAllTags {
  final NotesRepository _repo;
  GetAllTags(this._repo);
  Future<List<String>> call() => _repo.getAllTags();
}
