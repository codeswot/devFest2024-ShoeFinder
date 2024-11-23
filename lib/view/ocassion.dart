import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shoe_finder/view/color_brand.dart';

class OccasionScreen extends StatelessWidget {
  final List<String> predefinedOccasions = ['Wedding', 'Party', 'Work', 'Gym', 'Casual', 'Beach', 'Technology'];

  OccasionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoe Finder'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 80),
              SizedBox(
                height: 150,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Hello, What\'s the Occasion?\n Let\'s find your perfect pair!',
                      textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your occasion...',
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ColorSelectionScreen(occasion: value),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Try Out Pre-defined Occasions',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: predefinedOccasions.map((occasion) {
                  return ActionChip(
                    label: Text(occasion),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ColorSelectionScreen(occasion: occasion),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
