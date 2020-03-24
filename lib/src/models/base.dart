import 'package:cloud_firestore/cloud_firestore.dart';

class BaseDocument {
  String id;
  String creator;
  Timestamp createdAt;

  BaseDocument(this.creator, {this.id}) : createdAt = Timestamp.now();

  BaseDocument.fromJson(Map<String, dynamic> json, {String id})
      : id = id != null ? id : json["id"],
        creator = json["creator"],
        createdAt =
            json["createdAt"] != null ? json["createdAt"] : Timestamp.now();

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json["createdAt"] = createdAt;
    json["creator"] = creator;
    if (id != null) json["id"] = id;
    return json;
  }
}
