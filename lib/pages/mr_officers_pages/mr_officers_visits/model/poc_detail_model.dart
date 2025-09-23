import 'dart:convert';

PocDetails pocDetailsFromJson(String str) => PocDetails.fromJson(json.decode(str));

String pocDetailsToJson(PocDetails data) => json.encode(data.toJson());

class PocDetails {
  String id;
  String pocName;
  int age;
  String number;
  String country;
  String region;
  String city;
  String address;
  String category;
  String specialization;
  String organization;
  String ambNumber;
  bool deleted;
  String createdById;
  // String createdByName;
  int visitCounter;
  int referralCounter;
  // List<dynamic> referral;
  DateTime createdAt;
  DateTime updatedAt;
  // int v;
  String gender;

  PocDetails({
    required this.id,
    required this.pocName,
    required this.age,
    required this.number,
    required this.country,
    required this.region,
    required this.city,
    required this.address,
    required this.category,
    required this.specialization,
    required this.organization,
    required this.ambNumber,
    required this.deleted,
    required this.createdById,
    required this.visitCounter,
    required this.referralCounter,
    required this.createdAt,
    required this.updatedAt,
    required this.gender,
  });

  factory PocDetails.fromJson(Map<String, dynamic> json) => PocDetails(
    id: json["_id"],
    pocName: json["pocName"],
    age: json["age"],
    number: json["number"],
    country: json["country"],
    region: json["region"],
    city: json["city"],
    address: json["address"],
    category: json["category"],
    specialization: json["specialization"],
    organization: json["organization"],
    ambNumber: json["ambNumber"],
    deleted: json["deleted"],
    createdById: json["createdById"],
    // createdByName: json["createdByName"] ?? '',
    visitCounter: json["visitCounter"],
    referralCounter: json["referralCounter"],
    // referral: List<dynamic>.from(json["referral"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    // v: json["__v"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "pocName": pocName,
    "age": age,
    "number": number,
    "country": country,
    "region": region,
    "city": city,
    "address": address,
    "category": category,
    "specialization": specialization,
    "organization": organization,
    "ambNumber": ambNumber,
    "deleted": deleted,
    "createdById": createdById,
    // "createdByName": createdByName,
    "visitCounter": visitCounter,
    "referralCounter": referralCounter,
    // "referral": List<dynamic>.from(referral.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    // "__v": v,
    "gender": gender,
  };
}
