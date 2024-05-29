import 'dart:convert';

import 'package:get/get.dart';
import 'package:humanchat_frontend/core/api.dart';
import 'package:humanchat_frontend/dtos/response/channel/get_channels.dart';
import 'package:humanchat_frontend/dtos/response/message/get_message.dart';
import 'package:humanchat_frontend/dtos/send/channel/edit_channel_dto.dart';
import 'package:humanchat_frontend/entities/channel_entity.dart';
import 'package:humanchat_frontend/entities/message_entity.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:humanchat_frontend/service/ws_service.dart';
import 'package:humanchat_frontend/utils/extract_response.dart';
import 'package:humanchat_frontend/utils/response_error.dart';
import 'package:humanchat_frontend/dtos/response/channel/get_channel_info.dart';



class _ChatConnect extends GetConnect {
  final _cacheService = Get.find<CacheService>();
  get _header => {
    "Authorization": "Bearer ${_cacheService.token}"
  };
  Future<List<Channel>> getChannels() async {
    final res = await get(
      ChatEndpoint.getChannels.value,
      headers: _header,
    );
    throwOnResponseError(res);

    final List data = extractData(res)["channels"];
    return data.map((d) {
      if (d.isEmpty) {
        return Channel(channelId: BigInt.from(0), name: '', members: []);
      }
      if (d['members'] == null) {
        d['members'] = [];
      }
      return Channel.fromMap(d);
    }).toList();
  }
  Future<Channel> createChannel({
    required String name,
    required List<BigInt> members
  }) async {
    final res = await post(ChatEndpoint.createChannel.value, {
      "name": name,
      "members": members
    }, headers:  _header
  );
    throwOnResponseError(res);
    return Channel.fromJson(extractData(res));
  }
  Future<ChannelInfoDto> channelInfo({required BigInt channelId}) async {
    final res = await get(ChatEndpoint.channelInfo(channelId: channelId).value, headers: _header);
    throwOnResponseError(res);
    return ChannelInfoDto.fromJson(extractData(res));
  }
  Future<IChanMeta> editChannel({required BigInt channelId, required EditChannelDto param}) async {
    final res = await patch(ChatEndpoint.editChannel(channelId: channelId).value, param.toJson(), headers: _header);
    throwOnResponseError(res);
    return IChanMeta.fromJson(extractData(res));
  }
  Future<void> deleteChannel({required BigInt channelId}) async {
    final res = await delete(ChatEndpoint.deleteChannel(channelId: channelId).value,headers: _header);
    throwOnResponseError(res);
  }
  Future<void> joinChannelByInvite({required String invite}) async {
    final res = await post(ChatEndpoint.joinChannelByInvite(inviteCode: invite).value, null, headers: _header);
    throwOnResponseError(res);
  }
  Future<String> createInvite({required BigInt channelId}) async {
    final res = await post(ChatEndpoint.createInvite(channelId: channelId).value, null, headers:  _header);
    throwOnResponseError(res);
    return extractData(res)["inviteCode"];
  }
  Future<void> leaveChannel({required BigInt channelId}) async {
    final res = await delete(ChatEndpoint.leaveChannel(channelId: channelId).value, headers:  _header);
    throwOnResponseError(res);
    return res.body;
  }
  Future<void> sendMessage({required BigInt channelId, required String content}) async {
    final res = await post(ChatEndpoint.sendMessage(channelId: channelId).value, { "content": content}, headers:  _header);
    throwOnResponseError(res);
    // return Message.fromJson(extractData(res));
  }
  Future<Message> editMessage({required BigInt channelId, required BigInt messageId, required String content}) async {
    final res = await post(ChatEndpoint.editMessage(channelId: channelId, messageId: messageId).value, { "content": content }, headers:  _header);
    throwOnResponseError(res);
    return Message.fromJson(extractData(res));
  }
  Future<void> deleteMessage({ required BigInt channelId, required BigInt messageId}) async {
    final res = await delete(ChatEndpoint.deleteMessage(channelId: channelId, messageId: messageId).value, headers:  _header);
    throwOnResponseError(res);
  }
}

class ChatController extends GetxController {
  final _chatConnect = Get.put(_ChatConnect());
  final _cacheService = Get.find<CacheService>();
  final _websocketService = Get.find<WebSocketService>();

