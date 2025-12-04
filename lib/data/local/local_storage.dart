import 'dart:convert';
import 'package:gmail_clone/data/models/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const key = "saved_accounts";
  static const activeKey = "active_user";

  Future<void> saveAccount(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];

    if (!list.any((e) => AppUser.fromMap(jsonDecode(e)).uid == user.uid)) {
      list.add(jsonEncode(user.toMap()));
      prefs.setStringList(key, list);
    }
  }

  Future<List<AppUser>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(key) ?? [];
    return list.map((e) => AppUser.fromMap(jsonDecode(e))).toList();
  }

  Future<void> saveActiveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(activeKey, jsonEncode(user.toMap()));
  }

  Future<AppUser?> loadActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(activeKey);
    if (raw == null) return null;
    return AppUser.fromMap(jsonDecode(raw));
  }

  Future<void> clearActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(activeKey);
  }
}
