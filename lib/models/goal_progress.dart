class GoalProgress {
  String? goalProgressId, goalId;
  String? previouslyCompletedPercent, currentCompletedPercent;
  String? description, dateTime;
  String? status;

  GoalProgress({
    this.goalProgressId,
    this.goalId,
    this.previouslyCompletedPercent,
    this.currentCompletedPercent,
    this.description,
    this.dateTime,
    this.status,
  });

  GoalProgress.fromJson(Map<String, dynamic> json) {
    goalProgressId = json['goalProgressId'];
    goalId = json['goalId'];
    previouslyCompletedPercent = json['previouslyCompletedPercent'];
    currentCompletedPercent = json['currentCompletedPercent'];
    description = json['description'];
    dateTime = json['dateTime'];
    status = json['api_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (goalProgressId != null) {
      data["goalProgressId"] = goalProgressId;
    }
    if (goalId != null) {
      data["goalId"] = goalId;
    }
    if (previouslyCompletedPercent != null) {
      data["previouslyCompletedPercent"] = previouslyCompletedPercent;
    }
    if (currentCompletedPercent != null) {
      data["currentCompletedPercent"] = currentCompletedPercent;
    }
    if (description != null) {
      data["description"] = description;
    }
    if (dateTime != null) {
      data["dateTime"] = dateTime;
    }
    return data;
  }
}
