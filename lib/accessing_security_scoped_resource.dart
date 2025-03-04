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

  Future<bool> startAccessingSecurityScopedResourceWithURL(String url) async {
    return AccessingSecurityScopedResourcePlatform.instance
        .startAccessingSecurityScopedResourceWithURL(url);
  }

  Future<void> stopAccessingSecurityScopedResourceWithURL(String url) async {
    return AccessingSecurityScopedResourcePlatform.instance
        .stopAccessingSecurityScopedResourceWithURL(url);
  }
}

final _plugin = AccessingSecurityScopedResource();

class AppleScopedResource {
  bool _granted = false;

  final String url;
  final bool isFilePath;

  bool get granted => _granted;

  AppleScopedResource(this.url, {this.isFilePath = false});

  /// Request access to the security scoped resource.
  /// This will update [granted].
  /// Note: some resources may not require access and [granted] may be false.
  Future<void> requestAccess() async {
    _granted = isFilePath
        ? await _plugin.startAccessingSecurityScopedResourceWithFilePath(url)
        : await _plugin.startAccessingSecurityScopedResourceWithURL(url);
  }

  /// Release the access to the security scoped resource.
  Future<void> release() async {
    // Release previous one if needed.
    if (_granted) {
      if (isFilePath) {
        await _plugin.stopAccessingSecurityScopedResourceWithFilePath(url);
      } else {
        await _plugin.stopAccessingSecurityScopedResourceWithURL(url);
      }
      _granted = false;
    }
  }

  /// Request access to the security scoped resource and run the action. This also releases the access after the action is done.
  Future<bool> useAccess(Future<void> Function() action) async {
    await requestAccess();
    try {
      if (_granted) {
        await action();
        return true;
      }
      return false;
    } finally {
      await release();
    }
  }
}
