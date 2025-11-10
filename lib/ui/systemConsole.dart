import 'dart:io';
import 'package:room_management/domian/models/enum.dart';
import 'package:room_management/domian/models/patient.dart';
import 'package:room_management/domian/services/hospitalManagement.dart';

class SystemConsole {
  final HospitalSystem hospitalSystem;

  SystemConsole() : hospitalSystem = HospitalSystem();
  void start() {
    bool isRunning = true;

    while (isRunning) {
      printMenu();
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          assignNewPatient();
          break;
        case '2':
          transferPatient();
          break;
        case '3':
          changePatientCondition();
          break;
        case '4':
          showPatients();
          break;
        case '5':
          showAvailableRoomAndBed();
          break;
        case '0':
          isRunning = false;
          print('Exiting system...');
          break;
        default:
          print('Invalid option. Please try again.');
      }
    }
  }

  void printMenu() {
    print('\n=== Room Management System ===');
    print('1. Assign new patient');
    print('2. Transfer patient');
    print('3. Change patient condition');
    print('4. Show patients');
    print('5. Show available room and bed');
    print('0. Exit');
    print('Enter your choice: ');
  }

  void assignNewPatient() {
    print('\n--- Assign New Patient ---');
    // TODO: Implement patient assign new patient logic

    print('Enter patient name: ');
    final name = stdin.readLineSync() ?? '';

    print('\nSelect gender:');
    print('1. Male');
    print('2. Female');
    final genderChoice = stdin.readLineSync();
    final gender = genderChoice == '1'
        ? PatientGender.MALE
        : PatientGender.FEMALE;

    print('\nSelect patient condition:');
    print('1. Stable');
    print('2. Emergency');
    print('3. Critical');
    print('4. Needs Surgery');

    final conditionChoice = stdin.readLineSync();
    PatientCondition condition;
    switch (conditionChoice) {
      case '1':
        condition = PatientCondition.STABLE;
        break;
      case '2':
        condition = PatientCondition.EMERGENCY;
        break;
      case '3':
        condition = PatientCondition.CRITICAL;
        break;
      case '4':
        condition = PatientCondition.NEEDS_SURGERY;
        break;
      default:
        print('Invalid condition. Defaulting to Stable.');
        condition = PatientCondition.STABLE;
    }

    if (condition == PatientCondition.STABLE) {
      print('\nRequest private room? (y/n): ');
      final privateRoom = stdin.readLineSync()?.toLowerCase() == 'y';

      final patient = Patient(
        patientName: name,
        gender: gender,
        entryDate: DateTime.now(),
        condition: condition,
        requestPrivateRoom: privateRoom,
      );
      hospitalSystem.assignNewPatient(patient);
    } else {
      final patient = Patient(
        patientName: name,
        gender: gender,
        entryDate: DateTime.now(),
        condition: condition,
      );
      hospitalSystem.assignNewPatient(patient);
    }

    print('Patient has been assigned successfully.');
  }

  void transferPatient() {
    print('\n--- Transfer Patient ---');

    // TODO: Implement patient transfer logic
    if (hospitalSystem.activePatients.isEmpty) {
      print('No active patients to transfer.');
      return;
    }

    print('Select patient to transfer:');
    for (var i = 0; i < hospitalSystem.activePatients.length; i++) {
      print('${i + 1}. ${hospitalSystem.activePatients[i].patientName}');
    }

    final patientChoice = int.tryParse(stdin.readLineSync() ?? '');
    if (patientChoice == null ||
        patientChoice < 1 ||
        patientChoice > hospitalSystem.activePatients.length) {
      print('Invalid patient selection.');
      return;
    }

    final patient = hospitalSystem.activePatients[patientChoice - 1];

    print('\nSelect new room type:');
    print('1. General Room');
    print('2. Private Room');
    print('3. ICU Room');
    print('4. Emergency Room');
    print('5. Operating Room');

    final roomChoice = stdin.readLineSync();
    RoomType newRoomType;
    switch (roomChoice) {
      case '1':
        newRoomType = RoomType.GENERAL_ROOM;
        break;
      case '2':
        newRoomType = RoomType.PRIVATE_ROOM;
        break;
      case '3':
        newRoomType = RoomType.ICU_ROOM;
        break;
      case '4':
        newRoomType = RoomType.EMERGENCY_ROOM;
        break;
      case '5':
        newRoomType = RoomType.OPERATING_ROOM;
        break;
      default:
        print('Invalid room type selection.');
        return;
    }

    try {
      hospitalSystem.transferPatient(patient, newRoomType);
      print('Patient transferred successfully.');
    } catch (e) {
      print('Error transferring patient: $e');
    }
  }

  void showPatients() {
    print('\n--- Current Patients ---');

    // TODO: Implement showing all patients
    if (hospitalSystem.activePatients.isEmpty) {
      print('No active patients.');
    } else {
      print('\nActive Patients:');
      for (final patient in hospitalSystem.activePatients) {
        final room = hospitalSystem.findPatientCurrentRoom(patient);
        print('- ${patient.patientName}');
        print('  Gender: ${patient.gender}');
        print('  Condition: ${patient.condition}');
        print('  Room Type: ${room?.type}');
        print('  Room Number: ${room?.roomNumber}');
        print('');
      }
    }

    if (hospitalSystem.recoveredPatients.isNotEmpty) {
      print('\nRecovered Patients:');
      for (final patient in hospitalSystem.recoveredPatients) {
        print('- ${patient.patientName}');
        print('  Entry Date: ${patient.entryDate}');
        print('  Leave Date: ${patient.leaveDate}');
        print('');
      }
    }
  }

  void showAvailableRoomAndBed() {
    print('\n--- Available Rooms and Beds ---');

    // TODO: Implement showing available rooms and beds
    void printRoomStatus(String type, List rooms) {
      print('\n$type:');
      for (final room in rooms) {
        final availableBeds = room.beds
            .where((bed) => bed.status == BedStatus.AVAILABLE)
            .length;
        final totalBeds = room.beds.length;
        print(
          'Room ${room.roomNumber}: $availableBeds/$totalBeds beds available',
        );
      }
    }

    printRoomStatus('General Rooms', hospitalSystem.generalRooms);
    printRoomStatus('Private Rooms', hospitalSystem.privateRooms);
    printRoomStatus('ICU Rooms', hospitalSystem.icuRooms);
    printRoomStatus('Emergency Rooms', hospitalSystem.emergancyRooms);
    printRoomStatus('Operating Rooms', hospitalSystem.operatingRooms);
  }

  void changePatientCondition() {
    print('\n--- Change Patient Condition ---');

    if (hospitalSystem.activePatients.isEmpty) {
      print('No active patients.');
      return;
    }

    print('Select patient:');
    for (var i = 0; i < hospitalSystem.activePatients.length; i++) {
      final patient = hospitalSystem.activePatients[i];
      final room = hospitalSystem.findPatientCurrentRoom(patient);
      print(
        '${i + 1}. ${patient.patientName} (Current: ${patient.condition}, Room: ${room?.type})',
      );
    }

    final patientChoice = int.tryParse(stdin.readLineSync() ?? '');
    if (patientChoice == null ||
        patientChoice < 1 ||
        patientChoice > hospitalSystem.activePatients.length) {
      print('Invalid patient selection.');
      return;
    }

    final patient = hospitalSystem.activePatients[patientChoice - 1];

    print('\nSelect new condition:');
    print('1. Stable');
    print('2. Emergency');
    print('3. Critical');
    print('4. Needs Surgery');
    print('5. Recovered');

    final conditionChoice = stdin.readLineSync();
    PatientCondition newCondition;
    switch (conditionChoice) {
      case '1':
        newCondition = PatientCondition.STABLE;
        break;
      case '2':
        newCondition = PatientCondition.EMERGENCY;
        break;
      case '3':
        newCondition = PatientCondition.CRITICAL;
        break;
      case '4':
        newCondition = PatientCondition.NEEDS_SURGERY;
        break;
      case '5':
        newCondition = PatientCondition.RECOVERED;
        break;
      default:
        print('Invalid condition selection.');
        return;
    }

    try {
      hospitalSystem.changePatientCondition(patient, newCondition);
      print('Patient condition updated successfully.');

      if (newCondition == PatientCondition.RECOVERED) {
        print('Patient has been discharged.');
      } else {
        final newRoom = hospitalSystem.findPatientCurrentRoom(patient);
        print('Patient moved to ${newRoom?.type}');
      }
    } catch (e) {
      print('Error updating patient condition: $e');
    }
  }
}
