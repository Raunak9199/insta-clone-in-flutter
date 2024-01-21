import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? userName;
  final String? name;
  final String? about;
  final String? email;
  final String? profileUrl;
  final List? connections;
  final List? friends;
  final num? totalConnections;
  final num? totalFriends;
  final num? totalPosts;
  final String? password;
  final String? otherId;
  final File? imgFile;

  const UserEntity({
    this.uid,
    this.userName,
    this.name,
    this.about,
    this.email,
    this.profileUrl,
    this.connections,
    this.friends,
    this.totalConnections,
    this.totalFriends,
    this.password,
    this.otherId,
    this.totalPosts,
    this.imgFile,
  });

  @override
  List<Object?> get props => [
        uid,
        userName,
        name,
        about,
        email,
        profileUrl,
        connections,
        friends,
        totalConnections,
        totalFriends,
        totalPosts,
        password,
        otherId,
        imgFile,
      ];
}
