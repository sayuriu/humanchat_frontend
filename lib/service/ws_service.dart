
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanchat_frontend/core/api.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService extends GetxService {
  final _cacheService = Get.find<CacheService>();
  final _websocketUrl = Uri.parse(Endpoint.wsEndpoint);
  late final WebSocketChannel channel;
  final _eventHandlers = <String, Function>{}.obs;
  final connected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connenct();
  }

  void _connenct() async {
    channel =  WebSocketChannel.connect(_websocketUrl);

    channel.stream.listen((data) {
      _handleData(jsonDecode(data) as Map<String, dynamic>);
    }, onError: (error) {
      log('WebSocket Error: $error');
    }, onDone: () {
      log('WebSocket closed');
    });
  }

  void _handleData(Map<String, dynamic> data) {
    var eventName = data['event'];
    switch (eventName) {
      case WebSocketEvent.TOKEN_CHALLENGE_ACCEPTED:
        onTokenChallengeSuccess();
        break;
      case WebSocketEvent.TOKEN_CHALLENGE_REJECTED:
      case WebSocketEvent.TOKEN_CHALLENGE_TIMEOUT:
        onTokenChallengeFailed();
        break;
      case WebSocketEvent.TOKEN_CHALLENGE_REQUEST:
        tokenChallengeResponse();
        break;
      default:
        if (!_eventHandlers.containsKey(eventName)) {
          log('Unknown event: ${data['event']}');
          return;
        }
      log('event: $eventName, data: ${data['data'].toString()}');
      _eventHandlers[eventName]!(data['data']);
    }
  }

  void tokenChallengeResponse() {
    channel.sink.add(jsonEncode(
      {
        'event': WebSocketEvent.TOKEN_CHALLENGE_RESPONSE,
        'data': {
          'token': 'Bearer ${_cacheService.token}'
        }
      }
    ));
  }

  void onTokenChallengeSuccess() {
    connected.value = true;
  }

  void onTokenChallengeFailed() {
    connected.value = false;
  }

  void sendEvent(String event, Map<String, dynamic> data) {
    channel.sink.add(jsonEncode({
      'event': event,
      'data': data
    }));
  }

  void addEventHandle(Map<String, Function> eventHandlers) {
    for (var event in eventHandlers.keys) {
      if (_eventHandlers.containsKey(event)) {
        continue;
      }
      _eventHandlers[event] = eventHandlers[event]!;
      log('Registered handler for event "$event"');
    }
  }

  Future<void> ready() async {
    await channel.ready;
  }

  Future<void> close() async {
    await channel.sink.close();
  }
}