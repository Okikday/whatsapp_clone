// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:openai_dart/openai_dart.dart';
// import 'package:test_app/common/const_ai_strings.dart';
//
// class ChatgptServices {
//   static final OpenAIClient openAi = OpenAIClient(apiKey: dotenv.env["CHATGPT_API_KEY"]);
//
//   static Stream<CreateChatCompletionStreamResponse> sendPrompt(String prompt) {
//     final Stream<CreateChatCompletionStreamResponse> response = openAi.createChatCompletionStream(
//       request: CreateChatCompletionRequest(
//           model: ChatCompletionModel.model(ChatCompletionModels.gpt4o),
//           messages: [
//             ChatCompletionMessage.user(content: ChatCompletionUserMessageContent.string(prompt))
//       ]),
//     );
//    return response;
//   }
// }
