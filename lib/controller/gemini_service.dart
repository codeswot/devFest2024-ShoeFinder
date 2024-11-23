import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _client;

  GeminiService(String apiKey)
      : _client = GenerativeModel(
          apiKey: apiKey,
          model: 'gemini-1.5-flash-latest',
        );

  Future<List<Shoe>> getRecommendations({
    required String occasion,
    required String color,
    required String brand,
    required String gender,
  }) async {
    final prompt = '''
    Suggest shoe recommendations based on the following criteria:
    - Occasion: $occasion
    - Preferred color: $color
    - Preferred brand: $brand
    - Gender: $gender
    Return a JSON array with each object containing the following fields: 
    "name" (string), "price" (string) in naira convert, and "image" (string with an image URL).
    make sure the imageURl is valid and points to an image that exists (generate the image and return as url).
    Only return valid JSON, without any surrounding text or formatting markers like backticks or "```json".
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _client.generateContent(content);

      if (response.candidates.isNotEmpty) {
        final parts = response.candidates.first.content.parts;
        return await parseShoes(parts, c: color, b: brand);
      } else {
        throw Exception('No recommendations received from Gemini.');
      }
    } catch (e) {
      throw Exception('Error fetching recommendations: $e');
    }
  }

  Future<List<Shoe>> parseShoes(List<Part> parts, {required String c, required String b}) async {
    try {
      final rawResponse = parts.map((part) => (part.toJson() as Map<String, dynamic>)['text'] as String).join();

      final cleanedResponse = rawResponse.replaceAll('```json', '').replaceAll('```', '').trim();

      final jsonList = jsonDecode(cleanedResponse) as List<dynamic>;

      return jsonList.map((json) {
        return Shoe.fromJson(json as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing recommendations: $e');
      }
      return [];
    }
  }
}

class Shoe {
  final String name;
  final String price;
  final String image;

  const Shoe({
    required this.name,
    required this.price,
    required this.image,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      name: json['name'] as String,
      price: json['price'] as String,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
    };
  }

  // copyWith
  Shoe copyWith({
    String? name,
    String? price,
    String? image,
  }) =>
      Shoe(
        name: name ?? this.name,
        price: price ?? this.price,
        image: image ?? this.image,
      );
}
