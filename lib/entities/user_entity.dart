import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'user_entity.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final BigInt userId;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String? displayName;
  @HiveField(4)
  final String bio;
  User({
    required this.userId,
    required this.email,
    required this.username,
    required this.bio,
    this.displayName,
  });

  User copyWith({
    BigInt? userId,
    String? email,
    String? username,
    String? displayName,
    String? bio,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'username': username,
      'displayName': displayName,
      'bio': bio,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] as BigInt,
      email: map['email'] as String,
      username: map['username'] as String,
      displayName: map['displayName'] as String,
      bio: map['bio'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(userId: $userId, email: $email, username: $username, displayName: $displayName, bio: $bio)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.email == email &&
        other.username == username &&
        other.displayName == displayName &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        username.hashCode ^
        displayName.hashCode ^
        bio.hashCode;
  }
}
