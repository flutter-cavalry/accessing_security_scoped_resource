import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'accessing_security_scoped_resource_platform_interface.dart';

/// An implementation of [AccessingSecurityScopedResourcePlatform] that uses method channels.
class MethodChannelAccessingSecurityScopedResource
    extends AccessingSecurityScopedResourcePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('accessing_security_scoped_resource');

  @override
  Future<bool> startAccessingSecurityScopedResourceWithFilePath(
      String filePath) async {
    return (await methodChannel.invokeMethod<bool>(
            'startAccessingSecurityScopedResourceWithFilePath',
            {'filePath': filePath})) ??
        false;
  }

  @override
  Future<void> stopAccessingSecurityScopedResourceWithFilePath(
      String filePath) async {
    await methodChannel.invokeMethod<bool>(
        'stopAccessingSecurityScopedResourceWithFilePath',
        {'filePath': filePath});
  }

  @override
  Future<bool> startAccessingSecurityScopedResourceWithURL(String url) async {
    return (await methodChannel.invokeMethod<bool>(
            'startAccessingSecurityScopedResourceWithURL', {'url': url})) ??
        false;
  }

  @override
  Future<void> stopAccessingSecurityScopedResourceWithURL(String url) async {
    await methodChannel.invokeMethod<bool>(
        'stopAccessingSecurityScopedResourceWithURL', {'url': url});
  }
}
