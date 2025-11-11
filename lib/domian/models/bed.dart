import 'package:room_management/domian/models/enum.dart';
import 'package:uuid/uuid.dart';
import 'patient.dart';

class Bed {
  final String bedId;
  Patient? patient;
  BedStatus status;

  Bed({String? bedId, this.patient, this.status = BedStatus.AVAILABLE})
    : bedId = bedId ?? Uuid().v4();

  void assignPatient(Patient newPatient) {
    patient = newPatient;
    newPatient.assignBed(bedId);
    status = BedStatus.OCCUPIED;
  }

  void releasePatient() {
    patient?.releaseBed();
    patient = null;
    status = BedStatus.AVAILABLE;
  }

  Map<String, dynamic> toJson() {
    // Make sure status matches patient presence
    status = patient != null ? BedStatus.OCCUPIED : BedStatus.AVAILABLE;

    return {
      'bedId': bedId,
      'status': status.toString().split('.').last,
      'patient': patient?.toJson(),
    };
  }

  factory Bed.fromJson(Map<String, dynamic> json) {
    var bed = Bed(
      bedId: json['bedId'],
      status: BedStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => BedStatus.AVAILABLE,
      ),
    );

    // If there's a patient, load them and update bed status
    if (json['patient'] != null) {
      bed.patient = Patient.fromJson(json['patient']);
      bed.status = BedStatus.OCCUPIED;
    } else {
      bed.status = BedStatus.AVAILABLE;
    }

    return bed;
  }
}
