import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:my_travaly/src/routes/app_routes.dart';

import 'package:my_travaly/src/features/login/model/login_model.dart';

class AuthStorageService extends GetxService {
  AuthStorageService({FlutterSecureStorage? storage})
      : _secureStorage = storage ?? const FlutterSecureStorage();

  static AuthStorageService get to => Get.find();

  final FlutterSecureStorage _secureStorage;

  static const String _loginUserKey = 'login_user';

  final Rxn<LoginUser> _storedUser = Rxn<LoginUser>();

  LoginUser? get currentUser => _storedUser.value;

  String get initialPage => _storedUser.value == null ? AppRoutes.login : AppRoutes.dashboard;

  Future<AuthStorageService> init() async {
    await loadUser();
    return this;
  }

  Future<LoginUser?> loadUser() async {
    try {
      final stored = await _secureStorage.read(key: _loginUserKey);
      if (stored == null || stored.isEmpty) {
        _storedUser.value = null;
        return null;
      }

      final Map<String, dynamic> userJson =
          Map<String, dynamic>.from(jsonDecode(stored) as Map);
      final loginUser = LoginUser.fromJson(userJson);
      _storedUser.value = loginUser;
      return loginUser;
    } catch (e, stacktrace) {
      await _secureStorage.delete(key: _loginUserKey);
      _storedUser.value = null;
      if (kDebugMode) {
        print('Error loading stored user: $e \n $stacktrace');
      }
      return null;
    }
  }

  Future<void> saveUser(LoginUser loginUser) async {
    try {
      await _secureStorage.write(
        key: _loginUserKey,
        value: jsonEncode(loginUser.toJson()),
      );
      _storedUser.value = loginUser;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error saving user: $e \n $stacktrace');
      }
    }
  }

  Future<void> clearUser() async {
    try {
      await _secureStorage.delete(key: _loginUserKey);
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print('Error clearing user: $e \n $stacktrace');
      }
    } finally {
      _storedUser.value = null;
    }
  }
}
