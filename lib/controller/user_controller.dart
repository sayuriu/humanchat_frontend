import 'dart:developer';

import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/core/api.dart';
import 'package:humanchat_frontend/dtos/response/message/get_message.dart';
import 'package:humanchat_frontend/dtos/response/user/get_user.dart';
import 'package:humanchat_frontend/dtos/send/user/update_user.dart';
import 'package:humanchat_frontend/entities/user_entity.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:humanchat_frontend/utils/extract_response.dart';
import 'package:humanchat_frontend/utils/response_error.dart';

class _UserConnect extends GetConnect {
  final _cacheServer = Get.find<CacheService>();
  get _headers => {
        'Authorization': 'Bearer ${_cacheServer.token}',
      };

  Future<GetUserResponseDto> update(UpdateUserDto dto) async {
    final res =
        await patch(UserEndpoint.update.value, dto.toJson(), headers: _headers);
    throwOnResponseError(res);
    return extractData(res)['data'];
  }

  Future<void> deleteUser() async {
    final res = await delete(UserEndpoint.delete.value, headers: _headers);
    throwOnResponseError(res);
  }

  Future<dynamic> info() async {
    final res = await get(UserEndpoint.info.value, headers: _headers);
    throwOnResponseError(res);
    return extractData(res)['user'];
  }

  /// get list of requests friend
  Future<List<BigInt>> requests() async {
    final res = await get(UserEndpoint.requests.value, headers: _headers);
    throwOnResponseError(res);
    return extractData(res)['data'];
  }

  Future<void> sendRequest() async {
    final res =
        await post(UserEndpoint.sendRequest.value, null, headers: _headers);
    throwOnResponseError(res);
  }

  Future<List<String>> getOutgoingRequests() async {
    final res =
        await get(UserEndpoint.getOutgoingRequests.value, headers: _headers);
    throwOnResponseError(res);
    return extractData(res)['requests'] as List<String>;
  }

  Future<List<String>> getIncomingRequests() async {
    final res =
        await get(UserEndpoint.getIncomingRequests.value, headers: _headers);
    throwOnResponseError(res);
    return extractData(res)['requests'] as List<String>;
  }

  Future<void> acceptRequest({required BigInt userId}) async {
    final res = await put(UserEndpoint.acceptRequest(userId: userId).value, null,
        headers: _headers);
    throwOnResponseError(res);
  }

  Future<void> rejectRequest({required BigInt userId}) async {
    final res = await delete(UserEndpoint.rejectRequest(userId: userId).value,
        headers: _headers);
    throwOnResponseError(res);
  }
}

class UserController extends GetxController {
  final _userConnect = _UserConnect();
  final _cacheService = Get.find<CacheService>();

  @override
  void onInit() async {
    super.onInit();
    await info();
  }
  Future<GetUserResponseDto> updateUser(UpdateUserDto dto) async {
    try {
      final res = await _userConnect.update(dto);

      final findAccount = _cacheService.usersBox.get(_cacheService.accountId.toString())!;

      var updateAccount = User(
        userId: _cacheService.accountId.toInt()!,
        email: findAccount.email,
        username: findAccount.username,
        bio: findAccount.bio
      );

      await _cacheService.usersBox.put(_cacheService.accountId.toString(), updateAccount);

      return res;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteUser() async {
    try {
      final res = await _userConnect.deleteUser();
      // TODO: delete user from cache
      return res;
    } catch (e) {
      rethrow;
    }
  }
  Future<User> info() async {
    try {
      var data = await _userConnect.info();
      _cacheService.accountId = data['userId'].toString();
      var user = User(
        userId: data['userId'],
        email: data['email'],
        username: data['username'],
        bio: ''
      );
      await _cacheService.usersBox.put(data['userId'].toString(), user);
      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  Future<List<BigInt>> requests() async {
    try {
      return await _userConnect.requests();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> sendRequest() async {
    try {
      return await _userConnect.sendRequest();
    } catch (e) {
      rethrow;
    }
  }
  Future<List<String>> getOutgoingRequests() async {
    try {
      return await _userConnect.getOutgoingRequests();
    } catch (e) {
      rethrow;
    }
  }
  Future<List<String>> getIncomingRequests() async {
    try {
      return await _userConnect.getIncomingRequests();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> acceptRequest({required BigInt userId}) async {
    try {
      await _userConnect.acceptRequest(userId: userId);
    } catch (e) {
      rethrow;
    }
  }
  Future<void> rejectRequest({required BigInt userId}) async {
    try {
      await _userConnect.rejectRequest(userId: userId);
    } catch (e) {
      rethrow;
    }
  }
}
