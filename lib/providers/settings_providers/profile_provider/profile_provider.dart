import 'package:flutter/foundation.dart';

class ProfileSetter {

  ProfileSetter({
    // required this.employee_name,
    // required this.address,
    // required this.date_of_birth,
    // required this.gender,
    // required this.marital_status,
    // required this.prefered_contact_email,
    // // required this.AttendanceId,
    // required this.date_of_joining,
    // required this.department,
    // required this.designation,
    // required this.default_shift,
    // required this.notice_number_of_days,
    // required this.date_of_retirement,

    ////////////////////////////////

    this.employee_name = 'Amuly Sharma',
     this.address = 'biratnagar 12',
     this.date_of_birth = '1997-01-1',
     this.gender = 'Male',
    this.marital_status = 'unmarried',
    this.prefered_contact_email = 'amulya123@gmial.com',
    // required this.AttendanceId,
     this.date_of_joining = '2024-08-17',
     this.department = 'developer',
     this.designation = 'Manager',
     this.default_shift = 'General',
     this.notice_number_of_days = '0',
     this.date_of_retirement = '2057-01-16',
  });

  final String employee_name;
  final String address;
  final String date_of_birth;
  final String gender;
  final String marital_status;
  final String prefered_contact_email;
  // final String AttendanceId;
  final String date_of_joining;
  final String department;
  final String designation;
  final String default_shift;
  final String notice_number_of_days;
  final String date_of_retirement;
}

class ProfileProvider extends ChangeNotifier{

  String _employee_name = '';
  String _address = '';
  String _date_of_birth = '';
  String _gender = '';
  String _marital_status = '';
  String _prefered_contact_email = '';
  String _date_of_joining = '';
  String _department = '';
  String _designation ='';
  String _default_shift = '';
  String _notice_number_of_days = '';
  String _date_of_retirement = '';


   String get employee_name => _employee_name;
   String get address => _address;
   String get date_of_birth => _date_of_birth;
   String get gender => _gender;
   String get marital_status => _marital_status;
   String get prefered_contact_email => _prefered_contact_email;
   String get date_of_joining => _date_of_joining;
   String get department => _department;
   String get designation => _designation;
   String get default_shift => _default_shift;
   String get notice_number_of_days => _notice_number_of_days;
   String get date_of_retirement => _date_of_retirement;

   void setProfileValues(ProfileSetter profile){
     _employee_name = profile.employee_name;
     _address = profile.address;
     _date_of_birth = profile.date_of_birth;
     _gender = profile.gender;
     _marital_status = profile.marital_status;
     _prefered_contact_email = profile.prefered_contact_email;
     // _AttendanceId = profile.AttendanceId;
     _date_of_joining = profile.date_of_joining;
     _department = profile.department;
     _designation = profile.designation;
     _default_shift = profile.default_shift;
     _notice_number_of_days = profile.notice_number_of_days;
     _date_of_retirement = profile.date_of_retirement;
     notifyListeners();
   }
}