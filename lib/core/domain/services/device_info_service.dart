import 'package:fpdart/fpdart.dart';

import '../failures/failure.dart';
import '../value_objects/device_platform.dart';

/// Device information for platform-specific features.
class DeviceInfo {
  const DeviceInfo({
    required this.platform,
    required this.model,
    required this.osVersion,
    required this.isPhysicalDevice,
  });

  final DevicePlatform platform;
  final String model;
  final String osVersion;
  final bool isPhysicalDevice;
}

/// Device information service interface.
abstract interface class DeviceInfoService {
  Future<Either<Failure, DeviceInfo>> getDeviceInfo();
}
