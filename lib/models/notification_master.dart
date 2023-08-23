class NotificationMaster {
  String? goalId, userId, goalTitle, goalType, progress, percentage;
  String? motivationLink, currentDate, status;

  NotificationMaster({
    this.goalId,
    this.userId,
    this.goalTitle,
    this.goalType,
    this.progress,
    this.percentage,
    this.motivationLink,
    this.currentDate,
    this.status,
  });

  NotificationMaster.fromJson(Map<String, dynamic> json) {
    goalId = json['goalId'];
    goalTitle = json['goalTitle'];
    goalType = json['goalType'];
    progress = json['Progress'];
    percentage = json['Percentage'];
    motivationLink = json['motivationLink'];
    status = json['api_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (goalId != null) {
      data["goalId"] = goalId;
    }
    if (userId != null) {
      data["userId"] = userId;
    }
    if (currentDate != null) {
      data["currentDate"] = currentDate;
    }
    return data;
  }
}
