import 'package:test/test.dart';
import 'package:room_management/domian/models/bed.dart';
import 'package:room_management/domian/models/patient.dart';
import 'package:room_management/domian/models/enum.dart';

void main() {
  group('Bed Tests', () {
    late Bed bed;

    setUp(() {
      bed = Bed();
    });

    test('Initial bed status should be AVAILABLE', () {
      expect(bed.status, equals(BedStatus.AVAILABLE));
      expect(bed.patient, isNull);
    });

    test('Assign patient to bed', () {
      final patient = Patient(
        patientName: 'John',
        gender: PatientGender.MALE,
        entryDate: DateTime.now(),
        condition: PatientCondition.STABLE,
      );

      bed.assignPatient(patient);
      expect(bed.status, equals(BedStatus.OCCUPIED));
      expect(bed.patient, equals(patient));
    });

    test('Release patient from bed', () {
      final patient = Patient(
        patientName: 'John',
        gender: PatientGender.MALE,
        entryDate: DateTime.now(),
        condition: PatientCondition.STABLE,
      );

      bed.assignPatient(patient);
      bed.releasePatient();

      expect(bed.status, equals(BedStatus.AVAILABLE));
      expect(bed.patient, isNull);
    });
  });
}
