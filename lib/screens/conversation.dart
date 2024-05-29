import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/controller/chat_controller.dart';
import 'package:humanchat_frontend/entities/message_entity.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:humanchat_frontend/utils/snowflake.dart';
import 'package:humanchat_frontend/widgets/form_input_field.dart';
import 'package:humanchat_frontend/widgets/message_item.dart';

class ConversationScreenState extends GetxController {
  final chatController = Get.put(ChatController());
  var inputController = TextEditingController();
  var channelId = BigInt.zero;


  send() async {
    if (inputController.text.isEmpty) {
      return;
    }
    await chatController.sendMessage(channelId: channelId, content: inputController.text);
  }
}


class ConversationScreen extends StatelessWidget {
  final _state = Get.put(ConversationScreenState());
  final cacheService = Get.find<CacheService>();
  final authController = Get.put(AuthController());

  ConversationScreen({super.key, channelId}) {
    _state.channelId = channelId;
  }

  onSend() {
    _state.send();
    _state.inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            // TODO: set audio call route
            onPressed: () => Get.to(() => {}),
            icon: const Icon(Icons.call_rounded),
          ),
          const Gap(6),
          IconButton(
            // TODO: set video call route
            onPressed: () => Get.toNamed(''),
            icon: const Icon(Icons.video_call_rounded),
          ),
          const Gap(6),
          IconButton(
            // onPressed: () => Get.to(const ChatSettingsPage()),
            onPressed: () => {},
            icon: const Icon(Icons.info_outline_rounded),
          ),
          const Gap(6)
        ],
        title: const Text('Chat Page'),
      ),
      body: Column(
        children: [
          Obx(() => Expanded(
              child: ListView(
                reverse: true,
                children:
                  (cacheService.messages[_state.channelId.toString()] ?? [])
                  .reversed
                  .map((e) => MessageItem(
                      message: e.content,
                      createAt: e.messageId.timestamp.toRelativeTimeString(),
                      messageState: MessageState.seen,
                      // username: cacheService.users.firstWhere((c) => c.userId.toString() == e.author.toString()).username,
                      username: e.author.toString(),
                      messagePosition: cacheService.accountId == e.author.toString() ? MessagePosition.right : MessagePosition.left,
                    ))
                .toList(),
            )
          )),
          Row(
            children: [
              Expanded(child: TextField(controller: _state.inputController, decoration: const InputDecoration(hintText: 'Enter message...', border: OutlineInputBorder()))),
              IconButton(
                onPressed: onSend,
                icon: const Icon(Icons.send_rounded),
              )
            ]
          )
        ],
      ),
    );
  }
}