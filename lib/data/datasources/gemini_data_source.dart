import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiDataSource {
  Future<String> getExplanation({required String prompt}) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        maxOutputTokens: 200,
        temperature: 0.7,
      ),
    );
    final response = await model
        .generateContent([Content.text(prompt)])
        .timeout(const Duration(seconds: 15));
    return response.text?.trim() ?? '';
  }
}
