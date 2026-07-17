import 'package:url_launcher/url_launcher.dart';

class ExternalAppOpenService {
  ExternalAppOpenService._();

  static Future<void> call(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch dialer');
    }
  }

  static Future<void> email({
    required String email,
    String? subject,
    String? body,
  }) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch email app');
    }
  }

  static Future<void> sendMessage({
    required String phoneNumber,
    String message = '',
  }) async {
    try {
      final Uri uri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {'body': message},
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
