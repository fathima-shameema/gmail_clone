const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();

exports.classifyEmail = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "Auth required");
  }

  const { mailId, subject, body, from } = data;

  if (!mailId) {
    throw new functions.https.HttpsError("invalid-argument", "mailId missing");
  }

  const apiKey = functions.config().gemini.key;

  const prompt = `
RETURN ONLY VALID JSON. NO TEXT OUTSIDE JSON. NO EXPLANATION. NO MARKDOWN.

You are an email classification engine for a Gmail-like app.
Classify the email into EXACTLY ONE category:

1. "promotion"
   - marketing, ads, sales, discounts, offers
   - newsletters, campaigns, product launches
   - messages urging purchase or subscription

2. "social"
   - personal communication
   - social media notifications (Instagram, Facebook, Twitter, LinkedIn)
   - friend requests, community updates, invitations

3. "spam"
   - scams, phishing, threats, malware
   - unknown senders with unsolicited ads
   - fake rewards, money requests, unsafe links

4. "primary"
   - normal personal/work mail
   - human-to-human communication
   - receipts, invoices, confirmations
   - anything NOT promotion/social/spam

Rules:
- ALWAYS return ONLY JSON.
- No markdown, no commentary.
- JSON format:

{
  "label": "promotion" | "social" | "spam" | "primary",
  "confidence": 0.0
}

Email:
From: ${from}
Subject: ${subject}
Body: """${body}"""

Return ONLY the JSON above.
`;

  try {
    const response = await axios.post(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + apiKey,
      { contents: [{ parts: [{ text: prompt }] }] },
      { headers: { "Content-Type": "application/json" } }
    );

    const output = response.data.candidates[0].content.parts[0].text.trim();

    let parsed;
    try {
      parsed = JSON.parse(output);
    } catch (err) {
      console.error("JSON parse failed — output was:", output);
      return { label: "primary", confidence: 0.2 };
    }

    await admin.firestore().collection("mails").doc(mailId).set({
      category: parsed.label,
      confidence: parsed.confidence,
    }, { merge: true });

    return parsed;

  } catch (err) {
    console.error(err);
    throw new functions.https.HttpsError("unknown", err.message);
  }
});
