// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:humanchat_frontend/utils/pair.dart';

enum HttpMethods {
  GET,
  POST,
  PUT,
  PATCH,
  DELETE,
}

class Endpoint {
  static final String apiEndpoint = dotenv.get('API_URL');
  static final String wsEndpoint = dotenv.get('WS_URL');
}

class AuthEndpoint {
  static final login = Pair(HttpMethods.POST, '${Endpoint.apiEndpoint}/login');
  static final logout = Pair(HttpMethods.POST, '${Endpoint.apiEndpoint}/logout');
  static final signUp = Pair(HttpMethods.POST, '${Endpoint.apiEndpoint}/register');
}

class UserEndpoint {
  static final _baseUrl = '${Endpoint.apiEndpoint}/@me';
  static final update = Pair(HttpMethods.PATCH, _baseUrl);
  static final delete = Pair(HttpMethods.DELETE, _baseUrl);
  static final info = Pair(HttpMethods.GET, _baseUrl);
  static final requests = Pair(HttpMethods.GET, '$_baseUrl/requests');
  static final sendRequest = Pair(HttpMethods.POST, '${UserEndpoint.requests}/new');
  static acceptRequest({required BigInt userId}) =>
      Pair(HttpMethods.PUT, '${UserEndpoint.requests}/$userId/accept');
  static rejectRequest({required BigInt userId}) =>
      Pair(HttpMethods.DELETE, '${UserEndpoint.requests}/$userId/reject');
  static final getFriendsRequests = Pair(HttpMethods.GET, '${UserEndpoint.requests}/outgoing');
  static final getIncomingRequests = Pair(HttpMethods.GET, '${UserEndpoint.requests}/incoming');
}

class ChatEndpoint {
  static final _baseUrl = '${Endpoint.apiEndpoint}/channels';
  static final getChannels = Pair(HttpMethods.GET, _baseUrl);
  static final createChannel = Pair(HttpMethods.POST, '$_baseUrl/create');
  static channelInfo({required BigInt channelId}) => Pair(HttpMethods.GET, '$_baseUrl/$channelId');
  static editChannel({required BigInt channelId}) =>
      Pair(HttpMethods.PATCH, '$_baseUrl/$channelId/edit');
  static deleteChannel({required BigInt channelId}) =>
      Pair(HttpMethods.DELETE, '$_baseUrl/$channelId/delete');
  static joinChannelByInvite({required String invite}) =>
      Pair(HttpMethods.POST, '$_baseUrl/join/$invite');
  static createInvite({required BigInt channelId}) =>
      Pair(HttpMethods.POST, '$_baseUrl/$channelId/invite');
  static leaveChannel({required BigInt channelId}) =>
      Pair(HttpMethods.DELETE, '$_baseUrl/$channelId/leave');
  static sendMessage({required BigInt channelId}) =>
      Pair(HttpMethods.POST, '$_baseUrl/$channelId/messages');
  static editMessage({required BigInt channelId, required BigInt messageId}) =>
      Pair(HttpMethods.PATCH, '$_baseUrl/$channelId/messages/$messageId');
  static deleteMessage({required BigInt channelId, required BigInt messageId}) =>
      Pair(HttpMethods.DELETE, '$_baseUrl/$channelId/messages/$messageId');
}

class WebSocketEvent {
  static const MESSAGE = 'message';
  static const JOIN = 'join';
  static const LEAVE = 'leave';
  static const JOIN_REQUEST = 'join-request';
  static const JOIN_REQUEST_REJECT = 'join-request-reject';
  static const JOIN_REQUEST_ACCEPT = 'join-request-accept';
  static const CHANNEL_INFO = 'channel-info';
  static const CHANNEL_EDIT = 'channel-edit';
}

