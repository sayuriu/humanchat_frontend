import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/controller/auth_controller.dart';
import 'package:humanchat_frontend/core/app_routes.dart';
import 'package:humanchat_frontend/screens/channels.dart';
import 'package:humanchat_frontend/screens/unknown.dart';
import 'package:humanchat_frontend/screens/welcome.dart';
import 'package:humanchat_frontend/service/cache_service.dart';
import 'package:humanchat_frontend/service/ws_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Get.putAsync(() async {
    var cache = CacheService();
    await cache.init();
    return cache;
  }, permanent: true);
  runApp(const MyApp());
  Get.lazyPut(() => WebSocketService());
  // Get.put(() => AuthController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HumanChat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
      // home: ChannelScreen(),
      unknownRoute: GetPage(name: AppRoutes.unknown, page: () => const Unknown()),
    );
  }
}
