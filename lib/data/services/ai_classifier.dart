// // lib/data/services/ai_classifier.dart
// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:cloud_functions/cloud_functions.dart';

// class CloudFunctionsAIClassifier {
//   static final _functions = FirebaseFunctions.instance;
//   static Future<String> classify({
//     required String mailId,
//     required String subject,
//     required String body,
//     required String from,
//     Duration timeout = const Duration(seconds: 15),
//   }) async {
//     try {
//       final callable = _functions.httpsCallable('classifyEmail');

//       final raw = await callable
//           .call(<String, dynamic>{
//             'mailId': mailId,
//             'subject': subject,
//             'body': body,
//             'from': from,
//           })
//           .timeout(timeout);

//       final data = raw.data;

//       String label = 'none';
//       double confidence = 0.0;

//       if (data == null) {
//         label = 'none';
//       } else if (data is String) {
//         try {
//           final parsed = jsonDecode(data);
//           label = (parsed['label'] ?? parsed['category'] ?? 'none').toString();
//           confidence =
//               (parsed['confidence'] ?? 0.0) is num
//                   ? (parsed['confidence'] as num).toDouble()
//                   : double.tryParse((parsed['confidence'] ?? '0').toString()) ??
//                       0.0;
//         } catch (_) {
//           label = data.toLowerCase();
//         }
//       } else if (data is Map) {
//         label = (data['label'] ?? data['category'] ?? 'none').toString();
//         final confRaw = data['confidence'];
//         if (confRaw is num) {
//           confidence = confRaw.toDouble();
//         } else if (confRaw is String) {
//           confidence = double.tryParse(confRaw) ?? 0.0;
//         }
//       } else {
//         label = 'none';
//       }

//       label = _normalizeLabel(label);

//       return label;
//     } on TimeoutException {
//       log('time out exception error');

//       return 'none';
//     } on FirebaseFunctionsException {
//       log('firebase function error');
//       return 'none';
//     } catch (e) {
//       log('ai classification final error');

//       return 'none';
//     }
//   }

//   static String _normalizeLabel(String raw) {
//     final l = raw.trim().toLowerCase();
//     if (l == 'promotions' || l == 'promotion' || l == 'promo')
//       return 'promotion';
//     if (l == 'social' || l == 'socials') return 'social';
//     if (l == 'spam' || l == 'junk') return 'spam';
//     if (l == 'primary' || l == 'inbox' || l == 'none') return 'none';
//     if (l.contains('promot')) return 'promotion';
//     if (l.contains('primary')) return 'none';
//     return 'none';
//   }
// }
class ManualClassifier {
  static String classify({
    required String subject,
    required String body,
    required String from,
  }) {
    final text = "$subject $body".toLowerCase();

    // ---------- PROMOTION ----------
    const promoKeywords = [
      "sale",
      "discount",
      "offer",
      "deal",
      "limited time",
      "buy now",
      "shop",
      "store",
      "coupon",
      "save",
      "exclusive",
      "subscribe",
      "try now",
      "upgrade",
      "special price",
    ];

    if (_containsAny(text, promoKeywords)) {
      return "promotion";
    }

    // ---------- SOCIAL ----------
    const socialKeywords = [
      "follow",
      "liked your post",
      "commented",
      "tagged you",
      "friend request",
      "community",
      "invitation",
      "greetings",
      "instagram",
      "facebook",
      "twitter",
      "linkedin",
      "meetup",
      "group update",
    ];

    if (_containsAny(text, socialKeywords)) {
      return "social";
    }

    // ---------- SPAM ----------
    const spamKeywords = [
      "winner",
      "lottery",
      "claim prize",
      "urgent action",
      "bank update",
      "verify your account",
      "password reset scam",
      "malware",
      "unusual activity",
      "threat",
      "money transfer",
      "click here",
      "you won",
      "investment",
      "crypto",
      "illegal",
    ];

    if (_containsAny(text, spamKeywords)) {
      return "spam";
    }

    // ---------- PRIMARY ----------
    return "none"; // Gmail's "Primary"
  }

  static bool _containsAny(String text, List<String> list) {
    for (final word in list) {
      if (text.contains(word)) return true;
    }
    return false;
  }
}
