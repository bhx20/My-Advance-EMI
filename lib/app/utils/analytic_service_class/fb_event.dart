import 'package:flutter/services.dart';

class FacebookEvents {
  static const MethodChannel _channel = MethodChannel('facebook_events');

  // Log an event with the given name and parameters
  static Future<String> logEvent(
      String eventName, Map<String, dynamic> parameters) async {
    try {
      final String result = await _channel.invokeMethod('logEvent', {
        'eventName': eventName,
        'parameters': parameters,
      });
      return result; // Return the success message from native code
    } on PlatformException catch (e) {
      print("Failed to log event: '${e.message}'.");
      return 'Failed to log event'; // Return a failure message
    }
  }

  // Initialize the Facebook SDK with the given app ID and token
  static Future<String> initialize(String appId, String token) async {
    try {
      final String result = await _channel.invokeMethod('initialize', {
        'appId': appId,
        'token': token,
      });
      return result; // Return the success message from native code
    } on PlatformException catch (e) {
      print("Failed to initialize Facebook SDK: '${e.message}'.");
      return 'Failed to initialize Facebook SDK'; // Return a failure message
    }
  }
}
