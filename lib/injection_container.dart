import 'features/notes/data/datasources/notes_local_datasource.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/repositories/notes_repository.dart';
import 'features/notes/domain/usecases/notes_usecases.dart';
import 'features/notes/presentation/providers/notes_provider.dart';

class AppDependencies {
  AppDependencies._();

  static NotesProvider buildNotesProvider() {
    final dataSource = NotesLocalDataSourceImpl();
    final repository = NotesRepositoryImpl(dataSource) as NotesRepository;

    return NotesProvider(
      getAll:    GetAllNotes(repository),
      search:    SearchNotes(repository),
      getByTag:  GetNotesByTag(repository),
      save:      SaveNote(repository),
      delete:    DeleteNote(repository),
      deleteAll: DeleteAllNotes(repository),
      getTags:   GetAllTags(repository),
    );
  }
}
