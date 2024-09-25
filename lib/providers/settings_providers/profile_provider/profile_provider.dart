import 'package:flutter/foundation.dart';

class ProfileSetter {

  ProfileSetter({
    required this.employee_name,
    required this.address,
    required this.date_of_birth,
    required this.gender,
    required this.marital_status,
    required this.prefered_contact_email,
    // required this.AttendanceId,
    required this.date_of_joining,
    required this.department,
    required this.designation,
    required this.default_shift,
    required this.notice_number_of_days,
    required this.date_of_retirement,
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

   void setName(String name){
     _employee_name = employee_name;
     notifyListeners();
   }

   void setAddress(String address){
     _address = address;
     notifyListeners();
   }

   void setGender(String gender){
     _gender = gender;
     notifyListeners();
   }

   void setMaritalStatus(String maritalStatus){
     _marital_status = marital_status;
     notifyListeners();
   }

   void setEmail(String email){
     _prefered_contact_email = prefered_contact_email;
     notifyListeners();
   }

   void setJoiningDate(String date){
     _date_of_joining = date_of_joining;
     notifyListeners();
   }

   void setDepartment(String department){
     _department = department;
     notifyListeners();
   }

   void setDesignation(String designation){
     _designation = designation;
     notifyListeners();
   }

   void setDefaultShift(String shift){
     _default_shift = default_shift;
     notifyListeners();
   }

   void setNoticeDays(String days){
     _notice_number_of_days = notice_number_of_days;
     notifyListeners();
   }

   void setRetirementDate(String date){
     _date_of_retirement = date_of_retirement;
     notifyListeners();
   }

}