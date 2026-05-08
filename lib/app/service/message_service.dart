import 'package:url_launcher/url_launcher.dart';

class MessageService {
  MessageService._();

  static Future<void> sendMessage({
    required String phoneNumber,
    String message = '',
  }) async {
    try {
      final Uri uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {
          'body': message,
        },
      );

      final bool launched = await launchUrl(uri);

      if (!launched) {
        throw Exception("Could not open message app");
      }
    } catch (e) {
      throw Exception("Message Service Error: $e");
    }
  }
}