import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goal_tracker_app/screens/view_notification_screen.dart';

import '../../controllers/bottom_navigation_controller.dart';
import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/constants/dimens_constants.dart';
import 'chat_screens/recent_chat_screen.dart';
import 'search_public_goals_screen.dart';
import 'view_goals_screen.dart';

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);

  final BottomNavigationController _controller =
      Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return Obx(
      () {
        return CommonScaffold(
          appBar: AppBar(
            title: Text(_controller.appBarTitle.value),
            elevation: _controller.elevation.value,
            actions: [_actionWidget()],
          ),
          body: IndexedStack(
            index: _controller.tabIndex.value,
            children: [
              ViewNotificationsScreen(),
              SearchPublicGoalsScreen(),
              ViewGoalsScreen(),
              RecentChatScreen(),
            ],
          ),
          bottomNavigationBar: _bottomNavigationBar(),
        );
      },
    );
  }

  Widget _actionWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: DimenConstants.mixPadding),
      child: PopupMenuButton<String>(
        elevation: DimenConstants.cardElevation,
        onSelected: (value) => _controller.onTapPopupMenu(value),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(value: 'Profile', child: Text('Profile')),
          const PopupMenuItem<String>(value: 'Logout', child: Text('Logout')),
          const PopupMenuItem<String>(value: 'Exit', child: Text('Exit')),
        ],
        child: const Icon(Icons.manage_accounts_outlined),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (value) => _controller.changeTabIndex(value),
      currentIndex: _controller.tabIndex.value,
      type: BottomNavigationBarType.fixed,
      elevation: DimenConstants.cardElevation,
      items: [
        _bottomNavItemView(iconData: Icons.notifications_outlined, title: 'Notification'),
        _bottomNavItemView(iconData: Icons.search_outlined, title: 'Search'),
        _bottomNavItemView(iconData: Icons.home_outlined, title: 'Home'),
        _bottomNavItemView(iconData: Icons.chat_bubble_outline, title: 'Chat'),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavItemView({
    required IconData iconData,
    required String title,
  }) {
    return BottomNavigationBarItem(icon: Icon(iconData), label: title);
  }
}
