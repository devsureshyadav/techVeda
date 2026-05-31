import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionProvider extends ChangeNotifier {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //current version
  String _currentVersion = '';
  String get currentVersion => _currentVersion;

  //latest version
  String _latestVersion = '';
  String get latestVersion => _latestVersion;

  //downloadUrl
  String _downloadUrl = '';
  String get downloadUrl => _downloadUrl;

  VersionProvider() {
    checkForUpdate();
  }
  //fetch latest version
  Future<bool> checkForUpdate() async {
    try {
      // Get latest version from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('app_config')
          .doc('latest_version')
          .get();

      if (!snapshot.exists) {
        _logVersionIssue('Latest version not found in Firestore.');
        return false;
      }

      _latestVersion = snapshot.data()?['latest_version'] ?? "1.0.0";
      _downloadUrl = snapshot.data()?['downloadUrl'] ?? "";
      // Get current installed app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _currentVersion = packageInfo.version;

      if (_currentVersion != _latestVersion) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logVersionIssue('Error checking for update: $e');
      return false;
    }
  }

  void _logVersionIssue(String message) {
    if (kDebugMode) {
      debugPrint('[VersionProvider] $message');
      Get.snackbar(
        'Error',
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<bool> updateApp(String version, String downloadUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection('app_config')
          .doc('latest_version')
          .update({
        'latest_version': version,
        'downloadUrl': downloadUrl,
      });
      notifyListeners();
      _showSnackBar('Updated successfully', Colors.green[900]);
      return true;
    } catch (e) {
      _showSnackBar('Error while updating', Colors.red[900]);
      return false;
    }
  }

  void _showSnackBar(String message, Color? color) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        padding: EdgeInsets.only(right: 10),
        backgroundColor: color,
      ),
    );
  }
}
