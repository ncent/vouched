import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/json_helper.dart';
import 'package:vouched/src/models/base.dart';

class Post extends BaseDocument {
  final String message;
  final String avatar;
  final String name;
  final List<String> tags;

  final String parentPostId;
  final String originatingPostId;
  // Store a list of userIds that can view this post
  List<String> visibility;
  // Store a map of userIds from visibility with metadata about the visibility
  UsersVisibilityMetadata userVisibilityMetadata;
  // Stores slides of the post
  List<Slide> slides;
  final bool private;
  final Map<String, dynamic> metadata;
  final String url;
  final String urlPreview;
  final String subject;

  Post(
      String id,
      String creator,
      this.message,
      this.avatar,
      this.name,
      this.tags,
      visibility,
      visibilityMetadata,
      this.url,
      this.urlPreview,
      this.subject,
      {this.parentPostId,
      this.slides,
      this.originatingPostId,
      this.private = false,
      this.metadata})
      : super(creator, id: id) {
    this.initVisibility(creator, createdAt);
  }

  Post.withoutId(
      String creator,
      this.message,
      this.avatar,
      this.name,
      this.tags,
      visibility,
      visibilityMetadata,
      this.url,
      this.urlPreview,
      this.subject,
      {this.parentPostId,
      this.slides,
      this.originatingPostId,
      this.private = false,
      this.metadata,
      Timestamp createdAt})
      : super(creator) {
    this.initVisibility(creator, createdAt);
  }

  Post cloneToShare(String creator) {
    final postMap = toJson();
    postMap.remove('id');
    postMap['parentPostId'] = id;
    postMap['creator'] = creator;
    postMap['createdAt'] = Timestamp.now();
    return Post.fromJson(postMap);
  }

  void initVisibility(String creator, Timestamp createdAt) {
    if (visibility == null) this.visibility = List<String>();
    if (!this.visibility.contains(creator)) this.visibility.add(creator);

    VisibilityMetadata visibilityMetadata =
        VisibilityMetadata(VisibilityMetadataState.CREATED, createdAt);

    this.userVisibilityMetadata =
        UsersVisibilityMetadata({creator: visibilityMetadata});
  }

  Post.fromJson(Map<String, dynamic> data, {String id})
      : this.visibility = JsonHelper.fromList(data["visibility"]),
        this.userVisibilityMetadata = UsersVisibilityMetadata.fromJson(data),
        this.message = data["message"],
        this.avatar = data["avatar"],
        this.tags = data["tags"] != null ? data["tags"].cast<String>() : [],
        this.name = data["name"],
        this.parentPostId = data["parentPostId"],
        this.originatingPostId = data["originatingPostId"],
        this.private = data["private"] != null ? data["private"] : false,
        this.metadata = data["metadata"],
        this.url = data["url"],
        this.urlPreview = data["urlPreview"],
        this.subject = data["subject"],
        slides = data["slides"] != null
            ? (data['slides'] as List)
                .map((slide) => Slide.fromJson(slide))
                .toList()
            : [],
        super.fromJson(data, id: id);

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    var additionalMap = {
      'url': url,
      'urlPreview': urlPreview,
      'message': message,
      'avatar': avatar,
      'name': name,
      'parentPostId': parentPostId,
      'originatingPostId': originatingPostId,
      'tags': tags,
      'visibility': visibility,
      'userVisibilityMetadata': userVisibilityMetadata?.toJson(),
      'private': private,
      'subject': subject,
      'metadata': metadata
    };
    additionalMap.removeWhere((_, value) => value == null);
    json.addAll(additionalMap);
    return json;
  }
}

class Slide {
  final String uid;
  final String message;
  final double fontSize;
  final String fontColor;
  final String bgColor;

  Slide({
    @required this.message,
    @required this.fontColor,
    @required this.bgColor,
    @required this.fontSize,
  }) : uid = UniqueKey().toString();

  Slide.fromJson(Map m)
      : this.uid = m['uid'] ?? '',
        this.fontColor = m['fontColor'] ?? "0xff000000",
        this.bgColor = m['bgColor'] ?? "0xffffffff",
        this.fontSize =
            m['fontSize'] != null ? (m['fontSize']).toDouble() : 26.0,
        this.message = m['message'] ?? '';

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['uid'] = uid;
    json['fontColor'] = fontColor;
    json['bgColor'] = bgColor;
    json['fontSize'] = fontSize;
    json['message'] = message;
    return json;
  }
}

enum VisibilityMetadataState {
  CREATED,
  SEEN,
  ARCHIVED,
  PINNED,
  PINNED_ARCHIVED,
  DELETED
}

extension VisibilityMetadataStateExtension on VisibilityMetadataState {
  static String _value(VisibilityMetadataState val) {
    switch (val) {
      case VisibilityMetadataState.CREATED:
        return "created";
      case VisibilityMetadataState.SEEN:
        return "seen";
      case VisibilityMetadataState.ARCHIVED:
        return "archived";
      case VisibilityMetadataState.PINNED:
        return "pinned";
      case VisibilityMetadataState.PINNED_ARCHIVED:
        return "pinned_archived";
      case VisibilityMetadataState.DELETED:
        return "deleted";
    }
    return "";
  }

  static VisibilityMetadataState _key(String val) {
    switch (val) {
      case "created":
        return VisibilityMetadataState.CREATED;
      case "seen":
        return VisibilityMetadataState.SEEN;
      case "archived":
        return VisibilityMetadataState.ARCHIVED;
      case "pinned":
        return VisibilityMetadataState.PINNED;
      case "pinned_archived":
        return VisibilityMetadataState.PINNED_ARCHIVED;
      case "deleted":
        return VisibilityMetadataState.DELETED;
    }
    return null;
  }

  String get value => _value(this);
}

class UsersVisibilityMetadata {
  final Map<String, VisibilityMetadata> userVisibilityMetadata;

  UsersVisibilityMetadata(this.userVisibilityMetadata);

  UsersVisibilityMetadata.fromJson(Map json)
      : this.userVisibilityMetadata = (json["userVisibilityMetadata"] as Map)
            ?.map((user, metadata) =>
                MapEntry(user, VisibilityMetadata.fromJson(metadata)));

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    userVisibilityMetadata?.forEach(
        (user, visibilityMetadata) => json[user] = visibilityMetadata.toJson());
    return json;
  }
}

class VisibilityMetadata {
  final VisibilityMetadataState state;
  final Timestamp createdAt;

  VisibilityMetadata(this.state, this.createdAt);

  VisibilityMetadata.fromJson(Map json)
      : this.state = VisibilityMetadataStateExtension._key(json["state"]),
        this.createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json["state"] = state.toString().split('.').last;
    json["createdAt"] = createdAt;
    return json;
  }
}
