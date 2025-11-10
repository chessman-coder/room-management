import 'package:test/test.dart';
import 'package:room_management/domian/models/patient.dart';
import 'package:room_management/domian/models/enum.dart';

void main() {
  group('Patient Tests', () {
    late Patient patient;

    setUp(() {
      patient = Patient(
        patientName: 'John Doe',
        gender: PatientGender.MALE,
        entryDate: DateTime.now(),
        condition: PatientCondition.STABLE,
      );
    });

    test('Patient initialization', () {
      expect(patient.patientName, equals('John Doe'));
      expect(patient.gender, equals(PatientGender.MALE));
      expect(patient.condition, equals(PatientCondition.STABLE));
      expect(patient.currentBed, isNull);
    });

    test('Assign bed to patient', () {
      String bedId = 'bed123';
      patient.assignBed(bedId);

      expect(patient.currentBed, equals(bedId));
      expect(patient.bedHistroy, contains(bedId));
    });

    test('Release bed from patient', () {
      String bedId = 'bed123';
      patient.assignBed(bedId);
      patient.releaseBed();

      expect(patient.currentBed, isNull);
      expect(patient.bedHistroy, contains(bedId));
    });
  });
}
