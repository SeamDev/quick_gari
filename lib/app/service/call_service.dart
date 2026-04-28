import 'package:url_launcher/url_launcher.dart';

class PhoneCallService {
  PhoneCallService._();

  static Future<void> call(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch dialer');
    }
  }
}
