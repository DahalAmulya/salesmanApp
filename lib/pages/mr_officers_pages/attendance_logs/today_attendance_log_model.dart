// To parse this JSON data, do
//
//     final todayAttendanceLog = todayAttendanceLogFromJson(jsonString);

import 'dart:convert';

TodayAttendanceLog todayAttendanceLogFromJson(String str) => TodayAttendanceLog.fromJson(json.decode(str));

String todayAttendanceLogToJson(TodayAttendanceLog data) => json.encode(data.toJson());

class TodayAttendanceLog {
  String? message;
  double? totalHours;
  String? totalTime;
  Attendance? attendance;

  TodayAttendanceLog({
    this.message,
    this.totalHours,
    this.totalTime,
    this.attendance,
  });

  factory TodayAttendanceLog.fromJson(Map<String, dynamic> json) => TodayAttendanceLog(
    message: json["message"],
    totalHours: json["totalHours"]?.toDouble(),
    totalTime: json["totalTime"],
    attendance: Attendance.fromJson(json["attendance"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "totalHours": totalHours,
    "totalTime": totalTime,
    "attendance": attendance!.toJson(),
  };
}

class Attendance {
  String id;
  String username;
  List<AttendanceLog> attendanceLogs;

  Attendance({
    required this.id,
    required this.username,
    required this.attendanceLogs,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    id: json["_id"],
    username: json["username"],
    attendanceLogs: List<AttendanceLog>.from(json["attendanceLogs"].map((x) => AttendanceLog.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "attendanceLogs": List<dynamic>.from(attendanceLogs.map((x) => x.toJson())),
  };
}

class AttendanceLog {
  String checkIn;
  double checkInLatitude;
  double checkInLongitude;
  String checkOut;
  double checkOutLatitude;
  double checkOutLongitude;
  double totalHour;
  String id;

  AttendanceLog({
    required this.checkIn,
    required this.checkInLatitude,
    required this.checkInLongitude,
    required this.checkOut,
    required this.checkOutLatitude,
    required this.checkOutLongitude,
    required this.totalHour,
    required this.id,
  });

  factory AttendanceLog.fromJson(Map<String, dynamic> json) => AttendanceLog(
    checkIn: json["checkIn"],
    checkInLatitude: json["checkInLatitude"]?.toDouble(),
    checkInLongitude: json["checkInLongitude"]?.toDouble(),
    checkOut: json["checkOut"] ?? 'Not Checked Out',
    checkOutLatitude: json["checkOutLatitude"]?.toDouble(),
    checkOutLongitude: json["checkOutLongitude"]?.toDouble(),
    totalHour: json["totalHour"]?.toDouble(),
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "checkIn": checkIn,
    "checkInLatitude": checkInLatitude,
    "checkInLongitude": checkInLongitude,
    "checkOut": checkOut,
    "checkOutLatitude": checkOutLatitude,
    "checkOutLongitude": checkOutLongitude,
    "totalHour": totalHour,
    "_id": id,
  };
}