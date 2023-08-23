class GoalMaster {
  String? goalId, userId, goalTitle, goalType, description,isPublic;
  String? startDate, endDate, currentDate,  progress, userName,percentage;
  String? motivationLink,status;

  GoalMaster({
    this.goalId,
    this.userId,
    this.goalTitle,
    this.goalType,
    this.description,
    this.startDate,
    this.endDate,
    this.currentDate,
    this.isPublic,
    this.progress,
    this.userName,
    this.percentage,
    this.motivationLink,
    this.status,
  });

  GoalMaster.fromJson(Map<String, dynamic> json) {
    goalId = json['goalId'];
    userId = json['userId'];
    goalTitle = json['goalTitle'];
    goalType = json['goalType'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    currentDate = json['currentDate'];
    isPublic = json['isPublic'];
    progress = json['Progress'];
    userName = json['fullName'];
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
    if (goalTitle != null) {
      data["goalTitle"] = goalTitle;
    }
    if (goalType != null) {
      data["goalType"] = goalType;
    }
    if (description != null) {
      data["description"] = description;
    }
    if (startDate != null) {
      data["startDate"] = startDate;
    }
    if (endDate != null) {
      data["endDate"] = endDate;
    }
    if (currentDate != null) {
      data["currentDate"] = currentDate;
    }
    if (isPublic != null) {
      data["isPublic"] = isPublic;
    }
    return data;
  }
}
