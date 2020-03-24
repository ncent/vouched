import 'package:vouched/src/models/base.dart';

class Invitation extends BaseDocument {
  final String userId;
  final String userEmail;
  final String userName;

  final String contactId;
  final String contactEmail;
  final String contactName;
  final String contactPhone;

  Invitation(
    String id,
    creator,
    this.userId,
    this.userEmail,
    this.userName,
    this.contactId,
    this.contactEmail,
    this.contactName,
    this.contactPhone
  ): super(creator, id: id);

  Invitation.fromJson(Map<String, dynamic> data, {String id}):
    userId = data["userId"],
    userEmail = data["userEmail"],
    userName = data["userName"],
    contactId = data["contactId"],
    contactEmail = data["contactEmail"],
    contactName = data["contactName"],
    contactPhone = data["contactPhone"],
    super.fromJson(data, id: id);

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    var additionalMap = {
      'userId': userId,
      'userEmail': userEmail,
      'userName': userName,
      'contactId': contactId,
      'contactEmail': contactEmail,
      'contactName': contactName,
      'contactPhone': contactPhone
    };
    additionalMap.removeWhere((_, value) => value == null);
    json.addAll(additionalMap);
    return json;
  }
}