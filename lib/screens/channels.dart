import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/chat_controller.dart';
import 'package:humanchat_frontend/controller/user_controller.dart';
import 'package:humanchat_frontend/screens/add_channel.dart';
import 'package:humanchat_frontend/screens/conversation.dart';
import 'package:humanchat_frontend/utils/go.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:humanchat_frontend/service/ws_service.dart';
import 'package:humanchat_frontend/utils/exceptions/response_exception.dart';
import 'package:humanchat_frontend/utils/response_error.dart';
import 'package:humanchat_frontend/utils/snowflake.dart';
import 'package:humanchat_frontend/widgets/chat_item.dart';
import 'package:humanchat_frontend/widgets/menu_drawer.dart';


class ChannelScreenState extends GetxController {
  final _cacheService = Get.find<CacheService>();
  final _websocketService = Get.find<WebSocketService>();
  final _chatController = Get.put(ChatController());
  final _userController = Get.put(UserController());

  // final chatItemInfos = RxList<ChatItemInfo>();
  final chatItemInfos = RxMap<String, ChatItemInfo>({});
  final loading = false.obs;

  @override
  void onInit() async{
    super.onInit();
    try {
      // ever(
      //   _cacheService.messages,
      //   (_) {
      //     for (var messageId in _cacheService.messages.keys) {
      //       final message = _cacheService.channelsBox.get(messageId.toString());
      //       if (message == null) {
      //         continue;
      //       }
      //       final channelId = message.channelId;
      //       final latestMessage = _cacheService.latestMessages[channelId.toString()];
      //       chatItemInfos[channelId] = ChatItemInfo(
      //         channelId: channelId.toInt()!,
      //         channelName: channelName,
      //         lastMessage: latestMessage?.content ?? "No messages",
      //         lastMessageTimeStamp: latestMessage?.messageId.timestamp
      //       );
      //     }
      //     log("Update triggered: $chatItemInfos");
      //   }
      // );
      everAll(
        [_cacheService.channels, _cacheService.messages, _cacheService.latestMessages],
        (_) {
          for (var channel in _cacheService.channels) {
            final latestMessage = _cacheService.latestMessages[channel.channelId.toString()];
            chatItemInfos[channel.channelId.toString()] = ChatItemInfo(
              channelId: channel.channelId,
              channelName: channel.name,
              lastMessage: latestMessage?.content ?? "No new messages",
              lastMessageTimeStamp: latestMessage?.messageId.timestamp
            );
          }
        }
      );
      // ! FETCH HERE
      await _chatController.getChannels();
      await _userController.info();

    } on ResponseException catch (e) {
      handleResponseError(e);
    } catch (e) {
      log(e.toString());
    }
    loading.value = false;
  }
}

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  final ChatController _chatController =  Get.put(ChatController());
  final CacheService _cacheService = Get.find<CacheService>();

  final ChannelScreenState _state = Get.put(ChannelScreenState());

  final SearchController _searchController = SearchController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SearchAnchor.bar(
          barElevation: WidgetStateProperty.all(0),
          barHintText: "Search channels...",
          searchController: _searchController,
          barBackgroundColor: WidgetStateProperty.all(Colors.transparent),
          barLeading: IconButton(
            tooltip: "Open navigation",
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(Icons.menu)
          ),
          barTrailing: [
            IconButton(
              onPressed: () {
                _state.loading.value = true;
                _state.onInit();
              },
              tooltip: "Refresh",
              icon: const Icon(Icons.refresh)
            )
          ],
          suggestionsBuilder: (context, builder) {
            var regex = RegExp(_searchController.text, caseSensitive: false, unicode: true);
            var filtered = _searchController.text.isEmpty
              ? []
              : _state.chatItemInfos.values
                  .where((element) => element.channelName.contains(regex))
                  .toList();
            return List.generate(
              filtered.length,
              (index) {
                final chatItemInfo = filtered[index];
                return ListTile(
                  title: ChatItem(
                    info: chatItemInfo,
                    onTap: () => Go.to(() => ConversationScreen(channelId: chatItemInfo.channelId))
                  )
                );
              }
            );
          }
        ),
      ),
      drawer: MenuDrawer(),
      body: /* _state.loading.value
        ? const Center(child: CircularProgressIndicator())
        : */ CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final chatItemInfo = _state.chatItemInfos.values.elementAt(index);
                  return ChatItem(
                    info: chatItemInfo,
                    onTap: () => Go.to(() => ConversationScreen(channelId: chatItemInfo.channelId))
                  );
                },
                childCount: _state.chatItemInfos.length
              )
            )
          ],
        ),
      floatingActionButton: FloatingActionButton(onPressed: () => Go.to(() => AddChatPage()), child: const Icon(Icons.add)),
    ));
  }
}
