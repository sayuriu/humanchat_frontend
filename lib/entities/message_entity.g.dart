// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 3;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      messageId: fields[0] as BigInt,
      author: fields[1] as BigInt,
      replyTo: fields[2] as BigInt?,
      channel: fields[3] as BigInt,
      content: fields[4] as String,
      lastEdit: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.replyTo)
      ..writeByte(3)
      ..write(obj.channel)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.lastEdit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
