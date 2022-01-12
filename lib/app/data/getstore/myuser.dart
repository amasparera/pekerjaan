import 'package:get_storage/get_storage.dart';

class Myuser {
  //  key db
  static String userIdKEY = 'userkey';
  static String userNameKEY = 'usernamekey';
  static String displayNameKEY = 'userdisplaykey';
  static String userEmailKEY = 'useremailkey';
  static String userProfilePicKEY = 'userprofilepickey';
  static String admin = 'admin';

  // save getstorage
  final GetStorage _box = GetStorage();

  // save getstorage
  saveUserId(String? userId) {
    (userId == null) ? null : _box.write(userIdKEY, userId);
  }

  saveUserName(String? userName) {
    (userName == null) ? null : _box.write(userNameKEY, userName);
  }

  saveDisplayName(String? displayName) {
    (displayName == null) ? null : _box.write(displayNameKEY, displayName);
  }

  saveUserEmail(String? userEmail) {
    (userEmail == null) ? null : _box.write(userEmailKEY, userEmail);
  }

  saveUserProfile(String? profileUrl) {
    (profileUrl == null) ? null : _box.write(userProfilePicKEY, profileUrl);
  }

  // load getstorage
  String loadUserId() {
    return _box.read(userIdKEY);
  }

  String loadUserName() {
    return _box.read(userNameKEY);
  }

  String loadDisplayName() {
    return _box.read(displayNameKEY);
  }

  String loadEmail() {
    return _box.read(userEmailKEY);
  }

  String loadPRofilePic() {
    return _box.read(userProfilePicKEY);
  }
}
