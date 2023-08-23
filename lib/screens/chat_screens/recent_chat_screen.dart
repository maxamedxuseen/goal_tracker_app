import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/recent_chat_controller.dart';
import '../../models/chat.dart';
import '../../utility/common_widgets/common_data_holder.dart';
import '../../utility/constants/dimens_constants.dart';

class RecentChatScreen extends StatelessWidget {
  RecentChatScreen({super.key});

  final RecentChatController _controller = Get.put(RecentChatController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          constraints: BoxConstraints(maxHeight: Get.height),
          child: CommonDataHolder(
            controller: _controller,
            dataList: _controller.chatList,
            widget: _dataHolderWidget(),
            noResultText: "No Recent Chat found",
            onRefresh: () => _controller.fetchRecentChats(),
          ),
        );
      },
    );
  }

  Widget _dataHolderWidget() {
    return Container(
      constraints: BoxConstraints(minHeight: Get.height / 1.2),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: _controller.chatList.length,
        itemBuilder: (context, index) {
          return _recentChatCard(_controller.chatList[index]);
        },
      ),
    );
  }

  Widget _recentChatCard(Chat chat) {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.contentPadding),
      child: InkWell(
        onTap: () => _controller.onTapChatCard(chat:chat),
        borderRadius: const BorderRadius.all(
          Radius.circular(DimenConstants.cardRadius),
        ),
        child: Card(
          elevation: DimenConstants.cardElevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(DimenConstants.cardRadius),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(DimenConstants.layoutPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.sentByName ?? "Unknown User",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: DimenConstants.contentPadding),
                    Text("Message : ${chat.chatMessage ?? ""}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
