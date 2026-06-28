import 'package:url_launcher/url_launcher.dart';

class SupportService {
  SupportService._();

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
}
