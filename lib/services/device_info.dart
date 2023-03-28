import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  final _deviceInfo = DeviceInfoPlugin();

  getDeviceModel() async {
    try {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.model.toString();
    } catch (e) {
      return 'device_name_not_found';
    }
  }
}
