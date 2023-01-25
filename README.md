[![pub package](https://img.shields.io/pub/v/accessing_security_scoped_resource.svg)](https://pub.dev/packages/accessing_security_scoped_resource)

# accessing_security_scoped_resource

Call `startAccessingSecurityScopedResource` and `stopAccessingSecurityScopedResource` in Flutter.

## Usage

```dart
final _plugin = AccessingSecurityScopedResource();

final folderPath = /* Get a folder path */;

// Get access.
final hasAccess = await _plugin.startAccessingSecurityScopedResourceWithFilePath(folderPath);

// Release access.
_plugin.stopAccessingSecurityScopedResourceWithFilePath(folderPath);
```
