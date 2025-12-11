const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const OpenAI = require("openai");

admin.initializeApp();

// Define secret (it will read version 1 automatically)
const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

exports.classifyEmail = onCall(
  {
    region: "us-central1",
    secrets: [OPENAI_API_KEY],   // IMPORTANT
    timeoutSeconds: 30,
    memory: "512MB",
  },
  async (req) => {
    try {
      const apiKey = OPENAI_API_KEY.value();  // IMPORTANT FIX
      const client = new OpenAI({ apiKey }); // IMPORTANT FIX

      const { subject, body, from } = req.data;

      const prompt = `
Classify this email into one category: promotion, social, spam, or primary.
Subject: ${subject}
Body: ${body}
From: ${from}
      `;

      const completion = await client.chat.completions.create({
        model: "gpt-4o-mini",
        messages: [{ role: "user", content: prompt }],
        max_tokens: 10,
      });

      const label = completion.choices[0].message.content
        .trim()
        .toLowerCase();

      console.log("AI label:", label);

      return { label };
    } catch (error) {
      console.error("🔥 classifyEmail error:", error);
      throw new Error("classification_failed");
    }
  }
);
