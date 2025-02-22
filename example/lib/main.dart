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
  String? _dir;
  bool _isFilePath = false;
  final _accessingSecurityScopedResourcePlugin =
      AccessingSecurityScopedResource();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: _selectDir,
                child: const Text('Select a directory'),
              ),
              if (_dir != null) Text(_dir!),
              _sep(),
              OutlinedButton(
                onPressed: _dir != null ? _start : null,
                child: const Text('startAccessingSecurityScopedResource (URL)'),
              ),
              _sep(),
              OutlinedButton(
                onPressed: _dir != null ? _stop : null,
                child: const Text('stopAccessingSecurityScopedResource (URL)'),
              ),
              _sep(),
              OutlinedButton(
                onPressed: _dir != null ? _startAppleScopedResource : null,
                child: const Text('AppleScopedResource'),
              ),
              _sep(),
              OutlinedButton(
                onPressed: _dir != null ? _startPath : null,
                child: const Text(
                  'startAccessingSecurityScopedResource (FilePath)',
                ),
              ),
              _sep(),
              OutlinedButton(
                onPressed: _dir != null ? _stopPath : null,
                child: const Text(
                  'stopAccessingSecurityScopedResource (FilePath)',
                ),
              ),
              _sep(),
              Text(_output),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sep() {
    return const SizedBox(height: 10);
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
        _dir = dir;
        _isFilePath = isFileUrl;
      });
    } catch (err) {
      setState(() {
        _output = err.toString();
      });
    }
  }

  void _start() async {
    try {
      setState(() {
        _output = '';
      });
      if (_dir == null) {
        return;
      }
      final url = _isFilePath ? Uri.directory(_dir!).toString() : _dir!;
      final hasAccess = await _accessingSecurityScopedResourcePlugin
          .startAccessingSecurityScopedResourceWithURL(url);
      setState(() {
        _output += 'Has access: $hasAccess\n';
      });
    } catch (err) {
      setState(() {
        _output += 'Error: $err\n';
      });
    }
  }

  void _stop() {
    try {
      setState(() {
        _output = '';
      });
      if (_dir == null) {
        return;
      }
      final url = _isFilePath ? Uri.directory(_dir!).toString() : _dir!;
      _accessingSecurityScopedResourcePlugin
          .stopAccessingSecurityScopedResourceWithURL(
            Uri.directory(url).toString(),
          );
    } catch (err) {
      setState(() {
        _output += 'Error: $err\n';
      });
    }
  }

  void _startAppleScopedResource() async {
    try {
      setState(() {
        _output = '';
      });
      if (_dir == null) {
        return;
      }
      final url = _isFilePath ? Uri.directory(_dir!).toString() : _dir!;
      final resScope = AppleScopedResource(url);
      await resScope.useAccess(() async {
        setState(() {
          _output += 'Access granted';
        });
      });
    } catch (err) {
      setState(() {
        _output += 'Error: $err\n';
      });
    }
  }

  void _startPath() async {
    try {
      setState(() {
        _output = '';
      });
      if (_dir == null) {
        return;
      }
      final url = _isFilePath ? Uri.directory(_dir!).toString() : _dir!;
      final hasAccess = await _accessingSecurityScopedResourcePlugin
          .startAccessingSecurityScopedResourceWithFilePath(url);
      setState(() {
        _output += 'Has access: $hasAccess';
      });
    } catch (err) {
      setState(() {
        _output += 'Error: $err';
      });
    }
  }

  void _stopPath() {
    try {
      setState(() {
        _output = '';
      });
      if (_dir == null) {
        return;
      }
      final url = _isFilePath ? Uri.directory(_dir!).toString() : _dir!;
      _accessingSecurityScopedResourcePlugin
          .stopAccessingSecurityScopedResourceWithFilePath(url);
    } catch (err) {
      setState(() {
        _output += 'Error: $err';
      });
    }
  }
}
