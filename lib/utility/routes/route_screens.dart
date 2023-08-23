import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../screens/bottom_navigation_screen.dart';
import '../../screens/change_password_screen.dart';
import '../../screens/chat_screens/chat_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/manage_goal_progress_screen.dart';
import '../../screens/manage_goal_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/registration_screen.dart';
import '../../screens/view_goal_progress_screen.dart';
import 'route_constants.dart';

class RouteScreens {
  static final routes = [
    GetPage(
      name: RouteConstants.loginScreen,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: RouteConstants.registrationScreen,
      page: () => RegistrationScreen(),
    ),
    GetPage(
      name: RouteConstants.bottomNavigationScreen,
      page: () => BottomNavigationScreen(),
    ),
    GetPage(
      name: RouteConstants.profileScreen,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: RouteConstants.changePasswordScreen,
      page: () => ChangePasswordScreen(),
    ),
    GetPage(
      name: RouteConstants.manageGoalScreen,
      page: () => ManageGoalScreen(),
    ),
    GetPage(
      name: RouteConstants.chatScreen,
      page: () => ChatScreen(),
    ),
    GetPage(
      name: RouteConstants.viewGoalProgressScreen,
      page: () => ViewGoalProgressScreen(),
    ),
    GetPage(
      name: RouteConstants.manageGoalProgressScreen,
      page: () => ManageGoalProgressScreen(),
    ),
  ];
}
