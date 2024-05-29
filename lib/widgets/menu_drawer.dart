import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/utils/go.dart';
import 'package:humanchat_frontend/screens/welcome.dart';
import 'package:humanchat_frontend/utils/pair.dart';
import 'package:humanchat_frontend/widgets/menu_drawer_item.dart';

// enum Page {
//   messages,
//   contacts,
//   settings,
// }
//
//
// class MenuDrawerState extends GetxController {
//   final active = Page.messages.obs;
//   void setActive(Page active) {
//     this.active.value = active;
//   }
// }

class MenuDrawer extends StatelessWidget {
  final active = 0.obs;
  MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            curve: Easing.emphasizedDecelerate,
            duration: Duration(milliseconds: 500),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  Gap(8),
                  Text('DisplayName', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('@username', style: TextStyle(fontSize: 13)),
                ]
              )
            )
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...[
                  Pair('Messages', Icons.message),
                  Pair('Contacts', Icons.people),
                  false,
                  Pair('Settings', Icons.settings),
                ].asMap().entries.mapMany((e) => [
                  e.value == false
                    ? const Divider()
                    : Obx(() => MenuDrawerItem(
                      label: (e.value as Pair<String, IconData>).key,
                      icon: (e.value as Pair<String, IconData>).value,
                      isActive: active.value == e.key,
                      onPressed: () {
                        active.value = e.key;
                      }
                    )),
                ]),
              ],
            ),
          ),
          MenuDrawerItem(
            label: 'Logout',
            icon: Icons.logout,
            onPressed: () {
              Get.put(AuthController()).logout();
              Go.offUntil(() => WelcomeScreen());
            },
            fgColor: Colors.red,
            fgHoverColor: Colors.white,
            bgHoverColor: Colors.red,
            isActive: false,
          )
        ]
      )
    );
  }
}
