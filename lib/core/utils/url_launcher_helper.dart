import 'package:url_launcher/url_launcher.dart';

/// Utility class for URL launching operations
class UrlLauncherHelper {
  UrlLauncherHelper._();
  
  /// Launches a URL with error handling
  static Future<bool> launchURL(
    String urlString, {
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: mode);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Launches email with optional subject and body
  static Future<bool> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: [
        if (subject != null) 'subject=$subject',
        if (body != null) 'body=$body',
      ].join('&'),
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Launches phone dialer
  static Future<bool> launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
