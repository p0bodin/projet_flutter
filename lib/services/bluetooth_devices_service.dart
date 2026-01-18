import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BluetoothDevicesService {
  static const String _connectedDevicesKey = 'connectedBluetoothDevices';

  static Future<void> saveConnectedDevice({
    required String deviceId,
    required String deviceName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? devicesJson = prefs.getString(_connectedDevicesKey);

    List<Map<String, dynamic>> devices = [];
    if (devicesJson != null) {
      devices = List<Map<String, dynamic>>.from(jsonDecode(devicesJson));
    }

    // Check if device already exists
    final index = devices.indexWhere((d) => d['deviceId'] == deviceId);
    if (index == -1) {
      devices.add({
        'deviceId': deviceId,
        'deviceName': deviceName,
        'connectedAt': DateTime.now().toString().split('.')[0],
      });
    }

    await prefs.setString(_connectedDevicesKey, jsonEncode(devices));
  }

  static Future<void> removeConnectedDevice(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? devicesJson = prefs.getString(_connectedDevicesKey);

    if (devicesJson != null) {
      List<Map<String, dynamic>> devices =
          List<Map<String, dynamic>>.from(jsonDecode(devicesJson));
      devices.removeWhere((d) => d['deviceId'] == deviceId);
      await prefs.setString(_connectedDevicesKey, jsonEncode(devices));
    }
  }

  static Future<List<Map<String, dynamic>>> getConnectedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? devicesJson = prefs.getString(_connectedDevicesKey);

    if (devicesJson != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(devicesJson));
    }
    return [];
  }

  static Future<void> clearAllConnectedDevices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_connectedDevicesKey);
  }
}
