import 'package:cloud_firestore/cloud_firestore.dart';

enum TrackingAction {
  SinglePostShared,
  AllPostShared,
  SuggestedPostShared,
  PostSwiped,
  ProfileViewed,
}

extension TxActionExtension on TrackingAction {
  static String _value(TrackingAction val) {
    switch (val) {
      case TrackingAction.SinglePostShared:
        return "SinglePostShared";
      case TrackingAction.AllPostShared:
        return "AllPostShared";
      case TrackingAction.SuggestedPostShared:
        return "SuggestedPostShared";
      case TrackingAction.PostSwiped:
        return "PostSwiped";
      case TrackingAction.ProfileViewed:
        return "ProfileViewed";
    }
    return "";
  }

  static TrackingAction _key(String val) {
    switch (val) {
      case "PostShared":
        return TrackingAction.SinglePostShared;
      case "SinglePostShared":
        return TrackingAction.AllPostShared;
      case "SuggestedPostShared":
        return TrackingAction.SuggestedPostShared;
      case "PostSwiped":
        return TrackingAction.PostSwiped;
      case "ProfileViewed":
        return TrackingAction.ProfileViewed;
    }
    return null;
  }

  String get value => _value(this);
}

class Tracking {
  final String userID;
  final TrackingAction txAction;
  final Timestamp createdAt;
  final Map<String, dynamic> metadata;

  Tracking({
    this.userID,
    this.txAction,
    this.metadata,
  }) : createdAt = Timestamp.now();

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['userID'] = userID;
    json['txAction'] = txAction.toString().split('.').last;
    json['metadata'] = metadata;
    json['createdAt'] = createdAt;
    return json;
  }
}
