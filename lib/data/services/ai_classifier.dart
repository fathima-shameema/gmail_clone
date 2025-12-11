import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AIClassifier {
  static final _functions = FirebaseFunctions.instanceFor(
    region: "us-central1",
  );
  static final _firestore = FirebaseFirestore.instance;

  static Future<String> classifyMail({
    required String messageId,
    required String subject,
    required String body,
    required String from,
    required String to,
  }) async {
    final callable = _functions.httpsCallable("classifyEmail");

    final result = await callable.call({
      "messageId": messageId,
      "subject": subject,
      "body": body,
      "from": from,
      "to": to,
    });

    log("Function result: ${result.data}");

    final data = Map<String, dynamic>.from(result.data);

    final label = data["label"] ?? "none";

    // Save to Firestore
    await _firestore.collection("mails").doc(messageId).update({
      "category": label,
    });

    return label;
  }
}