  @override
  void onInit() {
    super.onInit();
    // Get.put<WebSocketService>(WebSocketService(), permanent: true);
    registerEvents();
  }
  onMessage(Map<String, dynamic> data) {
    try {
      var processed = GetMessageDto.fromJson(data);
      _cacheService.handleMessage(dto: processed);
      printInfo(info: '[Message] $data');
    }
    catch (e) {
      printError(info: '[Message] Error: $e');
      rethrow;
    }
  }
  registerEvents() {
    _websocketService.addEventHandle({ WebSocketEvent.MESSAGE: onMessage });
  }
  Future<List<Channel>> getChannels() async {
    try {
      final channels = await _chatConnect.getChannels();
      await _cacheService.channelsBox.putAll({
        for (var c in channels)
          c.channelId.toString() : c
      });
      return channels;
    } catch (e) {
      rethrow;
      // return _cacheService.channels.values.toList();
    }
  }
  Future<Channel> createChannel({
    required String name,
    required List<BigInt> members
  }) async {
    try {
      final channel = await _chatConnect.createChannel(name: name, members: members);
      await _cacheService.channelsBox.put(channel.channelId.toString(), channel);
      return channel;
    } catch (e) {
      rethrow;
    }
  }
  Future<ChannelInfoDto> channelInfo({required BigInt channelId}) async {
    try {
      final channel = await _chatConnect.channelInfo(channelId: channelId);
      var existing = _cacheService.channelsBox.get(channelId.toString());
      await _cacheService.channelsBox.put(
        channel.id.toString(),
        Channel(
          channelId: channel.id,
          name: channel.name,
          members: channel.members,
        )
      );
      return channel;
    } catch (e) {
      rethrow;
    }
  }
  Future<IChanMeta> editChannel({required BigInt channelId, required EditChannelDto dto}) async {
    try {
      final channel = await _chatConnect.editChannel(channelId: channelId, param: dto);
      var cachedChannel = _cacheService.channelsBox.get(channel.id.toString());
      await _cacheService.channelsBox.put(
        channel.id.toString(),
        Channel(
          channelId: channel.id,
          name: channel.name,
          members: cachedChannel!.members,
        )
      );
      return channel;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteChannel({required BigInt channelId}) async {
    try {
      await _chatConnect.deleteChannel(channelId: channelId);
      await _cacheService.channelsBox.delete(channelId.toString());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> joinChannelByInvite({required String invite}) async {
    try {
      await _chatConnect.joinChannelByInvite(invite: invite);
    } catch (e) {
      rethrow;
    }
  }
  Future<String> createInvite({required BigInt channelId}) async {
    try {
      final inviteCode = await _chatConnect.createInvite(channelId: channelId);
      return inviteCode;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> leaveChannel({required BigInt channelId}) async {
    try {
      await _chatConnect.leaveChannel(channelId: channelId);
      await _cacheService.channelsBox.delete(channelId.toString());
    } catch (e) {
      rethrow;
    }
  }
  Future<void> sendMessage({required BigInt channelId, required String content}) async {
    try {
      await _chatConnect.sendMessage(channelId: channelId, content: content);
      // final messageBox = await _cacheService.openMessagesBoxByChannelId(channelId: channelId.toString());
      // await messageBox.put(message.messageId.toString(), <String, Message>{ message.messageId.toString() : message });
      // return message;
    } catch (e) {
      rethrow;
    }
  }
  Future<Message> editMessage({required BigInt channelId, required BigInt messageId, required String content}) async {
    try {
      final message = await _chatConnect.editMessage(channelId: channelId, messageId: messageId, content: content);
      final messageBox = await _cacheService.openMessagesBoxByChannelId(channelId: channelId.toString());
      await messageBox.put(messageId.toString(), <String, Message>{ message.messageId.toString() : message });
      return message;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteMessage({ required BigInt channelId, required BigInt messageId}) async {
    try {
      await _chatConnect.deleteMessage(channelId: channelId, messageId: messageId);
      final messageBox = await _cacheService.openMessagesBoxByChannelId(channelId: channelId.toString());
      await messageBox.delete(messageId.toString());
    } catch (e) {
      rethrow;
    }
  }
}