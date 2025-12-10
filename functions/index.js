// functions/index.js  (Firebase Functions v2 syntax)

const { onCall } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const { OpenAIApi, Configuration } = require("openai");

admin.initializeApp();

// Load secret from Secret Manager
const OPENAI_API_KEY = defineSecret("OPENAI_API_KEY");

exports.classifyEmail = onCall(
  { secrets: [OPENAI_API_KEY] },
  async (request) => {
    const data = request.data;
    
    const subject = data.subject || "";
    const body = data.body || "";
    const from = data.from || "";
    const to = data.to || "";
    const messageId = data.messageId || "";

    const text = `Subject: ${subject}\nFrom: ${from}\nTo: ${to}\n\n${body}`;

    // Read secret value
    const apiKey = OPENAI_API_KEY.value();
    const openai = new OpenAIApi(new Configuration({ apiKey }));

    // Moderation check
    try {
      const mod = await openai.createModeration({
        model: "omni-moderation-latest",
        input: text,
      });

      if (mod?.data?.results?.[0]?.flagged) {
        return {
          label: "spam",
          confidence: 0.99,
          explanation: "Moderation flagged content",
        };
      }
    } catch (err) {
      console.log("Moderation error:", err);
    }

    const systemPrompt = `You are an email classifier. Return ONLY JSON: {"label": "...", "confidence": 0.0}. 
    Valid labels: "promotion", "social", "spam", "none".`;
    
    const userPrompt = `
    Classify the following email ONLY as: promotion, social, spam.
    If it does not fit these 3 categories, return {"label":"none","confidence":0.0}.
    
    Email:
    ${text}
    
    Return ONLY JSON.
    `.trim();
    
    const resp = await openai.createChatCompletion({
      model: "gpt-3.5-turbo",
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: userPrompt },
      ],
      temperature: 0.0,
      max_tokens: 200,
    });

    let output = resp.data.choices[0].message.content;

    try {
      return JSON.parse(output);
    } catch (err) {
      const match = output.match(/\{[\s\S]*\}/);
      if (match) return JSON.parse(match[0]);
      return {
        label: "primary",
        confidence: 0.5,
        explanation: "Failed to parse output",
      };
    }
  }
);
