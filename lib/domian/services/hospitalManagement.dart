import 'package:room_management/domian/models/enum.dart';
import 'package:room_management/domian/models/patient.dart';
import 'package:room_management/domian/models/room.dart';
import 'package:room_management/domian/models/roomSubClass.dart';

class HospitalSystem {
  final List<GeneralRoom> generalRooms;
  final List<PrivateRoom> privateRooms;
  final List<EmergencyRoom> emergencyRooms;
  final List<ICURoom> icuRooms;
  final List<OperatingRoom> operatingRooms;

  int nextRoomNumber = 1;
  int allocateRoomNumber() => nextRoomNumber++;

  HospitalSystem()
    : generalRooms = [],
      privateRooms = [],
      emergencyRooms = [],
      icuRooms = [],
      operatingRooms = [] {
    for (int em = 0; em < 5; em++) {
      emergencyRooms.add(EmergencyRoom(roomNumber: allocateRoomNumber()));
    }
    for (int gn = 0; gn < 10; gn++) {
      generalRooms.add(GeneralRoom(roomNumber: allocateRoomNumber()));
    }
    for (int pv = 0; pv < 5; pv++) {
      privateRooms.add(PrivateRoom(roomNumber: allocateRoomNumber()));
    }
    for (int icu = 0; icu < 5; icu++) {
      icuRooms.add(ICURoom(roomNumber: allocateRoomNumber()));
    }
    for (int op = 0; op < 5; op++) {
      operatingRooms.add(OperatingRoom(roomNumber: allocateRoomNumber()));
    }
  }

  final List<Patient> activePatients = [];
  final List<Patient> recoveredPatients = [];

  String enumType(Object typeRaw) {
    typeRaw.toString().split('.').last;
    final typeStr = typeRaw
        .toString()
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}')
        .join(' ');
    return typeStr;
  }

  void assignNewPatient(Patient patient) {
    activePatients.add(patient);

    // Assign room based on patient condition
    switch (patient.condition) {
      case PatientCondition.CRITICAL:
        assignToICU(patient);
        break;
      case PatientCondition.EMERGENCY:
        assignToEmergency(patient);
        break;
      case PatientCondition.STABLE:
        if (patient.requestPrivateRoom) {
          assignToPrivate(patient);
        } else {
          assignToGeneral(patient);
        }
        break;
      case PatientCondition.NEED_SURGERY:
        assignToOperating(patient);
        break;
      case PatientCondition.RECOVERED:
        recovered(patient);
        break;
    }
  }

  void transferPatient(Patient patient, RoomType newRoomType) {
    // First check if patient is active
    if (!activePatients.contains(patient)) {
      throw Exception('Patient is not currently admitted');
    }
    // Release current bed
    releasePetientBed(patient);

    // Update patient condition based on the new room type
    switch (newRoomType) {
      case RoomType.ICU_ROOM:
        patient.condition = PatientCondition.CRITICAL;
        assignToICU(patient);
        break;
      case RoomType.EMERGENCY_ROOM:
        patient.condition = PatientCondition.EMERGENCY;
        assignToEmergency(patient);
        break;
      case RoomType.OPERATING_ROOM:
        patient.condition = PatientCondition.NEED_SURGERY;
        assignToOperating(patient);
        break;
      case RoomType.PRIVATE_ROOM:
        patient.condition = PatientCondition.STABLE;
        patient.requestPrivateRoom = true;
        assignToPrivate(patient);
        break;
      case RoomType.GENERAL_ROOM:
        patient.condition = PatientCondition.STABLE;
        patient.requestPrivateRoom = false;
        assignToGeneral(patient);
        break;
    }
  }

  void assignToICU(Patient patient) {
    for (var room in icuRooms) {
      final availableBed = room.getAvailableBed();
      if (availableBed != null) {
        availableBed.assignPatient(patient);
        patient.history.add(enumType(RoomType.ICU_ROOM));
        return;
      }
    }
    throw Exception('No ICU beds available');
  }

  void assignToEmergency(Patient patient) {
    for (var room in emergencyRooms) {
      final availableBed = room.getAvailableBed();
      if (availableBed != null) {
        availableBed.assignPatient(patient);
        patient.history.add(enumType(RoomType.EMERGENCY_ROOM));
        return;
      }
    }
    throw Exception('No Emergency beds available');
  }

  void assignToGeneral(Patient patient) {
    for (var room in generalRooms) {
      final availableBed = room.getAvailableBed();
      if (availableBed != null) {
        availableBed.assignPatient(patient);
        patient.history.add(enumType(RoomType.GENERAL_ROOM));
        return;
      }
    }
    throw Exception('No General beds available');
  }

  void assignToPrivate(Patient patient) {
    for (var room in privateRooms) {
      final availableBed = room.getAvailableBed();
      if (availableBed != null) {
        availableBed.assignPatient(patient);
        patient.history.add(enumType(RoomType.PRIVATE_ROOM));
        return;
      }
    }
    // If no private room automatically assign to general room
    assignToGeneral(patient);
  }

  void assignToOperating(Patient patient) {
    for (var room in operatingRooms) {
      final availableBed = room.getAvailableBed();
      if (availableBed != null) {
        availableBed.assignPatient(patient);
        patient.history.add(enumType(RoomType.OPERATING_ROOM));
        return;
      }
    }
    throw Exception('No Operating Room beds available');
  }

  void recovered(Patient patient) {
    patient.leaveDate = DateTime.now();
    patient.history.add('Go home');
    recoveredPatients.add(patient);
    releasePetientBed(patient);
    activePatients.remove(patient);
  }

  bool roomAvailability(Rooms room) => room.getAvailableBed() != null;

  Rooms? findPatientCurrentRoom(Patient patient) {
    for (var room in allRooms) {
      for (var bed in room.beds) {
        if (bed.patient?.patientId == patient.patientId) {
          return room;
        }
      }
    }
    return null;
  }

  void releasePetientBed(Patient patient) {
    for (var room in allRooms) {
      for (var bed in room.beds) {
        if (bed.patient?.patientId == patient.patientId) {
          bed.releasePatient();
          return;
        }
      }
    }
  }

  List<Rooms> get allRooms => [
    ...emergencyRooms,
    ...generalRooms,
    ...icuRooms,
    ...privateRooms,
    ...operatingRooms,
  ];

  void changePatientCondition(Patient patient, PatientCondition newCondition) {
    if (!activePatients.contains(patient)) {
      throw Exception('Patient is not currently admitted');
    }

    if (patient.condition == newCondition) {
      return;
    }

    if (newCondition == PatientCondition.RECOVERED) {
      recovered(patient);
      return;
    }

    final roomTypeMap = {
      PatientCondition.CRITICAL: RoomType.ICU_ROOM,
      PatientCondition.EMERGENCY: RoomType.EMERGENCY_ROOM,
      PatientCondition.NEED_SURGERY: RoomType.OPERATING_ROOM,
      PatientCondition.STABLE: patient.requestPrivateRoom
          ? RoomType.PRIVATE_ROOM
          : RoomType.GENERAL_ROOM,
    };

    final newRoomType = roomTypeMap[newCondition];
    if (newRoomType != null) {
      transferPatient(patient, newRoomType);
    }
  }
}
