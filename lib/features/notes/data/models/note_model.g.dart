part of 'note_model.dart';

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = 0;

  @override
  NoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteModel(
      id:         fields[0] as String,
      title:      fields[1] as String,
      content:    fields[2] as String,
      tags:       (fields[3] as List).cast<String>(),
      colorIndex: fields[4] as int,
      isPinned:   fields[5] as bool,
      createdAt:  fields[6] as DateTime,
      updatedAt:  fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.content)
      ..writeByte(3)..write(obj.tags)
      ..writeByte(4)..write(obj.colorIndex)
      ..writeByte(5)..write(obj.isPinned)
      ..writeByte(6)..write(obj.createdAt)
      ..writeByte(7)..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
