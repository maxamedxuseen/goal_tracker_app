import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/chat.dart';
import '../utility/constants/api_constants.dart';
import '../utility/helper/common_helper.dart';
import '../utility/helper/snack_bar_utils.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class ChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxString appBarTitle = 'Chat'.obs;
  RxList<Chat> chatList = <Chat>[].obs;

  late Chat? chatArg;
  late String? userId;
  late ScrollController scrollController;
  late TextEditingController etWriteMessage;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initUI();
    fetchChats();
  }

  Future<void> initUI() async {
    chatArg = Get.arguments;
    appBarTitle.value = chatArg?.sentByName ?? 'Chat';
    scrollController = ScrollController();
    etWriteMessage = TextEditingController();
    userId = await UserPref.getUserId();
  }

  void scrollToBottom() {
    try {
      final position = scrollController.position.maxScrollExtent;
      if (scrollController.hasClients) scrollController.jumpTo(position);
    } catch (ignored) {
      CommonHelper.printDebugError(
        'Failed to scroll to bottom',
        'ChatController line no : 44',
      );
    }
  }

  void onPressSend() {
    try {
      if (etWriteMessage.text.toString().trim() != "") {
        _sendMessage();
      } else {
        SnackBarUtils.errorSnackBar(
          title: 'Empty',
          message: 'Message cannot be empty',
        );
      }
    } catch (e) {
      CommonHelper.printDebugError(e, "ChatController line 64");
    } finally {
      fetchChats();
    }
  }

  Future<Chat> _createChatObject() async {
    Chat chat = Chat();
    chat.userId = userId ?? await UserPref.getUserId();
    chat.otherUserId = chatArg?.otherUserId == chat.userId
        ? chatArg?.userId
        : chatArg?.otherUserId;
    chat.chatMessage = etWriteMessage.text.trim();
    return chat;
  }

  Future<void> fetchChats() async {
    try {
      isLoading(true);
      chatList.clear();
      List<dynamic> jsonResponse = await ApiProvider.postMethod(
        url: ApiConstants.getChatByUser,
        obj: (await _createChatObject()).toJson(),
      );
      if (jsonResponse.first["api_status"] == "true" ||
          jsonResponse.first["api_status"] == "ok") {
        chatList.value = jsonResponse.map((e) {
          return Chat.fromJson(e);
        }).toList();
      }
    } catch (e) {
      chatList.value = <Chat>[];
    } finally {
      isLoading(false);
      scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    try {
      await ApiProvider.postMethod(
        url: ApiConstants.addChat,
        obj: (await _createChatObject()).toJson(),
      ).then((response) {
        List chatList = response.map((e) {
          return Chat.fromJson(e);
        }).toList();
        if (chatList.isNotEmpty) {
          if (chatList.first.status == 'true' ||
              chatList.first.status == 'ok') {
            etWriteMessage.clear();
            fetchChats();
          } else {
            _onFailedResponse();
          }
        }
      });
    } catch (e) {
      CommonHelper.printDebugError(e, "ChatController line 124");
      _onFailedResponse();
    }
  }

  void _onFailedResponse() {
    SnackBarUtils.errorSnackBar(
      title: "Failed",
      message: "Something went wrong",
    );
  }
}
