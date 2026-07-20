part of 'check_in.dart';

class CheckInAdapter extends TypeAdapter<CheckIn> {
  @override
  final int typeId = 0;

  @override
  CheckIn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckIn(
      id: fields[0] as String,
      note: fields[1] as String,
      photoBytes: fields[2] as Uint8List?,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      accuracy: fields[5] as double?,
      timestamp: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CheckIn obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.photoBytes)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.accuracy)
      ..writeByte(6)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckInAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
