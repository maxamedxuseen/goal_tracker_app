import 'package:get_storage/get_storage.dart';

import '../constants/string_constants.dart';
import '../helper/common_helper.dart';

class UserPref {
  static final getStorage = GetStorage();

  static Future<void> setUserId({
    required String userId,
  }) async {
    await getStorage.write(StringConstants.userId, userId);
  }

  static Future<String> getUserId() async {
    try {
      return await getStorage.read(StringConstants.userId);
    } catch (e) {
      CommonHelper.printDebugError(e,"UserPref line 19");
      return "-1";
    }
  }

  static removeAllFromUserPref() async {
    try {
      await GetStorage.init();
      return await getStorage.erase();
    } catch (e) {
      CommonHelper.printDebugError(e,"UserPref line 29");
      return Future.error(e);
    }
  }
}
