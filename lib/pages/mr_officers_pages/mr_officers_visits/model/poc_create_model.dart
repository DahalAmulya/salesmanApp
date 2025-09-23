class PocModel {
  final int? pocId;
  final String? pocName;
  final String? gender;
  final String? number;
  final String? country;
  final String? region;
  final String? city;
  final String? address;
  final String? category;
  final String? specialization;
  final String? organization;
  final String? ambNumber;
  final String? createdById;
  final String? remarks;
  final String? mobileTime;
  final String? visitDate;
  final double? latitude;
  final double? longitude;

  PocModel({
    this.pocId,
    this.pocName,
    this.gender,
    this.number,
    this.country,
    this.region,
    this.city,
    this.address,
    this.category,
    this.specialization,
    this.organization,
    this.ambNumber,
    this.createdById,
    this.remarks,
    this.mobileTime,
    this.visitDate,
    this.latitude,
    this.longitude,
  });

  factory PocModel.fromJson(Map<String, dynamic> json) {
    return PocModel(
      pocId: json['pocId'] as int?,
      pocName: json['pocName'] as String?,
      gender: json['gender'] as String?,
      number: json['number'] as String?,
      country: json['country'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      category: json['category'] as String?,
      specialization: json['specialization'] as String?,
      organization: json['organization'] as String?,
      ambNumber: json['ambNumber'] as String?,
      createdById: json['createdById'] as String?,
      remarks: json['remarks'] as String?,
      mobileTime: json['mobileTime'] as String?,
      visitDate: json['visitDate'] as String?,
      latitude: (json['latitude'] != null)
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: (json['longitude'] != null)
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pocId': pocId,
      'pocName': pocName,
      'gender': gender,
      'number': number,
      'country': country,
      'region': region,
      'city': city,
      'address': address,
      'category': category,
      'specialization': specialization,
      'organization': organization,
      'ambNumber': ambNumber,
      'createdById': createdById,
      'remarks': remarks,
      'mobileTime': mobileTime,
      'visitDate': visitDate,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
