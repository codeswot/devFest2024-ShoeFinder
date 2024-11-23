import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String?> fetchSneaker({required String color, required String brand}) async {
  int randomIndex = Random().nextInt(3);
  final url = Uri.parse(
    'https://the-sneaker-database.p.rapidapi.com/search?page=1&limit=10&query=${Uri.encodeComponent('$color $brand')}',
  );

  final headers = {
    'x-rapidapi-host': 'the-sneaker-database.p.rapidapi.com',
    'x-rapidapi-key': 'daa5657604msh9f7799fe5d46194p123815jsn5be72bb93f11',
  };
// 9b01a4e00cmshf261ae2e27ecf52p141d0ajsn60f72e716b13
  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Extract the first result
      if (data['results'] != null && data['results'].isNotEmpty) {
        final firstItem = data['results'][randomIndex];
        final imageUrl = firstItem['image']?['original'];

        return imageUrl;
      } else {}
    } else {
      if (kDebugMode) {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }
  return null;
}
