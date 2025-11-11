import 'package:test/test.dart';
import 'package:room_management/domian/models/enum.dart';
import 'package:room_management/domian/models/patient.dart';
import 'package:room_management/domian/services/hospitalManagement.dart';

void main() {
  group('Hospital Management Tests', () {
    late HospitalSystem hospital;

    setUp(() {
      hospital = HospitalSystem();
    });

    test('Initial room setup', () {
      expect(hospital.generalRooms.length, equals(10));
      expect(hospital.icuRooms.length, equals(5));
      expect(hospital.privateRooms.length, equals(5));
      expect(hospital.emergencyRooms.length, equals(5));
      expect(hospital.operatingRooms.length, equals(5));
    });

    test('Assign new patient', () {
      final patient = Patient(
        patientName: 'John',
        gender: PatientGender.MALE,
        entryDate: DateTime.now(),
        condition: PatientCondition.CRITICAL,
      );

      hospital.assignNewPatient(patient);

      expect(hospital.activePatients, contains(patient));
      final room = hospital.findPatientCurrentRoom(patient);
      expect(room?.type, equals(RoomType.ICU_ROOM));
    });
  });
}
