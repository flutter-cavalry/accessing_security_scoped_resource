import 'accessing_security_scoped_resource_platform_interface.dart';

class AccessingSecurityScopedResource {
  Future<bool> startAccessingSecurityScopedResourceWithFilePath(
      String filePath) async {
    return AccessingSecurityScopedResourcePlatform.instance
        .startAccessingSecurityScopedResourceWithFilePath(filePath);
  }

  Future<void> stopAccessingSecurityScopedResourceWithFilePath(
      String filePath) async {
    return AccessingSecurityScopedResourcePlatform.instance
        .stopAccessingSecurityScopedResourceWithFilePath(filePath);
  }

  Future<bool> startAccessingSecurityScopedResourceWithURL(Uri url) async {
    return AccessingSecurityScopedResourcePlatform.instance
        .startAccessingSecurityScopedResourceWithURL(url);
  }

  Future<void> stopAccessingSecurityScopedResourceWithURL(Uri url) async {
    return AccessingSecurityScopedResourcePlatform.instance
        .stopAccessingSecurityScopedResourceWithURL(url);
  }
}
