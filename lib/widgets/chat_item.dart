
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatItem extends StatelessWidget {
  final String username;
  final String lastMessage;
  final String lastTime;
  final VoidCallback? onTap;
  const ChatItem({
    super.key,
    this.onTap,
    required this.username,
    required this.lastMessage,
    required this.lastTime,
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
        title: Text(username),
        leading: const CircleAvatar(child: Icon(Icons.person),),
        trailing: Text(lastTime),
        subtitle: Text(lastMessage),
        onTap: onTap,
      ),
    );
  }
}