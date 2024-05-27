import 'package:get/get.dart';
import 'package:humanchat_frontend/core/api.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:humanchat_frontend/utils/throw_error.dart';

class _AuthConnect extends GetConnect {
  final cacheService = Get.put(CacheService());

  Future<bool> checkEmail({required String email}) async {
    final res = await post(AuthEndpoint.checkEmail.value, {
      'email': email
    });
    hasError(res);
    return res.body['exists'];
  }

  Future<String> login({required String email, required String password}) async {
    final res = await post(AuthEndpoint.login.value, {
      'email': email,
      'password': password
    });
    hasError(res);
    return res.body['accessToken'];
  }

  Future<String> signUp({required String email, required String username, required String password, String? displayName,}) async {
    final res = await post(AuthEndpoint.signUp.value, {
      'email': email,
      'username': username,
      'password': password,
      'displayName': displayName
    });
    hasError(res);
    return res.body['message'];
  }

  Future<String> logout() async {
    final res = await post(AuthEndpoint.logout.value, null, headers: {
      'Authorization': 'Bearer ${cacheService.token}'
    });
    return res.body['message'];
  }
}

class AuthController extends GetxController {
  final _authConnect = _AuthConnect();
  final _cacheService = Get.put(CacheService());

  Future<bool> checkEmail({required String email}) async {
    try {
      return await _authConnect.checkEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      _cacheService.token = await _authConnect.login(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp({required String email, required String username, required String password, String? displayName}) async {
    try {
      await _authConnect.signUp(email: email, username: username, password: password, displayName: displayName);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    _cacheService.deleteToken();
    _authConnect.logout();
  }
}