import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:vouched/src/models/base.dart';

enum UserRole { User, Admin, Contact }

extension UserRoleExtension on UserRole {
  static String _value(UserRole val) {
    switch (val) {
      case UserRole.Contact:
        return "Contact";
      case UserRole.User:
        return "User";
      case UserRole.Admin:
        return "Admin";
    }
    return "";
  }

  static UserRole _key(String val) {
    switch (val) {
      case "Contact":
        return UserRole.Contact;
      case "User":
        return UserRole.User;
      case "Admin":
        return UserRole.Admin;
    }
    return null;
  }

  String get value => _value(this);
}

class User extends BaseDocument {
  final String email;
  final String name;
  final String phone;
  final String headline;
  final String bio;
  final UserRole role;
  final String avatar;
  final bool isAnonymous;
  final bool firstTutorial;

  final Map<String, String> metadata;
  final List<TrustedContact> trustedContacts;
  final List<JobHistory> jobHistories;
  final List<Skill> skills;

  User({
    id,
    this.isAnonymous,
    creator,
    this.avatar,
    this.email,
    this.name,
    this.phone,
    this.headline,
    this.bio,
    this.role,
    this.firstTutorial,
    jobHistories,
    skills,
    trustedContacts,
    metadata,
  })  : this.trustedContacts =
            trustedContacts != null ? trustedContacts : List(),
        this.metadata = metadata != null ? metadata : Map(),
        this.jobHistories = jobHistories != null ? jobHistories : List(),
        this.skills = skills != null ? skills : List(),
        super(creator, id: id);

  User.fromJson(Map jsonData)
      : this.email = jsonData["email"],
        this.isAnonymous = jsonData["isAnonymous"],
        this.name = jsonData["name"],
        this.phone = jsonData["phone"],
        this.avatar = jsonData["avatar"],
        this.headline = jsonData["headline"],
        this.bio = jsonData["bio"],
        this.firstTutorial = jsonData["firstTutorial"] ?? false,
        this.role = UserRoleExtension._key(jsonData["role"]),
        metadata = jsonData["metadata"] != null
            ? json.decode(jsonData["metadata"])
            : Map<String, String>(),
        jobHistories = jsonData["jobHistories"] != null
            ? (jsonData['jobHistories'] as List)
                .map((jobHistoy) => JobHistory.fromJson(jobHistoy))
                .toList()
            : [],
        skills = jsonData["skills"] != null
            ? (jsonData['skills'] as List)
                .map((skill) => Skill.fromJson(skill))
                .toList()
            : [],
        trustedContacts = jsonData["trustedContacts"] != null
            ? (jsonData["trustedContacts"] as List)
                .map((trustedContact) => TrustedContact.fromMap(trustedContact))
                .toList()
            : [],
        super.fromJson(jsonData);

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    var additionalMap = {
      'email': email,
      'name': name,
      'phone': phone,
      'headline': headline,
      'bio': bio,
      'isAnonymous': isAnonymous,
      'firstTutorial': firstTutorial,
      'role': role.toString().split('.').last,
    };
    additionalMap.removeWhere((_, value) => value == null);
    json.addAll(additionalMap);
    return json;
  }

  User clone({
    id,
    isAnonymous,
    creator,
    avatar,
    email,
    name,
    phone,
    role,
    firstTutorial,
  }) {
    final u = toJson();
    u['isAnonymous'] = isAnonymous ?? this.isAnonymous;
    u['creator'] = creator ?? this.creator;
    u['avatar'] = avatar ?? this.avatar;
    u['email'] = email ?? this.email;
    u['name'] = name ?? this.name;
    u['phone'] = phone ?? this.phone;
    u['role'] = role ?? this.role.toString().split('.').last;
    u['firstTutorial'] = firstTutorial ?? this.firstTutorial;
    return User.fromJson(u);
  }

  String get getName {
    return name;
  }
}

class JobHistory {
  final String uid;
  final String jobTitle;
  final String jobWhere;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool isCurrent;

  JobHistory({
    @required this.jobTitle,
    @required this.jobWhere,
    @required this.startDate,
    this.endDate,
    this.isCurrent = false,
  }) : uid = UniqueKey().toString();

  JobHistory.fromJson(Map m)
      : this.uid = m['uid'] ?? '',
        this.jobTitle = m['jobTitle'] ?? '',
        this.jobWhere = m['jobWhere'] ?? '',
        this.startDate = m['startDate'] ?? Timestamp.now(),
        this.endDate = m['endDate'] ?? Timestamp.now(),
        this.isCurrent = m['isCurrent'] ?? false;

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['uid'] = uid;
    json['jobTitle'] = jobTitle;
    json['jobWhere'] = jobWhere;
    json['startDate'] = startDate;
    json['endDate'] = endDate;
    json['isCurrent'] = isCurrent;
    return json;
  }
}

class Skill {
  final String uid;
  final String name;
  final double value;

  Skill({
    @required this.name,
    @required this.value,
  }) : uid = UniqueKey().toString();

  Skill.fromJson(Map m)
      : this.uid = m['uid'] ?? '',
        this.name = m['name'] ?? '',
        this.value = m['value'] != null ? (m['value']).toDouble() : 0.0;

  Map<String, dynamic> toJson() {
    final json = Map<String, dynamic>();
    json['uid'] = uid;
    json['name'] = name;
    json['value'] = value;
    return json;
  }
}

class TrustedContact extends Contact {
  bool isSuggested = false;

  TrustedContact({
    this.isSuggested,
  }) : super();

  TrustedContact.fromMap(Map m)
      : this.isSuggested = m["isSuggested"] ?? false,
        super.fromMap(m);

  @override
  Map toMap() {
    final m = super.toMap();
    m['isSuggested'] = isSuggested;
    return m;
  }
}
