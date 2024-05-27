import 'package:get/get.dart';
import 'package:humanchat_frontend/core/api.dart';
import 'package:humanchat_frontend/service/cache_service.dart';

class ChatParam {
  final String name;
  final List<BigInt> members;
  ChatParam({
    required this.name,
    required this.members
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "members": members
  };
}

class _ChatConnect extends GetConnect {
  final _cacheService = Get.put(CacheService());
  get _header => {
    "Authorization": "Bearer ${_cacheService.token}"
  };
  Future<String> getChannels() async {
    final res = await get(ChatEndpoint.getChannels.value, headers: _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> createChannel({
    required String name,
    required List<BigInt> members
  }) async {
    final res = await post(ChatEndpoint.createChannel.value, {
      "name": name,
      "members": members
    }, headers:  _header
  );
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> channelInfo({required BigInt channelId}) async {
    final res = await get(ChatEndpoint.channelInfo(channelId: channelId), headers: _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> editChannel({required BigInt channelId, required ChatParam param}) async {
    final res = await patch(ChatEndpoint.editChannel(channelId: channelId), param.toJson(), headers: _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> deleteChannel({required BigInt channelId}) async {
    final res = await delete(ChatEndpoint.deleteChannel(channelId: channelId),headers: _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> joinChannelByInvite({required String invite}) async {
    final res = await post(ChatEndpoint.joinChannelByInvite(invite: invite), null, headers: _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> createInvite({required BigInt channelId}) async {
    final res = await post(ChatEndpoint.createInvite(channelId: channelId), null, headers:  _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> leaveChannel({required BigInt channelId}) async {
    final res = await delete(ChatEndpoint.leaveChannel(channelId: channelId), headers:  _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> sendMessage({required BigInt channelId, required String content}) async {
    final res = await post(ChatEndpoint.sendMessage(channelId: channelId), {content:content}, headers:  _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> editMessage({required BigInt channelId, required BigInt messageId, required String content}) async {
    final res = await post(ChatEndpoint.editMessage(channelId: channelId, messageId: messageId), { content: content }, headers:  _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }
  Future<String> deleteMessage({ required BigInt channelId, required BigInt messageId}) async {
    final res = await delete(ChatEndpoint.deleteMessage(channelId: channelId, messageId: messageId), headers:  _header);
    if (res.hasError) {
      throw Exception(res.statusText);
    }
    return res.body;
  }

}

class ChatController extends GetxController {
  final _chatConnect = _ChatConnect();
  final _cacheService = Get.put(CacheService());

  Future<String> getChannels() => _chatConnect.getChannels();
  Future<String> createChannel({
    required String name,
    required List<BigInt> members
  }) => _chatConnect.createChannel(name: name, members: members);
  Future<String> channelInfo({required BigInt channelId}) => _chatConnect.channelInfo(channelId: channelId);
  Future<String> editChannel({required BigInt channelId, required ChatParam param}) => _chatConnect.editChannel(channelId: channelId, param: param);
  Future<String> deleteChannel({required BigInt channelId}) => _chatConnect.deleteChannel(channelId: channelId);
  Future<String> joinChannelByInvite({required String invite}) => _chatConnect.joinChannelByInvite(invite: invite);
  Future<String> createInvite({required BigInt channelId}) => _chatConnect.createInvite(channelId: channelId);
  Future<String> leaveChannel({required BigInt channelId}) => _chatConnect.leaveChannel(channelId: channelId);
  Future<String> sendMessage({required BigInt channelId, required String content}) => _chatConnect.sendMessage(channelId: channelId, content: content);
  Future<String> editMessage({required BigInt channelId, required BigInt messageId, required String content}) => _chatConnect.editMessage(channelId: channelId, messageId: messageId, content: content);
  Future<String> deleteMessage({ required BigInt channelId, required BigInt messageId}) => _chatConnect.deleteMessage(channelId: channelId, messageId: messageId);
}