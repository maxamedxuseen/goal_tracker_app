import 'package:get/get.dart';

import '../models/chat.dart';
import '../utility/constants/api_constants.dart';
import '../utility/routes/route_constants.dart';
import '../utility/services/api_provider.dart';
import '../utility/services/user_pref.dart';

class RecentChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Chat> chatList = <Chat>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentChats();
  }

  void onTapChatCard({required Chat chat}) {
    Get.toNamed(RouteConstants.chatScreen, arguments: chat)
        ?.then((value) => fetchRecentChats());
  }

  Future<void> fetchRecentChats() async {
    try {
      isLoading(true);
      chatList.clear();
      String userId = await UserPref.getUserId();
      List<dynamic> jsonResponse = await ApiProvider.getMethod(
        url: ApiConstants.getRecentChats + userId,
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
    }
  }
}
