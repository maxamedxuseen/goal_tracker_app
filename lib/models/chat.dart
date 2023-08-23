class Chat {
  String? chatId, userId, otherUserId, chatMessage, sentDateTime;
  String? sentByName;
  String? status;

  Chat();

  Chat.fromJson(Map<String, dynamic> json) {
    chatId = json['chatId'];
    userId = json['userId'];
    otherUserId = json['otherUserId'];
    chatMessage = json['chatMessage'];
    sentDateTime = json['sentDateTime'];
    sentByName = json['sentByName'];
    status = json['api_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) data["userId"] = userId;
    if (otherUserId != null) data["otherUserId"] = otherUserId;
    if (chatMessage != null) data["chatMessage"] = chatMessage;
    return data;
  }
}
