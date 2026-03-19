import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/utils/constants.dart';
import '../models/note_model.dart';

abstract class NotesLocalDataSource {
  List<NoteModel> getAll();
  NoteModel?      getById(String id);
  void            save(NoteModel note);
  void            delete(String id);
  void            deleteAll();
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  Box<NoteModel> get _box => Hive.box<NoteModel>(AppConstants.hiveBoxName);

  @override
  List<NoteModel> getAll() {
    final notes = _box.values.toList();
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return notes;
  }

  @override
  NoteModel? getById(String id) {
    try {
      return _box.values.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void save(NoteModel note) => _box.put(note.id, note);

  @override
  void delete(String id) => _box.delete(id);

  @override
  void deleteAll() => _box.clear();
}
