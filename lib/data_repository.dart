import 'package:amplify_flutter/amplify_flutter.dart';
import 'models/User.dart';
import 'package:flutter/material.dart';

class DataRepository {
  final firstNamesController = TextEditingController();
  String _profilePic = "";

  Future<User?> getUserById(String userId) async {
    try {
      final users = await Amplify.DataStore.query(
        User.classType,
        where: User.ID.eq(userId),
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      throw e;
    }
  }
  //new code
  Future<User>getUserProfile(String userId) async {
    List<User> user = await Amplify.DataStore.query(
        User.classType, where: User.ID.eq(userId));
    print(user[0]);

    firstNamesController.text = user[0].username;
    _profilePic = user[0].avatarKey!;


    return user[0];
  }

  Future<User> createUser({
    String? userId,
    String? username,
    String? email,
  }) async {
    final newUser = User(id: userId, username: username!, email: email);
    try {
      await Amplify.DataStore.save(newUser);
      return newUser;
    } catch (e) {
      throw e;
    }
  }

  Future<User> updateUser(User updatedUser) async {
    try {
      await Amplify.DataStore.save(updatedUser);
      return updatedUser;
    } catch (e) {
      throw e;
    }
  }
}