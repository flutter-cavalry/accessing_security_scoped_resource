import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:accessing_security_scoped_resource/accessing_security_scoped_resource.dart';
import 'package:ios_document_picker/ios_document_picker.dart';
import 'package:ios_document_picker/types.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _output = '';
  String? _dirUrl;
  bool _fileUrl = false;
  final _accessingSecurityScopedResourcePlugin =
      AccessingSecurityScopedResource();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                  onPressed: _selectDir,
                  child: const Text('Select a directory')),
              if (_dirUrl != null) Text(_dirUrl!),
              _sep(),
              OutlinedButton(
                  onPressed: _dirUrl != null ? _start : null,
                  child:
                      const Text('startAccessingSecurityScopedResource (URL)')),
              _sep(),
              OutlinedButton(
                  onPressed: _dirUrl != null ? _stop : null,
                  child:
                      const Text('stopAccessingSecurityScopedResource (URL)')),
              _sep(),
              OutlinedButton(
                  onPressed: _dirUrl != null ? _startAndStop : null,
                  child: const Text('AppleScopedResource')),
              _sep(),
              OutlinedButton(
                  onPressed: _dirUrl != null ? _startPath : null,
                  child: const Text(
                      'startAccessingSecurityScopedResource (FilePath)')),
              _sep(),
              OutlinedButton(
                  onPressed: _dirUrl != null ? _stopPath : null,
                  child: const Text(
                      'stopAccessingSecurityScopedResource (FilePath)')),
              _sep(),
              Text(_output)
            ],
          ),
        ),
      ),
    );
  }

  Widget _sep() {
    return const SizedBox(
      height: 10,
    );
  }

  Future<void> _selectDir() async {
    try {
      String? dir;
      bool isFileUrl = false;
      if (Platform.isIOS) {
        final iosPicker = IosDocumentPicker();
        dir =
            (await iosPicker.pick(IosDocumentPickerType.directory))?.first.url;
      } else {
        dir = await getDirectoryPath();
        isFileUrl = true;
      }
      if (dir == null) {
        return;
      }
      setState(() {
        _dirUrl = dir;
        _fileUrl = isFileUrl;
      });
    } catch (err) {
      setState(() {
        _output = err.toString();
      });
    }
  }

  void _start() async {
    if (_dirUrl == null) {
      return;
    }
    final url = _fileUrl ? Uri.directory(_dirUrl!).toString() : _dirUrl!;
    final hasAccess = await _accessingSecurityScopedResourcePlugin
        .startAccessingSecurityScopedResourceWithURL(url);
    setState(() {
      _output = 'Has access: $hasAccess';
    });
  }

  void _stop() {
    if (_dirUrl == null) {
      return;
    }
    final url = _fileUrl ? Uri.directory(_dirUrl!).toString() : _dirUrl!;
    _accessingSecurityScopedResourcePlugin
        .stopAccessingSecurityScopedResourceWithURL(
            Uri.directory(url).toString());
    setState(() {
      _output = '';
    });
  }

  void _startAndStop() async {
    if (_dirUrl == null) {
      return;
    }
    final url = _fileUrl ? Uri.directory(_dirUrl!).toString() : _dirUrl!;
    final resScope = AppleScopedResource(Uri.directory(url).toString());
    await resScope.requestAccessWithAction(() async {
      setState(() {
        _output = 'Access granted';
      });
    });
  }

  void _startPath() async {
    if (_dirUrl == null) {
      return;
    }
    final url = _fileUrl ? Uri.directory(_dirUrl!).toString() : _dirUrl!;
    final hasAccess = await _accessingSecurityScopedResourcePlugin
        .startAccessingSecurityScopedResourceWithFilePath(url);
    setState(() {
      _output = 'Has access: $hasAccess';
    });
  }

  void _stopPath() {
    if (_dirUrl == null) {
      return;
    }
    final url = _fileUrl ? Uri.directory(_dirUrl!).toString() : _dirUrl!;
    _accessingSecurityScopedResourcePlugin
        .stopAccessingSecurityScopedResourceWithFilePath(url);
    setState(() {
      _output = '';
    });
  }
}
