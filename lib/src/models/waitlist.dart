import 'package:vouched/src/models/base.dart';

class WaitList extends BaseDocument {
  final String email;
  final String name;
  final String phone;
  final bool approved;

  WaitList({
    id,
    creator,
    this.phone,
    this.email,
    this.name,
    this.approved,
  }) : super(creator, id: id);

  WaitList.fromJson(Map json, {String id})
      : email = json["email"],
        name = json["name"],
        phone = json["phone"],
        approved = json["approved"],
        super.fromJson(json, id: id);

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    var additionalMap = {
      'email': email,
      'name': name,
      'phone': phone,
      'approved': approved ?? false,
    };
    additionalMap.removeWhere((_, value) => value == null);
    json.addAll(additionalMap);
    return json;
  }
}
