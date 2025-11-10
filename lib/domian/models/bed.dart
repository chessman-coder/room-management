import 'package:room_management/domian/models/enum.dart';
import 'package:uuid/uuid.dart';
import 'patient.dart';

var uuid = Uuid().v4();

class Bed {
  final String bedId;
  Patient? patient;
  BedStatus status;

  Bed({String? bedId, this.patient, this.status = BedStatus.AVAILABLE})
    : bedId = bedId ?? uuid;

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

  Map<String, dynamic> toJson() => {
    'bedId': bedId,
    'status': status,
    'patient': patient?.toJson(),
  };

  factory Bed.fromJson(Map<String, dynamic> json) => Bed(
      bedId: json['bedId'],
      status: BedStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      patient: json['patient'] != null
          ? Patient.fromJson(json['patient'])
          : null,
    );
  
}
