import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:master_utility/master_utility.dart';

class DeviceInfoHelper {
  DeviceInfoHelper._();
  static final DeviceInfoHelper _instance = DeviceInfoHelper._();
  static DeviceInfoHelper get instance => _instance;

  final _deviceInfoPlugin = DeviceInfoPlugin();

  AndroidDeviceInfo? _androidDeviceInfo;
  IosDeviceInfo? _iosDeviceInfo;

  int androidVersion = 0;

  Future<void> initPlatformState() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        _androidDeviceInfo = await _deviceInfoPlugin.androidInfo;

        androidVersion = int.parse(_androidDeviceInfo?.version.release ?? '0');
        LogHelper.logWarning('DeviceVersion:- $androidVersion');
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        _iosDeviceInfo = await _deviceInfoPlugin.iosInfo;
        LogHelper.logWarning(
          'DeviceVersion:- ${_iosDeviceInfo?.systemVersion}',
        );
      }
    } on PlatformException catch (e) {
      LogHelper.logError('PlatformException:- $e');
    }
  }

  AndroidDeviceInfo? get androidInfo => _androidDeviceInfo;
  IosDeviceInfo? get iosInfo => _iosDeviceInfo;
}
