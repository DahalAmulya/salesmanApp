import 'dart:convert';

List<ApprovalStatusPayload> approvalStatusPayloadFromJson(String str) => List<ApprovalStatusPayload>.from(json.decode(str).map((x) => ApprovalStatusPayload.fromJson(x)));

String approvalStatusPayloadToJson(List<ApprovalStatusPayload> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ApprovalStatusPayload {
  String? referralId;
  String? approvalStatus;

  ApprovalStatusPayload({
    this.referralId,
    this.approvalStatus,
  });

  factory ApprovalStatusPayload.fromJson(Map<String, dynamic> json) => ApprovalStatusPayload(
    referralId: json["referralId"],
    approvalStatus: json["approvalStatus"],
  );

  Map<String, dynamic> toJson() => {
    "referralId": referralId,
    "approvalStatus": approvalStatus,
  };
}