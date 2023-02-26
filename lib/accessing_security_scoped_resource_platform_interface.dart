import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'accessing_security_scoped_resource_method_channel.dart';

abstract class AccessingSecurityScopedResourcePlatform
    extends PlatformInterface {
  /// Constructs a AccessingSecurityScopedResourcePlatform.
  AccessingSecurityScopedResourcePlatform() : super(token: _token);

  static final Object _token = Object();

  static AccessingSecurityScopedResourcePlatform _instance =
      MethodChannelAccessingSecurityScopedResource();

  /// The default instance of [AccessingSecurityScopedResourcePlatform] to use.
  ///
  /// Defaults to [MethodChannelAccessingSecurityScopedResource].
  static AccessingSecurityScopedResourcePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AccessingSecurityScopedResourcePlatform] when
  /// they register themselves.
  static set instance(AccessingSecurityScopedResourcePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> startAccessingSecurityScopedResourceWithFilePath(
      String filePath) async {
    throw UnimplementedError(
        'startAccessingSecurityScopedResourceWithFilePath() has not been implemented.');
  }

  Future<void> stopAccessingSecurityScopedResourceWithFilePath(
      String filePath) async {
    throw UnimplementedError(
        'stopAccessingSecurityScopedResourceWithFilePath() has not been implemented.');
  }

  Future<bool> startAccessingSecurityScopedResourceWithURL(Uri url) async {
    throw UnimplementedError(
        'startAccessingSecurityScopedResourceWithURL() has not been implemented.');
  }

  Future<void> stopAccessingSecurityScopedResourceWithURL(Uri url) async {
    throw UnimplementedError(
        'stopAccessingSecurityScopedResourceWithURL() has not been implemented.');
  }
}
