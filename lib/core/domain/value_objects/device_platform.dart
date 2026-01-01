/// Supported device platforms.
enum DevicePlatform {
  android('Android'),
  ios('iOS'),
  other('Unknown');

  const DevicePlatform(this.displayName);
  final String displayName;
}
