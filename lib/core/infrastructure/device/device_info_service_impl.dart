import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/failures/failure.dart';
import '../../domain/services/device_info_service.dart';
import '../../domain/value_objects/device_platform.dart';

part 'device_info_service_impl.g.dart';

/// Implementation of [DeviceInfoService] using device_info_plus.
final class DeviceInfoServiceImpl implements DeviceInfoService {
  DeviceInfoServiceImpl([DeviceInfoPlugin? plugin]) : _plugin = plugin ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _plugin;

  @override
  Future<Either<Failure, DeviceInfo>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo info = await _plugin.androidInfo;
        return right(
          DeviceInfo(
            platform: DevicePlatform.android,
            model: info.model,
            osVersion: 'Android ${info.version.release}',
            isPhysicalDevice: info.isPhysicalDevice,
          ),
        );
      } else if (Platform.isIOS) {
        final IosDeviceInfo info = await _plugin.iosInfo;
        return right(
          DeviceInfo(
            platform: DevicePlatform.ios,
            model: info.model,
            osVersion: '${info.systemName} ${info.systemVersion}',
            isPhysicalDevice: info.isPhysicalDevice,
          ),
        );
      } else {
        return right(
          const DeviceInfo(
            platform: DevicePlatform.other,
            model: 'Unknown',
            osVersion: 'Unknown',
            isPhysicalDevice: true,
          ),
        );
      }
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }
}

@Riverpod(keepAlive: true)
DeviceInfoService deviceInfoService(Ref ref) => DeviceInfoServiceImpl();
