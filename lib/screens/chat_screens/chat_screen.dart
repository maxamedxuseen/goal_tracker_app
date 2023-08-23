import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat_controller.dart';
import '../../models/chat.dart';
import '../../utility/common_widgets/common_scaffold.dart';
import '../../utility/common_widgets/received_message.dart';
import '../../utility/common_widgets/sent_message.dart';
import '../../utility/constants/dimens_constants.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatController _controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      appBar: AppBar(
        title: Text(
          _controller.appBarTitle.value,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        actions: [_actionWidget()],
      ),
      body: _body(),
    );
  }

  Widget _actionWidget() {
    return Row(
      children: [
        IconButton(
          onPressed: () => _controller.fetchChats(),
          icon: const Icon(Icons.refresh_outlined),
        ),
      ],
    );
  }

  Widget _body() {
    return Obx(
      () {
        return Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: Get.height,
                    maxWidth: Get.width,
                  ),
                  child: _chatListWidget(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                constraints: BoxConstraints(minWidth: Get.width, minHeight: 60),
                child: _controller.isLoading.value == true
                    ? const SizedBox()
                    : _writeMessageHolder(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _writeMessageHolder() {
    BuildContext? context = Get.context;
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxWidth: Get.width),
      padding: const EdgeInsets.only(left: DimenConstants.contentPadding),
      color: context!.theme.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _controller.etWriteMessage,
              maxLines: 1,
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
                hintText: "Write message...",
              ),
            ),
          ),
          const SizedBox(width: DimenConstants.mixPadding),
          FloatingActionButton(
            heroTag: 'SEND',
            tooltip: "Send Message",
            onPressed: () => _controller.onPressSend(),
            backgroundColor: context.theme.primaryColor,
            elevation: 0,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _chatListWidget() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.scrollToBottom();
    });

    return Container(
      constraints: BoxConstraints(minHeight: Get.height),
      child: _controller.chatList.isEmpty
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              controller: _controller.scrollController,
              itemCount: _controller.chatList.length,
              itemBuilder: (context, index) {
                Chat chat = _controller.chatList[index];
                String? message = chat.chatMessage;
                message = message;
                if (chat.userId == _controller.userId) {
                  return SentMessage(message: message);
                } else {
                  return ReceivedMessage(message: message);
                }
              },
            ),
    );
  }
}
