import 'package:get/get.dart';
import 'package:humanchat_frontend/core/api.dart';

class _UserConnect extends GetConnect {
  Future<void> update() async {

  }
  // @override
  // Future<Response<String>> delete() async {
  //   throw UnimplementedError();
  // }
  Future<String> info() async {
    throw UnimplementedError();
  }
  Future<String> requests() async {
    throw UnimplementedError();
  }
  Future<void> sendRequest({required BigInt userId}) async {
    try{
      await post(UserEndpoint.sendRequest.value, null, headers: {});
    }catch(e) {
    }
  }
  Future<void> acceptRequest({required BigInt userId}) async {
    try{
      await UserEndpoint.acceptRequest(userId: userId);
    }catch(e) {
    }
  }

  Future<void> rejectRequest({required BigInt userId}) async {
    try{
      await UserEndpoint.rejectRequest(userId: userId);
    }catch(e) {
    }
  }
  Future<String> getFriendsRequests() async {
    throw UnimplementedError();
  }
  Future<String> getIncomingRequests() async {
    throw UnimplementedError();
  }
}



class UserController extends GetxController {

}

