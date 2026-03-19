import 'package:hive/hive.dart';

import '../../domain/entities/note.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0) String   id;
  @HiveField(1) String   title;
  @HiveField(2) String   content;
  @HiveField(3) List<String> tags;
  @HiveField(4) int      colorIndex;
  @HiveField(5) bool     isPinned;
  @HiveField(6) DateTime createdAt;
  @HiveField(7) DateTime updatedAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.colorIndex,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromEntity(Note note) => NoteModel(
        id:         note.id,
        title:      note.title,
        content:    note.content,
        tags:       List<String>.from(note.tags),
        colorIndex: note.colorIndex,
        isPinned:   note.isPinned,
        createdAt:  note.createdAt,
        updatedAt:  note.updatedAt,
      );

  Note toEntity() => Note(
        id:         id,
        title:      title,
        content:    content,
        tags:       List<String>.from(tags),
        colorIndex: colorIndex,
        isPinned:   isPinned,
        createdAt:  createdAt,
        updatedAt:  updatedAt,
      );
}
