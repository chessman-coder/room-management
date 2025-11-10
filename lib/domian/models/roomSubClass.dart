import 'package:room_management/domian/models/bed.dart';
import 'package:room_management/domian/models/enum.dart';
import 'package:room_management/domian/models/room.dart';

class GeneralRoom extends Rooms {
  GeneralRoom({List<Bed>? beds, required int roomNumber})
    : super(
        type: RoomType.GENERAL_ROOM,
        beds: beds ?? List.generate(10, (_) => Bed()),
        roomNumber: roomNumber,
      );
}

class EmergancyRoom extends Rooms {
  EmergancyRoom({List<Bed>? beds, required int roomNumber})
    : super(
        type: RoomType.EMERGENCY_ROOM,
        beds: beds ?? [Bed()],
        roomNumber: roomNumber,
      );
}

class PrivateRoom extends Rooms {
  PrivateRoom({List<Bed>? beds, required int roomNumber})
    : super(
        type: RoomType.PRIVATE_ROOM,
        beds: beds ?? [Bed()],
        roomNumber: roomNumber,
      );
}

class ICURoom extends Rooms {
  ICURoom({List<Bed>? beds, required int roomNumber})
    : super(
        type: RoomType.ICU_ROOM,
        beds: beds ?? List.generate(5, (_) => Bed()),
        roomNumber: roomNumber,
      );
}

class OperatingRoom extends Rooms {
  OperatingRoom({List<Bed>? beds, required int roomNumber})
    : super(
        type: RoomType.OPERATING_ROOM,
        beds: beds ?? [Bed()],
        roomNumber: roomNumber,
      );
}