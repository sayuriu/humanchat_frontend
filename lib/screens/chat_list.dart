import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/widgets/chat_item.dart';
import 'package:humanchat_frontend/widgets/menu_drawer.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      drawer: const MenuDrawer(),
      body: Obx(() => ListView(
            children: [],
          )),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add),),
    );
  }
}
