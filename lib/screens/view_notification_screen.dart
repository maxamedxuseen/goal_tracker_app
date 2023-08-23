import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/view_notification_controller.dart';
import '../models/notification_master.dart';
import '../utility/constants/dimens_constants.dart';
import '../utility/common_widgets/common_data_holder.dart';
import '../utility/constants/string_constants.dart';

class ViewNotificationsScreen extends StatelessWidget {
  ViewNotificationsScreen({super.key});

  final ViewNotificationsController _controller =
      Get.put(ViewNotificationsController());

  @override
  Widget build(BuildContext context) {
    context.theme;
    return _body();
  }

  Widget _body() {
    return CommonDataHolder(
      controller: _controller,
      dataList: _controller.notificationList,
      widget: Obx(() => _dataHolderWidget()),
      noResultText: 'No Notifications',
      onRefresh: () => _controller.fetchNotifications(),
    );
  }

  Widget _dataHolderWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _controller.notificationList.length,
        itemBuilder: (context, index) {
          return _notificationCard(
            notification: _controller.notificationList[index],
          );
        },
      ),
    );
  }

  Widget _notificationCard({required NotificationMaster notification}) {
    return InkWell(
      onTap: () {
        _controller.onTapNotificationCard(notification: notification);
      },
      borderRadius: BorderRadius.circular(DimenConstants.cardRadius),
      child: Card(
        margin: const EdgeInsets.all(DimenConstants.contentPadding),
        elevation: DimenConstants.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DimenConstants.cardRadius),
        ),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(minWidth: Get.width),
              margin: const EdgeInsets.all(DimenConstants.contentPadding),
              padding: const EdgeInsets.all(DimenConstants.contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: DimenConstants.contentPadding),
                  Text(
                    notification.goalTitle ?? "Unknown",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: Get.textTheme.headlineSmall?.fontSize,
                    ),
                  ),
                  Text(
                    notification.goalType ?? " -- ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: Get.width),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DimenConstants.cardRadius),
              ),
              child: AnyLinkPreview(
                link: notification.motivationLink ?? "",
                displayDirection: UIDirection.uiDirectionVertical,
                cache: const Duration(hours: 1),
                errorWidget: const Text(
                  'Oops! Failed to load motivation link',
                  textAlign: TextAlign.start,
                ),
                errorImage: StringConstants.error404,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
