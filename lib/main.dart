import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'utility/constants/string_constants.dart';
import 'utility/routes/route_constants.dart';
import 'utility/routes/route_screens.dart';
import 'utility/services/user_pref.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

Future<void> main() async {
  await GetStorage.init();
  String? userId = await UserPref.getUserId();
  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    context.theme;
    Get.testMode = true;
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      title: StringConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.redWine),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.redWine),
      themeMode: ThemeMode.system,
      initialRoute:
          userId == null || userId == "-1" || userId == "0" || userId!.isEmpty
              ? RouteConstants.loginScreen
              : RouteConstants.bottomNavigationScreen,
      getPages: RouteScreens.routes,
    );
  }
}
