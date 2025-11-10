import 'dart:convert';
import 'dart:io';

import 'package:room_management/domian/models/enum.dart';
import 'package:room_management/domian/models/patient.dart';
import 'package:room_management/domian/models/room.dart';
import 'package:room_management/domian/models/roomSubClass.dart';
import 'package:room_management/domian/services/hospitalManagement.dart';

class StoringData {
  Future<void> saveData(HospitalSystem system, String filePath) async {
    final data = {
      'activePatients': system.activePatients
          .map((patient) => patient.toJson())
          .toList(),
      'recoveredPatients': system.recoveredPatients
          .map((patient) => patient.toJson())
          .toList(),
      'rooms': system.allRooms.map((room) => room.toJson()).toList(),
    };

    final file = File(filePath);
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> loadData(HospitalSystem system, String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }

    final jsonString = await file.readAsString();
    if (jsonString.trim().isEmpty) return;

    final Map<String, dynamic> data = jsonDecode(jsonString);

    system.activePatients.clear();
    system.recoveredPatients.clear();
    for (final patient in data['activePatients']) {
      system.activePatients.add(Patient.fromJson(patient));
    }
    for (final patient in data['recoveredPatients']) {
      system.recoveredPatients.add(Patient.fromJson(patient));
    }

    final rooms = (data['rooms'] as List)
        .map((r) => Rooms.fromJson(r))
        .toList();

    system.generalRooms.clear();
    system.privateRooms.clear();
    system.emergancyRooms.clear();
    system.icuRooms.clear();
    system.operatingRooms.clear();

    for (final room in rooms) {
      switch (room.type) {
        case RoomType.GENERAL_ROOM:
          system.generalRooms.add(room as GeneralRoom);
          break;
        case RoomType.PRIVATE_ROOM:
          system.privateRooms.add(room as PrivateRoom);
          break;
        case RoomType.ICU_ROOM:
          system.icuRooms.add(room as ICURoom);
          break;
        case RoomType.EMERGENCY_ROOM:
          system.emergancyRooms.add(room as EmergancyRoom);
          break;
        case RoomType.OPERATING_ROOM:
          system.operatingRooms.add(room as OperatingRoom);
          break;
      }
    }
  }
}
