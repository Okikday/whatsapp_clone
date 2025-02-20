import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiServices {
  static String geminiApiKey = dotenv.env["GEMINI_API_KEY"] ?? "";
  static final GenerativeModel gemini = GenerativeModel(model: "gemini-2.0-flash", apiKey: geminiApiKey);

  // Will adapt the prompt to suit the sign in/login input
  static Stream<GenerateContentResponse> sendPrompt({required List<Content> content}) {
    return gemini.generateContentStream(
        [
      Content("model", [
        TextPart(
          "I'm an expert on health. "
              "I'm assisting in the categories: "
              "'Pregnant mothers', 'Nursing mother', "
              "'Doctors' and 'Guest that want's to learn about pregnant/nursing mother'. "
              "I'll keep answers short, precise and straightforward as possible. "
              "I won't hallucinate. I'll priortize important details",
        ),
      ]),
      ...content,
    ],
      safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high)
      ]
    );
  }

  static Stream<GenerateContentResponse> startChat() {
    final chat = gemini.startChat(safetySettings: [SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high)]);
    return chat.sendMessageStream(
      Content.system(
        "I'm an expert on health. I'm assisting in the categories: 'Pregnant mothers', 'Nursing mother', 'Doctors' and 'Guest that want's to learn about pregnant/nursing mother'. You'd start the chat. You'll ask the user what or how you can help them.",
      ),
    );
  }
}
