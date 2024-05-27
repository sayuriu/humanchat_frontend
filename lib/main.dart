import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:humanchat_frontend/core/app_routes.dart';
import 'package:humanchat_frontend/screens/welcome.dart';
import 'package:humanchat_frontend/screens/unknown.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomeScreen(),
      initialRoute: AppRoutes.welcome,
      unknownRoute: GetPage(name: AppRoutes.unknown, page: () => const Unknown()),
    );
  }
}
