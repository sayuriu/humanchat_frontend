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
  late final Box<dynamic> messagesBoxs;

  /// Box(Key: ChannelId.toString(), Value: MessageId.toString())
  late final Box<String> channelMessagesBox;

  // final messageBoxInstances = <String, Box<Map<String, Message>>>{};
  final messageBoxInstances = <String, dynamic>{};

  /// get all users
  var users = RxMap<String, User>();
  /// get all channels
  var channels = RxMap<String, Channel>();
  /// get all messages <ChannelId, Map<MessageId, Message>>
  var messages = RxMap<String, RxMap<String, Message>>();

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
    users.assignAll(Map.from(usersBox.toMap()));
    usersBox.watch().listen((event) {
      users.assignAll(Map.from(usersBox.toMap()) );
      log("In cache: User updated: $users");
    });
    channels.assignAll(Map<String, Channel>.from(channelsBox.toMap()));
    channelsBox.watch().listen((event) {
      channels.assignAll(Map.from(channelsBox.toMap()) );
      log("In cache: Channel updated: $channels");
    });
  }

  // Future<Box<Map<String, Message>>> openMessagesBoxByChannelId({required String channelId}) async {
  Future<Box> openMessagesBoxByChannelId({required String channelId}) async {
    // messageBoxInstances[channelId.toString()] = await Hive.openBox<Map<String, Message>>('messages$channelId');
    messageBoxInstances[channelId.toString()] = await Hive.openBox<dynamic>('messages$channelId');
    // Map<String, RxMap<String, Message>> _messages = messageBoxInstances[channelId.toString()]!.values.toList().map((e) => RxMap<String, Message>.from(e)).toList().asMap().map((key, value) => MapEntry(key.toString(), value));
    messages.clear();
    // messages.addAll(_messages);
    messages.addAll(messageBoxInstances[channelId.toString()]!);
    // messages.assignAll(_messages);
    latestMessages[channelId] = messages[channelId]?.entries.last.value;
    messageBoxInstances[channelId.toString()]!.watch().listen((event) {
      // messages.assignAll(Map.from(messageBoxInstances[channelId.toString()]!.toMap()) );
      messages.assignAll(messageBoxInstances[channelId.toString()]);
      log("In cache: Message updated: $messages");
    });
    return messageBoxInstances[channelId.toString()]!;
  }

  Future<void> handleMessage({required GetMessageDto dto}) async {
    if (messageBoxInstances[dto.channelId.toString()] == null) {
      await openMessagesBoxByChannelId(channelId: dto.channelId.toString());
    }
    final id = dto.messageId.toString();
    messageBoxInstances[dto.channelId.toString()]!.put(
      id,
      <String, Message>{
        id :
        Message(
          messageId: dto.messageId,
          author: dto.authorId,
          channel: dto.channelId,
          content: dto.content
        )
      }
    );
    // TODO optimize messages only take a certain amount
  }

  String get token => _authBox.get('token') ?? '';
  set token (String value) => _authBox.put('token', value);
  deleteToken () => _authBox.delete('token');

  Future<void> close() async {
    await Hive.close();
  }
}
