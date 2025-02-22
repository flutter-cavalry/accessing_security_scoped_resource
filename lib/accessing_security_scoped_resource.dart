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
  final bool isFileUrl;

  bool get granted => _granted;

  AppleScopedResource(this.url, {this.isFileUrl = false});

  /// Request access to the security scoped resource.
  /// Throws [BFNoPermissionExp] if the access is denied.
  Future<void> requestAccess() async {
    // No need to request access if already granted.
    if (_granted) {
      return;
    }
    _granted = isFileUrl
        ? await _plugin.startAccessingSecurityScopedResourceWithFilePath(url)
        : await _plugin.startAccessingSecurityScopedResourceWithURL(url);
    if (!_granted) {
      throw Exception(
          'No permission to access the security scoped resource: $url');
    }
  }

  /// Release the access to the security scoped resource.
  Future<void> release() async {
    // Release previous one if needed.
    if (_granted) {
      if (isFileUrl) {
        await _plugin.stopAccessingSecurityScopedResourceWithFilePath(url);
      } else {
        await _plugin.stopAccessingSecurityScopedResourceWithURL(url);
      }
      _granted = false;
    }
  }

  /// Request access to the security scoped resource and run the action.
  Future<void> requestAccessWithAction(Future<void> Function() action) async {
    await requestAccess();
    try {
      await action();
    } finally {
      await release();
    }
  }
}
