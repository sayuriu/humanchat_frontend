
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:humanchat_frontend/utils/snowflake.dart';

class ChatItemInfo {
  final BigInt channelId;
  final String channelName;
  final String lastMessage;
  final DateTime? lastMessageTimeStamp;
  const ChatItemInfo({
    required this.channelId,
    required this.channelName,
    required this.lastMessage,
    required this.lastMessageTimeStamp,
  });
}

class ChatItem extends StatelessWidget {
  final ChatItemInfo info;
  final VoidCallback? onTap;
  const ChatItem({
    super.key,
    this.onTap,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: super.key,
      startActionPane: const ActionPane(motion: ScrollMotion(), children: []),
      endActionPane: const ActionPane(motion: ScrollMotion(), children: [
        // Archive(chatName: chatInfo.name),
        // ChatDelete(chatName: chatInfo.name),
      ]),
      child: ListTile(
        title: Text(info.channelName),
        leading: const CircleAvatar(child: Icon(Icons.person),),
        trailing: Text(info.lastMessageTimeStamp?.toRelativeTimeString() ?? "N/A"),
        subtitle: Text(info.lastMessage),
        onTap: onTap,
      ),
    );
  }
}