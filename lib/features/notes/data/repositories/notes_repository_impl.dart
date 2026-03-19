import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';
import '../models/note_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource _local;
  NotesRepositoryImpl(this._local);

  @override
  Future<List<Note>> getAllNotes() async =>
      _local.getAll().map((m) => m.toEntity()).toList();

  @override
  Future<List<Note>> searchNotes(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAllNotes();
    return _local
        .getAll()
        .where((m) =>
            m.title.toLowerCase().contains(q) ||
            m.content.toLowerCase().contains(q) ||
            m.tags.any((t) => t.toLowerCase().contains(q)))
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<Note>> getNotesByTag(String tag) async {
    if (tag.isEmpty) return getAllNotes();
    return _local
        .getAll()
        .where((m) => m.tags.contains(tag))
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<Note?> getNoteById(String id) async =>
      _local.getById(id)?.toEntity();

  @override
  Future<void> saveNote(Note note) async =>
      _local.save(NoteModel.fromEntity(note));

  @override
  Future<void> deleteNote(String id) async => _local.delete(id);

  @override
  Future<void> deleteAllNotes() async => _local.deleteAll();

  @override
  Future<List<String>> getAllTags() async {
    final tags = <String>{};
    for (final m in _local.getAll()) {
      tags.addAll(m.tags);
    }
    return tags.toList()..sort();
  }
}
