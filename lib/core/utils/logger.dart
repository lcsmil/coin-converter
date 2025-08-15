import 'dart:convert';
import 'dart:developer' as developer;

/// Global flag to enable or disable API logging
bool enableApiLogging = true;

/// A utility class for logging API requests and responses
class ApiLogger {
  /// Enable or disable API logging
  static void setLoggingEnabled(bool enabled) {
    enableApiLogging = enabled;
  }
  
  /// Check if logging is enabled
  static bool get isLoggingEnabled => enableApiLogging;
  /// Log an API request with its URL and optional body
  static void logRequest(Uri url, {Map<String, dynamic>? body}) {
    if (!enableApiLogging) return;
    developer.log(
      'API REQUEST: ${url.toString()}',
      name: 'ApiLogger',
    );
    
    if (body != null) {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(body);
      developer.log(
        'REQUEST BODY:\n$prettyJson',
        name: 'ApiLogger',
      );
    }
  }

  /// Log an API response with status code and body
  static void logResponse(int statusCode, String body) {
    if (!enableApiLogging) return;
    developer.log(
      'API RESPONSE [Status: $statusCode]',
      name: 'ApiLogger',
    );
    
    try {
      // Try to parse and pretty print JSON
      final dynamic jsonData = json.decode(body);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
      developer.log(
        'RESPONSE BODY:\n$prettyJson',
        name: 'ApiLogger',
      );
    } catch (e) {
      // If not valid JSON, log as plain text
      developer.log(
        'RESPONSE BODY (not JSON):\n$body',
        name: 'ApiLogger',
      );
    }
  }

  /// Log an API error
  static void logError(String message, Object error) {
    if (!enableApiLogging) return;
    developer.log(
      'API ERROR: $message\n$error',
      name: 'ApiLogger',
      error: error,
    );
  }
}
