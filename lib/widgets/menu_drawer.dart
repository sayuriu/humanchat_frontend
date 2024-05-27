
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  // CircularAvatarButton(
                  //   imagePath: '',
                  //   // TODO: AppRoutes.userProfile
                  //   onPressed: () => Get.toNamed(''),
                  // ),
                  const Gap(16),
                  const Text('Username'),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () => {},
                    icon: const Icon(Icons.settings),
                  )
                ],
              ),
            ),
            const ListTile(
              title: Text('Chats'),
            ),
            const Divider(),
            // ListTile(
              // title: Text(Languages.chatArchived),
            // ),
            const Divider(),
            // ListTile(
              // title: Text(Languages.chatHided),
            // ),
            const Divider(),
            TextButton(
              onPressed: () {},
              child: const Text('Logout'),
            ),
          ],
        ),
      );
  }
}