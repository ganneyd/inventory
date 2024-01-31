import 'package:hive/hive.dart';

class MapStringDynamicAdapter extends TypeAdapter<Map<String, dynamic>> {
  @override
  final int typeId = 0; // Unique ID for this type adapter

  @override
  Map<String, dynamic> read(BinaryReader reader) {
    final int length = reader.readInt();
    final Map<String, dynamic> map = {};
    for (int i = 0; i < length; i++) {
      final key = reader.readString();
      final value = reader.read(typeId);
      map[key] = value;
    }
    return map;
  }

  @override
  void write(BinaryWriter writer, Map<String, dynamic> map) {
    writer.writeInt(map.length);
    map.forEach((key, value) {
      writer.writeString(key);
      writer.write(value);
    });
  }
}
