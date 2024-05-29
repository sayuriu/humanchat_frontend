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
  static final signUp = Pair(HttpMethods.POST, '${Endpoint.apiEndpoint}/signup');
  static final checkEmail = Pair(HttpMethods.POST, '${Endpoint.apiEndpoint}/check-email');
}

class UserEndpoint {
  static final _baseUrl = '${Endpoint.apiEndpoint}/@me';
  static final update = Pair(HttpMethods.PATCH, _baseUrl);
  static final delete = Pair(HttpMethods.DELETE, _baseUrl);
  static final info = Pair(HttpMethods.GET, _baseUrl);
  static final requests = Pair(HttpMethods.GET, '$_baseUrl/requests');
  static final sendRequest = Pair(HttpMethods.POST, '${UserEndpoint.requests}/new');
  static Pair<HttpMethods, String> acceptRequest({required BigInt userId}) =>
      Pair(HttpMethods.PUT, '${UserEndpoint.requests}/$userId/accept');
  static Pair<HttpMethods, String> rejectRequest({required BigInt userId}) =>
      Pair(HttpMethods.DELETE, '${UserEndpoint.requests}/$userId/reject');
  static final getOutgoingRequests = Pair(HttpMethods.GET, '${UserEndpoint.requests}/outgoing');
  static final getIncomingRequests = Pair(HttpMethods.GET, '${UserEndpoint.requests}/incoming');
}

class ChatEndpoint {
  static final _baseUrl = '${Endpoint.apiEndpoint}/channels';
  static final getChannels = Pair(HttpMethods.GET, _baseUrl);
  static final createChannel = Pair(HttpMethods.POST, '$_baseUrl/create');
  static Pair<HttpMethods, String> channelInfo({required BigInt channelId}) => Pair(HttpMethods.GET, '$_baseUrl/$channelId');
  static Pair<HttpMethods, String> editChannel({required BigInt channelId}) =>
      Pair(HttpMethods.PATCH, '$_baseUrl/$channelId/edit');
  static deleteChannel({required BigInt channelId}) =>
      Pair(HttpMethods.DELETE, '$_baseUrl/$channelId/delete');
  static joinChannelByInvite({required String inviteCode}) =>
      Pair(HttpMethods.POST, '$_baseUrl/join/$inviteCode');
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
  static Pair<HttpMethods, String> addMembers({required BigInt channelId}) => Pair(HttpMethods.POST, '$_baseUrl/$channelId/members');
  static Pair<HttpMethods, String> removeMembers({required BigInt channelId}) => Pair(HttpMethods.DELETE, '$_baseUrl/$channelId/members');
}

class WebSocketEvent {
  static const TOKEN_CHALLENGE_REQUEST = 'tokenChallenge';
  static const TOKEN_CHALLENGE_TIMEOUT = 'tokenChallengeTimeout';
  static const TOKEN_CHALLENGE_ACCEPTED = 'tokenAccepted';
  static const TOKEN_CHALLENGE_REJECTED = 'tokenRejected';
  static const TOKEN_CHALLENGE_RESPONSE = 'tokenChallengeResponse';
  static const MESSAGE = 'message';
  // static const JOIN = 'join';
  // static const LEAVE = 'leave';
  // static const JOIN_REQUEST = 'join-request';
  // static const JOIN_REQUEST_REJECT = 'join-request-reject';
  // static const JOIN_REQUEST_ACCEPT = 'join-request-accept';
  // static const CHANNEL_INFO = 'channel-info';
  // static const CHANNEL_EDIT = 'channel-edit';
}

