
import 'package:shared_preferences/shared_preferences.dart';

final GROUPID_KEY = 'groupId';
final USERID_KEY = 'uid';
final EMAIL_KEY = 'email';
final DISPLAYNAME_KEY = 'displayName';
final GETTONE_KEY = 'gettone';

Future<String> getGroupId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(GROUPID_KEY);
}

Future<bool> saveGroupId(String groupId) async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setString(GROUPID_KEY, groupId);
}

Future<bool> saveUserId(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(USERID_KEY, userId);
}

Future<String> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(EMAIL_KEY);
}

Future<bool> saveEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(EMAIL_KEY, email);
}

Future<String> getDisplayName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(DISPLAYNAME_KEY);
}

Future<bool> saveDisplayName(String displayName) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(DISPLAYNAME_KEY, displayName);
}

Future<void> deselectGettone() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setString(GETTONE_KEY, null);
}