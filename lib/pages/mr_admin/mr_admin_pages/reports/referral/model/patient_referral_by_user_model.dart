import 'dart:convert';

PatientReferralByUserModel patientReferralByUserModelFromJson(String str) => PatientReferralByUserModel.fromJson(json.decode(str));

String patientReferralByUserModelToJson(PatientReferralByUserModel data) => json.encode(data.toJson());

class PatientReferralByUserModel {
  int total;
  int currentPage;
  int totalPages;
  List<Datum>? data;

  PatientReferralByUserModel({
    this.total = 0,
    this.currentPage = 1,
    this.totalPages = 0,
    this.data,
  });

  factory PatientReferralByUserModel.fromJson(Map<String, dynamic> json) => PatientReferralByUserModel(
    total: json["total"],
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "currentPage": currentPage,
    "totalPages": totalPages,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String fullName;
  int age;
  String gender;
  String provisionalDiagnosis;
  int weight;
  String bloodGroup;
  String number;
  String email;
  String country;
  String region;
  String city;
  String address;
  UserId userId;
  Id? pocId;
  Id? ambId;
  double latitude;
  double longitude;
  String mobileTime;
  DateTime createdAt;
  String remarks;
  String approvalStatus;
  DateTime updatedAt;
  int v;
  String createdAtBS;

  Datum({
    required this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.provisionalDiagnosis,
    required this.weight,
    required this.bloodGroup,
    required this.number,
    required this.email,
    required this.country,
    required this.region,
    required this.city,
    required this.address,
    required this.userId,
    required this.pocId,
    required this.ambId,
    required this.latitude,
    required this.longitude,
    required this.mobileTime,
    required this.createdAt,
    required this.remarks,
    required this.approvalStatus,
    required this.updatedAt,
    required this.v,
    required this.createdAtBS,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    fullName: json["fullName"],
    age: json["age"],
    gender: json["gender"],
    provisionalDiagnosis: json["provisionalDiagnosis"],
    weight: json["weight"],
    bloodGroup: json["bloodGroup"],
    number: json["number"],
    email: json["email"],
    country: json["country"],
    region: json["region"],
    city: json["city"],
    address: json["address"],
    userId: UserId.fromJson(json["userId"]),
    pocId: json["pocId"] == null ? null : Id.fromJson(json["pocId"]),
    ambId: json["ambId"] == null ? null : Id.fromJson(json["ambId"]),
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    mobileTime: json["mobileTime"],
    createdAt: DateTime.parse(json["createdAt"]),
    remarks: json["remarks"],
    approvalStatus: json["approvalStatus"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    createdAtBS: json["createdAtBS"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullName": fullName,
    "age": age,
    "gender": gender,
    "provisionalDiagnosis": provisionalDiagnosis,
    "weight": weight,
    "bloodGroup": bloodGroup,
    "number": number,
    "email": email,
    "country": country,
    "region": region,
    "city": city,
    "address": address,
    "userId": userId.toJson(),
    "pocId": pocId?.toJson(),
    "ambId": ambId?.toJson(),
    "latitude": latitude,
    "longitude": longitude,
    "mobileTime": mobileTime,
    "createdAt": createdAt.toIso8601String(),
    "remarks": remarks,
    "approvalStatus": approvalStatus,
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "createdAtBS": createdAtBS
  };
}

class Id {
  String id;
  String pocName;
  String number;
  String category;
  String specialization;
  String? ambNumber;

  Id({
    required this.id,
    required this.pocName,
    required this.number,
    required this.category,
    required this.specialization,
    this.ambNumber,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
    id: json["_id"],
    pocName: json["pocName"],
    number: json["number"],
    category: json["category"],
    specialization: json["specialization"],
    ambNumber: json["ambNumber"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "pocName": pocName,
    "number": number,
    "category": category,
    "specialization": specialization,
    "ambNumber": ambNumber,
  };
}

class UserId {
  String id;
  String username;
  String profileImage;

  UserId({
    required this.id,
    required this.username,
    required this.profileImage,
  });

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
    id: json["_id"],
    username: json["username"],
    profileImage: json["profileImage"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "profileImage": profileImage,
  };
}