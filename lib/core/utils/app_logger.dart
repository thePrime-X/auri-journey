import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void info(String message, {String tag = 'Auri'}) {
    _log('INFO', message, tag);
  }

  static void success(String message, {String tag = 'Auri'}) {
    _log('SUCCESS', message, tag);
  }

  static void warning(String message, {String tag = 'Auri'}) {
    _log('WARNING', message, tag);
  }

  static void error(
    String message, {
    String tag = 'Auri',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;

    developer.log(
      '❌ [$tag] $message',
      name: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _log(String level, String message, String tag) {
    if (!kDebugMode) return;

    final icon = switch (level) {
      'INFO' => 'ℹ️',
      'SUCCESS' => '✅',
      'WARNING' => '⚠️',
      _ => '•',
    };

    developer.log('$icon [$tag] $message', name: tag);
  }
}
