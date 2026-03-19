import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String   id;
  final String   title;
  final String   content;
  final List<String> tags;
  final int      colorIndex;
  final bool     isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.colorIndex,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isEmpty => title.trim().isEmpty && content.trim().isEmpty;

  String get preview {
    final text = content.trim();
    if (text.isEmpty) return '';
    return text.length > 120 ? '${text.substring(0, 120)}...' : text;
  }

  Note copyWith({
    String?    id,
    String?    title,
    String?    content,
    List<String>? tags,
    int?       colorIndex,
    bool?      isPinned,
    DateTime?  createdAt,
    DateTime?  updatedAt,
  }) =>
      Note(
        id:         id         ?? this.id,
        title:      title      ?? this.title,
        content:    content    ?? this.content,
        tags:       tags       ?? this.tags,
        colorIndex: colorIndex ?? this.colorIndex,
        isPinned:   isPinned   ?? this.isPinned,
        createdAt:  createdAt  ?? this.createdAt,
        updatedAt:  updatedAt  ?? this.updatedAt,
      );

  @override
  List<Object?> get props => [id, title, content, tags, colorIndex, isPinned, updatedAt];
}
