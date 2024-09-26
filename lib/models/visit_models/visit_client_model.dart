class VisitDetails {
  final int? visitCount; // Allow null values by making it nullable
  final String visitedDate;
  final String? clientVisitedPerson;
  final String? clientVisitedPersonRelation;
  final String note;
  final bool isFollowUp;
  final String newFollowUpdate;
  final String? image;

  VisitDetails({
    this.visitCount, // Not required anymore
    required this.visitedDate,
    this.clientVisitedPerson,
    this.clientVisitedPersonRelation,
    required this.note,
    required this.isFollowUp,
    required this.newFollowUpdate,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'visitCount': visitCount, // Can now be null
      'visitedDate': visitedDate,
      'note': note,
      'isFollowUp': isFollowUp,
      'newFollowUpdate': newFollowUpdate,
    };
  }
}

class VisitClientModel {
  final String clientName;
  final String clientPhoneNumber;
  final String clientEmail;
  final String clientAddress;
  final String clientWhatsApp;
  final List<VisitDetails>? visitDetails;

  VisitClientModel({
    required this.clientName,
    required this.clientPhoneNumber,
    required this.clientEmail,
    required this.clientAddress,
    required this.clientWhatsApp,
    this.visitDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientPhoneNumber': clientPhoneNumber,
      'clientEmail': clientEmail,
      'clientAddress': clientAddress,
      'clientWhatsApp': clientWhatsApp,
      'visitDetails': visitDetails?.map((visit) => visit.toMap()).toList(),
    };
  }
}
