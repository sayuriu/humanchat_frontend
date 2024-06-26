import 'dart:collection';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:humanchat_frontend/dtos/response/message/get_message.dart';
import 'package:humanchat_frontend/entities/channel_entity.dart';
import 'package:humanchat_frontend/entities/message_entity.dart';
import 'package:humanchat_frontend/entities/user_entity.dart';

class CacheService extends GetxService {
  /// store users
  late final Box<User> usersBox;
  /// store channels
  late final Box<Channel> channelsBox;
  late final Box<String> _authBox;

  /// store messages box belong to a channel a.k.a key
  /// Box<K,V>: K: ChannelId.toString(), V: Map<MessageId.toString(), Message>
  // late final Box<Map<String, Message>> messagesBoxs;

  /// Box(Key: ChannelId.toString(), Value: MessageId.toString())
  late final Box<String> channelMessagesBox;

  final messageBoxInstances = <String, Box<Message>>{};

  /// get all users
  var users = <User>[].obs;
  /// get all channels
  var channels =  <Channel>[].obs;
  /// get all messages <ChannelId, Map<MessageId, Message>>
  var messages = <String, List<Message>>{}.obs;

  final latestMessages = RxMap<String, Message?>();

  Future<void> init() async {
    await Hive.initFlutter();
    Hive
      ..registerAdapter(UserAdapter())
      ..registerAdapter(ChannelAdapter())
      ..registerAdapter(MessageAdapter());
    _authBox = await Hive.openBox<String>('auth');
    usersBox = await Hive.openBox<User>('users');
    channelsBox = await Hive.openBox<Channel>('channels');
    channelMessagesBox = await Hive.openBox<String>('channelMessages');
    log('Cache initialized');

    // TODO listen to changes is too slow
    /**
     * login -> fetch Channels (if unable to fetch) -> use cache
     * Box<channelId, String $boxChannelMessagesName$>
     * user choose an channel -> get messages by open the box with corresponding channelId
     *
     * take an amount of messages/users/channels if they are too many -> separate reactive state against the box
     */
    // TODO check if needed to init observables
    initAndWatchObs();
  }

  initAndWatchObs() {
    users.assignAll(usersBox.values);
    usersBox.watch().listen((event) {
      users.assignAll(usersBox.values);
      log("In cache: User updated: $users");
    });
    channels.assignAll(channelsBox.values);
    channelsBox.watch().listen((event) {
      channels.assignAll(channelsBox.values);
      log("In cache: Channel updated: $channels");
    });
  }

  // Future<Box<Map<String, Message>>> openMessagesBoxByChannelId({required String channelId}) async {
  Future<Box> openMessagesBoxByChannelId({required String channelId}) async {
    messageBoxInstances[channelId] = await Hive.openBox<Message>('messages$channelId');
    messages.clear();
    messages[channelId] = messageBoxInstances[channelId]!.values.toList();
    // messages.assignAll(_messages);
    latestMessages[channelId] = messages[channelId]!.lastOrNull;
    messageBoxInstances[channelId]!.watch().listen((event) {
      messages[channelId] = messageBoxInstances[channelId]!.values.toList();
      latestMessages[channelId] = messages[channelId]!.lastOrNull;
      log("In cache: Message updated: $messages");
      log("In cache: Latest message updated: ${latestMessages[channelId]}");
    // messages.assignAll(_messages);
    });
    return messageBoxInstances[channelId]!;
  }

  Future<void> handleMessage({required GetMessageDto dto}) async {
    if (messageBoxInstances[dto.channelId.toString()] == null) {
      await openMessagesBoxByChannelId(channelId: dto.channelId.toString());
    }
    final id = dto.messageId.toString();
    messageBoxInstances[dto.channelId.toString()]!.put(
      id,
        Message(
          messageId: dto.messageId,
          author: dto.authorId,
          channel: dto.channelId,
          content: dto.content
        )
    );
    // TODO optimize messages only take a certain amount
  }

  String get token => _authBox.get('token') ?? '';
  set token (String value) => _authBox.put('token', value);
  deleteToken () => _authBox.delete('token');

  Future<void> close() async {
    await Hive.close();
  }
  String get accountId => _authBox.get('accountId') ?? '';
  set accountId (String value) => _authBox.put('accountId', value);
  deleteAccountId () => _authBox.delete('accountId');
}


