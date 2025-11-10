import 'package:test/test.dart';
import 'package:room_management/domian/models/enum.dart';
import 'package:room_management/domian/models/roomSubClass.dart';

void main() {
  group('Room Tests', () {
    test('General Room initialization', () {
      final room = GeneralRoom(roomNumber: 101);

      expect(room.roomNumber, equals(101));
      expect(room.type, equals(RoomType.GENERAL_ROOM));
      expect(room.beds.length, equals(10));
    });

    test('ICU Room initialization', () {
      final room = ICURoom(roomNumber: 201);

      expect(room.roomNumber, equals(201));
      expect(room.type, equals(RoomType.ICU_ROOM));
      expect(room.beds.length, equals(5));
    });

    test('Get available bed', () {
      final room = GeneralRoom(roomNumber: 101);
      final bed = room.getAvailableBed();

      expect(bed, isNotNull);
      expect(bed?.status, equals(BedStatus.AVAILABLE));
    });

    test('Room type formatting', () {
      final room = PrivateRoom(roomNumber: 301);
      final formattedType = room.formatRoomType(room.type);

      expect(formattedType, equals('Private Room'));
    });
  });
}
