import 'package:room_management/domian/models/enum.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid().v4();

class Patient {
  final String patientId;
  final String patientName;
  final PatientGender gender;
  final DateTime entryDate;
  DateTime? leaveDate;
  PatientCondition condition;
  bool requestPrivateRoom;

  String? currentBed;
  List<String> bedHistroy = [];
  List<String> history = [];

  Patient({
    String? patientId,
    required this.patientName,
    required this.gender,
    required this.entryDate,
    required this.condition,
    this.requestPrivateRoom = false,
    this.leaveDate,
  }) : patientId = patientId ?? uuid;

  void assignBed(String bedId) {
    currentBed = bedId;
    bedHistroy.add(bedId);
  }

  void releaseBed() => currentBed = null;

  Map<String, dynamic> toJson() => {
    'patientId': patientId,
    'patientName': patientName,
    'gender': gender.toString(),
    'entryDate': entryDate.toIso8601String(),
    'leaveDate': leaveDate?.toIso8601String(),
    'condition': condition.toString(),
    'requestPrivateRoom': requestPrivateRoom,
    'currentBed': currentBed,
    'bedHistory': bedHistroy,
    'history': history,
  };

// AI generate
  factory Patient.fromJson(Map<String, dynamic> json) {
    var patient = Patient(
      patientId: json['patientId'],
      patientName: json['patientName'],
      gender: PatientGender.values.firstWhere(
        (e) => e.toString() == json['gender'],
      ),
      entryDate: DateTime.parse(json['entryDate']),
      leaveDate: json['leaveDate'] != null
          ? DateTime.parse(json['leaveDate'])
          : null,
      condition: PatientCondition.values.firstWhere(
        (e) => e.toString() == json['condition'],
      ),
      requestPrivateRoom: json['requestPrivateRoom'],
    );
    patient.currentBed = json['currentBed'];
    patient.bedHistroy = List<String>.from(json['bedHistory']);
    patient.history = List<String>.from(json['history']);
    return patient;
  }
}
