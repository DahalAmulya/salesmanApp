import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) =>
    AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) =>
    json.encode(data.toJson());

class AttendanceModel {
  int? attendanceId;
  String? status;
  String? deviceTime;
  DateTime? attendanceTime;
  double? latitude;
  double? longitude;

  AttendanceModel({
    this.attendanceId,
    this.status,
    this.deviceTime,
    this.attendanceTime,
    this.latitude,
    this.longitude,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    attendanceId: json["attendanceId"],
    status: json["status"],
    deviceTime: json["deviceTime"],
    attendanceTime: json["attendanceTime"] != null
        ? DateTime.tryParse(json["attendanceTime"])
        : null,
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "attendanceId": attendanceId,
    "status": status,
    "deviceTime": deviceTime,
    "attendanceTime": attendanceTime?.toIso8601String(),
    "latitude": latitude,
    "longitude": longitude,
  };
}
