import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:accessing_security_scoped_resource/accessing_security_scoped_resource.dart';

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
  final _accessingSecurityScopedResourcePlugin =
      AccessingSecurityScopedResource();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                  onPressed: _selectDir,
                  child: const Text('Select a directory')),
              if (_dir != null) Text(_dir!),
              _sep(),
              OutlinedButton(
                  onPressed: _dir != null ? _start : null,
                  child:
                      const Text('startAccessingSecurityScopedResource (URL)')),
              _sep(),
              OutlinedButton(
                  onPressed: _dir != null ? _stop : null,
                  child:
                      const Text('stopAccessingSecurityScopedResource (URL)')),
              _sep(),
              OutlinedButton(
                  onPressed: _dir != null ? _startPath : null,
                  child: const Text(
                      'startAccessingSecurityScopedResource (FilePath)')),
              _sep(),
              OutlinedButton(
                  onPressed: _dir != null ? _stopPath : null,
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
      var dir = await FilePicker.platform.getDirectoryPath();
      if (dir == null) {
        return;
      }
      setState(() {
        _dir = dir;
      });
    } catch (err) {
      setState(() {
        _output = err.toString();
      });
    }
  }

  void _start() async {
    if (_dir == null) {
      return;
    }
    final hasAccess = await _accessingSecurityScopedResourcePlugin
        .startAccessingSecurityScopedResourceWithURL(Uri.directory(_dir!));
    setState(() {
      _output = 'Has access: $hasAccess';
    });
  }

  void _stop() {
    if (_dir == null) {
      return;
    }
    _accessingSecurityScopedResourcePlugin
        .stopAccessingSecurityScopedResourceWithURL(Uri.directory(_dir!));
    setState(() {
      _output = '';
    });
  }

  void _startPath() async {
    if (_dir == null) {
      return;
    }
    final hasAccess = await _accessingSecurityScopedResourcePlugin
        .startAccessingSecurityScopedResourceWithFilePath(_dir!);
    setState(() {
      _output = 'Has access: $hasAccess';
    });
  }

  void _stopPath() {
    if (_dir == null) {
      return;
    }
    _accessingSecurityScopedResourcePlugin
        .stopAccessingSecurityScopedResourceWithFilePath(_dir!);
    setState(() {
      _output = '';
    });
  }
}
