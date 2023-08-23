class ApiConstants {
  static const String baseUrl = "http://agoaltrackingapp.hostoise.com";

  //PROFILE
  static const String user = "$baseUrl/api/User";
  static const String userRegister = "$user/Register/";
  static const String userLogin = "$user/Login/";
  static const String getUserProfile = "$user/GetUserProfile/";
  static const String changePassword = "$user/ChangePassword/";
  static const String updateProfile = "$user/UpdateProfile/";

  //GOAL
  static const String goals = "$baseUrl/api/Goals";
  static const String addGoal = "$goals/AddGoal/";
  static const String updateGoal = "$goals/UpdateGoal/";
  static const String getUserGoals = "$goals/GetUserGoals/";
  static const String deleteGoal = "$goals/DeleteGoal/";
  static const String getPublicGoals = "$goals/GetPublicGoals/";
  static const String getNotification = "$goals/GetNotifications/";

  //GOAL_PROGRESS
  static const String progress = "$baseUrl/api/GoalProgress";
  static const String addGoalProgress = "$progress/AddGoalProgress/";
  static const String updateGoalProgress = "$progress/UpdateGoalProgress/";
  static const String getGoalProgress = "$progress/GetGoalProgressByGoalId/";
  static const String deleteGoalProgress = "$progress/DeleteGoalProgress/";

  //CHAT
  static const String chat = "$baseUrl/api/Chat";
  static const String addChat = "$chat/AddChat/";
  static const String getRecentChats = "$chat/GetRecentChatUsers/";
  static const String getChatByUser = "$chat/GetChatByUser/";
}
