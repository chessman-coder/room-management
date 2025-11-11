import 'package:uuid/uuid.dart';
import 'bed.dart';
import 'enum.dart';
import 'roomSubClass.dart';

var uuid = Uuid().v4();

abstract class Rooms {
  final String roomId;
  final int roomNumber;
  final RoomType type;
  final List<Bed> beds;

  Rooms({
    String? roomId,
    required this.roomNumber,
    required this.type,
    required this.beds,
  }) : roomId = roomId ?? uuid;

  Bed? getAvailableBed() {
    for (final bed in beds) {
      if (bed.status == BedStatus.AVAILABLE) return bed;
    }
    return null;
  }

  String formatRoomType(RoomType type) {
    return type
        .toString()
        .split('.')
        .last
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) =>
              word.substring(0, 1).toUpperCase() +
              word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  Map<String, dynamic> toJson() => {
    'roomId': roomId,
    'roomType': type.toString().split('.').last,
    'roomNumber': roomNumber,
    'beds': beds.map((bed) => bed.toJson()).toList(),
  };

  // AI generate
  factory Rooms.fromJson(Map<String, dynamic> json) {
    // Convert formatted string back to enum value
    var roomType = RoomType.values.firstWhere(
      (type) => type.toString().split('.').last == json['roomType'],
      orElse: () =>
          throw FormatException('Invalid room type: ${json['roomType']}'),
    );
    List<Bed> beds = (json['beds'] as List)
        .map((bedJson) => Bed.fromJson(bedJson))
        .toList();

    var roomNumber = json['roomNumber'] as int;

    switch (roomType) {
      case RoomType.GENERAL_ROOM:
        return GeneralRoom(roomNumber: roomNumber, beds: beds);
      case RoomType.PRIVATE_ROOM:
        return PrivateRoom(roomNumber: roomNumber, beds: beds);
      case RoomType.ICU_ROOM:
        return ICURoom(roomNumber: roomNumber, beds: beds);
      case RoomType.EMERGENCY_ROOM:
        return EmergencyRoom(roomNumber: roomNumber, beds: beds);
      case RoomType.OPERATING_ROOM:
        return OperatingRoom(roomNumber: roomNumber, beds: beds);
    }
  }
}
