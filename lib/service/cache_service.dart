import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:humanchat_frontend/entities/channel_entity.dart';
import 'package:humanchat_frontend/entities/message_entity.dart';
import 'package:humanchat_frontend/entities/user_entity.dart';

class CacheService extends GetxService {
  late final Rx<Box<User>> usersBox;
  late final Rx<Box<Channel>> channelsBox;
  late final Rx<Box<Message>> messagesBox;
  late final Rx<Box<String>> _authBox;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    log('Cache initialized');
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserAdapter())
      ..registerAdapter(ChannelAdapter())
      ..registerAdapter(MessageAdapter());

    usersBox = (await Hive.openBox<User>('users')).obs;
    channelsBox = (await Hive.openBox<Channel>('channels')).obs;
    messagesBox = (await Hive.openBox<Message>('messages')).obs;
    _authBox = (await Hive.openBox<String>('auth')).obs;
  }

  Box<User> get users => usersBox.value;
  Box<Channel> get channels => channelsBox.value;
  Box<Message> get messages => messagesBox.value;
  String get token => _authBox.value.get('token')!;
  set token (String value) => _authBox.value.put('token', value);
  deleteToken () => _authBox.value.delete('token');


  Future<void> close() async {
    await Hive.close();
  }
}
