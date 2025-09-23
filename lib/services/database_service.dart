import 'package:deskgoo/pages/mr_officers_pages/attendance_logs/model/attendance_model.dart';
import 'package:deskgoo/pages/mr_officers_pages/mr_officers_visits/model/poc_create_model.dart';
import 'package:deskgoo/themes/custom_colors.dart';
import 'package:deskgoo/utils/toast_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  // POC Table Operations
  final String _pocTableName = 'pocs';
  final String _pocIdColumn = 'pocId';
  final String _pocNameColumn = 'pocName';
  final String _genderColumn = 'gender';
  final String _numberColumn = 'number';
  final String _countryColumn = 'country';
  final String _regionColumn = 'region';
  final String _cityColumn = 'city';
  final String _addressColumn = 'address';
  final String _categoryColumn = 'category';
  final String _specializationColumn = 'specialization';
  final String _ambNumberColumn = 'ambNumber';
  final String _organizationColumn = 'organization';
  final String _remarksColumn = 'remarks';
  final String _createdByIdColumn = 'createdById';
  final String _mobileTimeColumn = 'mobileTime';
  final String _visitDateColumn = 'visitDate';
  final String _latitudeColumn = 'latitude';
  final String _longitudeColumn = 'longitude';

  // Attendance Table Operations
  final String _attendanceTableName = 'attendance';
  final String _attendanceIdColumn = 'attendanceId';
  final String _attendanceStatusColumn = 'status';
  final String _deviceTimeColumn = 'deviceTime';
  final String _attendanceTimeColumn = 'attendanceTime';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'master_db.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_pocTableName (
          $_pocIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_pocNameColumn TEXT NOT NULL,
          $_genderColumn TEXT NOT NULL,
          $_numberColumn TEXT NOT NULL,
          $_countryColumn TEXT NOT NULL,
          $_regionColumn TEXT NOT NULL,
          $_cityColumn TEXT NOT NULL,
          $_addressColumn TEXT NOT NULL,
          $_categoryColumn TEXT NOT NULL,
          $_specializationColumn TEXT NOT NULL,
          $_ambNumberColumn TEXT,
          $_organizationColumn TEXT,
          $_remarksColumn TEXT NOT NULL,
          $_createdByIdColumn TEXT NOT NULL,
          $_mobileTimeColumn TEXT NOT NULL,
          $_visitDateColumn TEXT NOT NULL,
          $_latitudeColumn REAL NOT NULL,
          $_longitudeColumn REAL NOT NULL
        )
      ''');

        await db.execute('''
        CREATE TABLE $_attendanceTableName (
          $_attendanceIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
          $_attendanceStatusColumn TEXT NOT NULL,
          $_deviceTimeColumn TEXT NOT NULL,
          $_attendanceTimeColumn TEXT NOT NULL,
          $_latitudeColumn REAL NOT NULL,
          $_longitudeColumn REAL NOT NULL
        )
      ''');
      },
    );
  }

  Future<bool> createPOC(PocModel poc) async {
    final db = await database;

    // Check if number already exists
    final existing = await db.query(
      _pocTableName,
      where: '$_numberColumn = ?',
      whereArgs: [poc.number],
    );

    if (existing.isNotEmpty) {
      debugPrint('POC with number ${poc.number} already exists. Skipping insert.');
      ToastMessageUtils().showToastMessage('POC save failed!\nNumber already exists.');
      return false; // prevent duplicate
    }

    // Insert new POC
    await db.insert(_pocTableName, {
      _pocNameColumn: poc.pocName,
      _genderColumn: poc.gender,
      _numberColumn: poc.number,
      _countryColumn: poc.country,
      _regionColumn: poc.region,
      _cityColumn: poc.city,
      _addressColumn: poc.address,
      _categoryColumn: poc.category,
      _specializationColumn: poc.specialization,
      _ambNumberColumn: poc.ambNumber,
      _organizationColumn: poc.organization,
      _remarksColumn: poc.remarks,
      _createdByIdColumn: poc.createdById,
      _mobileTimeColumn: poc.mobileTime,
      _visitDateColumn: poc.visitDate,
      _latitudeColumn: poc.latitude,
      _longitudeColumn: poc.longitude,
    });
    ToastMessageUtils().showToastMessage('POC saved successfully.', ToastGravity.TOP, CustomColors.jadeGreen);
    debugPrint('Inserted POC: ${poc.toJson()}');
    return true;
  }


  Future<List<PocModel>> getAllPOCs() async {
    final db = await database;
    final data = await db.query(_pocTableName);

    debugPrint('Fetched POCs: $data');

    return data.map((e) => PocModel.fromJson(e)).toList();
  }

  /// 🔹 Get a single POC by primary key ID
  Future<PocModel?> getPOCById(int id) async {
    final db = await database;
    final data = await db.query(
      _pocTableName,
      where: '$_pocIdColumn = ?',
      whereArgs: [id],
    );

    if (data.isNotEmpty) {
      return PocModel.fromJson(data.first);
    } else {
      return null; // no record found
    }
  }

  /// 🔹 Update by primary key ID
  /// You can pass either a full PocModel (using toJson)
  /// or a partial Map<String, dynamic> with only fields to update
  Future<int> updatePOCById(int id, Map<String, dynamic> values) async {
    final db = await database;
    debugPrint('Updated POC ID $id with values: $values');
    return await db.update(
      _pocTableName,
      values,
      where: '$_pocIdColumn = ?',
      whereArgs: [id],
    );
  }

  /// 🔹 Delete all rows
  Future<int> deleteAllPOCs() async {
    final db = await database;
    return await db.delete(_pocTableName);
  }

  /// 🔹 Delete by primary key ID
  Future<int> deletePOCById(int id) async {
    final db = await database;
    return await db.delete(
      _pocTableName,
      where: '$_pocIdColumn = ?',
      whereArgs: [id],
    );
  }

  Future<void> createAttendance(AttendanceModel attendance) async {
    final db = await database;

    await db.insert(
      _attendanceTableName,
      attendance.toJson(),
    );

    ToastMessageUtils().showToastMessage(
      'Attendance saved successfully.',
      ToastGravity.TOP,
      CustomColors.jadeGreen,
    );
    debugPrint('Inserted Attendance: ${attendance.toJson()}');
  }

  Future<List<AttendanceModel>> getAllAttendance() async {
    final db = await database;
    final data = await db.query(_attendanceTableName);

    debugPrint('Fetched Attendance: $data');

    return data.map((e) => AttendanceModel.fromJson(e)).toList();
  }

  /// 🔹 Get a single POC by primary key ID
  Future<AttendanceModel?> getAttendanceById(int id) async {
    final db = await database;
    final data = await db.query(
      _attendanceTableName,
      where: '$_attendanceIdColumn = ?',
      whereArgs: [id],
    );

    if (data.isNotEmpty) {
      return AttendanceModel.fromJson(data.first);
    } else {
      return null; // no record found
    }
  }

  Future<AttendanceModel> getLastAttendance() async {
    final db = await database;
    final data = await db.query(
      _attendanceTableName,
      orderBy: '$_attendanceIdColumn DESC',
      limit: 1,
    );

    if (data.isNotEmpty) {
      return AttendanceModel.fromJson(data.first);
    } else {
      throw Exception('No attendance records found');
    }
  }

  /// 🔹 Update by primary key ID
  /// You can pass either a full PocModel (using toJson)
  /// or a partial Map<String, dynamic> with only fields to update
  Future<int> updateAttendanceById(int id, Map<String, dynamic> values) async {
    final db = await database;
    debugPrint('Updated POC ID $id with values: $values');
    return await db.update(
      _attendanceTableName,
      values,
      where: '$_attendanceIdColumn = ?',
      whereArgs: [id],
    );
  }

  /// 🔹 Delete all rows
  Future<int> deleteAllAttendance() async {
    final db = await database;
    return await db.delete(_attendanceTableName);
  }

  /// 🔹 Delete by primary key ID
  Future<int> deleteAttendanceById(int id) async {
    final db = await database;
    return await db.delete(
      _attendanceTableName,
      where: '$_attendanceIdColumn = ?',
      whereArgs: [id],
    );
  }
}
