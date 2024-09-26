class VisitDetails {
  // final Map<String, dynamic>? visitDetails;
  final String visitedDate;
  final String note;
  final bool isFollowUp;
  final newFollowUpdate;

  VisitDetails({
    // this.visitDetails,
    required this.visitedDate,
    required this.note,
    required this.isFollowUp,
    required this.newFollowUpdate,
  });
}

class VisitClientModel {
  final String clientName;
  final String clientPhoneNumber;
  final String clientEmail;
  final String clientAddress;
  final String clientWhatsApp;
  final String? clientVisitedPerson;
  final String? clientVisitedPersonRelation;
  final List<VisitDetails>? visitDetails;

  VisitClientModel({
    required this.clientName,
    required this.clientPhoneNumber,
    required this.clientEmail,
    required this.clientAddress,
    required this.clientWhatsApp,
    this.clientVisitedPerson = '',
    this.clientVisitedPersonRelation = '',
    this.visitDetails,
  });
}
