import 'dart:convert';
import 'package:gmail_clone/data/models/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const accountsKey = "saved_accounts";
  static const activeUserKey = "active_user";

  Future<void> saveAccount(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(accountsKey) ?? [];

    final exists = saved.any(
      (e) => AppUser.fromMap(jsonDecode(e)).uid == user.uid,
    );
    if (!exists) {
      saved.add(jsonEncode(user.toMap()));
      await prefs.setStringList(accountsKey, saved);
    }
  }

  Future<List<AppUser>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(accountsKey) ?? [];
    return list.map((e) => AppUser.fromMap(jsonDecode(e))).toList();
  }

  Future<void> removeAccount(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(accountsKey) ?? [];

    final filtered =
        list.where((e) {
          final user = AppUser.fromMap(jsonDecode(e));
          return user.uid != uid;
        }).toList();

    await prefs.setStringList(accountsKey, filtered);
  }

  Future<void> saveActiveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(activeUserKey, jsonEncode(user.toMap()));
  }

  Future<AppUser?> loadActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(activeUserKey);
    if (data == null) return null;

    return AppUser.fromMap(jsonDecode(data));
  }

  Future<void> clearActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(activeUserKey);
  }
}
