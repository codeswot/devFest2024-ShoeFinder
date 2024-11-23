import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shoe_finder/view/result.dart';

class ColorSelectionScreen extends StatefulWidget {
  final String occasion;

  const ColorSelectionScreen({super.key, required this.occasion});

  @override
  State<ColorSelectionScreen> createState() => _ColorSelectionScreenState();
}

class _ColorSelectionScreenState extends State<ColorSelectionScreen> with TickerProviderStateMixin {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.black,
    Colors.white,
    Colors.purple,
    Colors.pink,
    Colors.orange
  ];
  final List<String> brands = ['Nike', 'Adidas', 'Gucci', 'Puma', 'Vans', 'Fila', 'Crocs', 'Converse'];
  final List<String> genders = ['Male', 'Female', 'Unisex'];

  Color? selectedColor;
  String? selectedBrand;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Colors & Brands')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'The amazing occasion is "${widget.occasion}"',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildGridSection(
                'Pick a Color that fits your mood',
                colors.map((color) {
                  return _buildSquareBox(
                    color: color,
                    isSelected: selectedColor == color,
                    onTap: () {
                      setState(() => selectedColor = color);
                    },
                  );
                }).toList(),
              ),
              _buildGridSection(
                'Pick a Brand',
                brands.map((brand) {
                  return _buildSquareBox(
                    label: brand,
                    isSelected: selectedBrand == brand,
                    onTap: () {
                      setState(() => selectedBrand = brand);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              _buildGridSection(
                'One more thing!',
                genders.map((gender) {
                  return _buildSquareBox(
                    label: gender,
                    isSelected: selectedGender == gender,
                    onTap: () {
                      setState(() => selectedGender = gender);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: selectedColor != null && selectedBrand != null && selectedGender != null
                    ? () {
                        // Navigate to ResultScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              occasion: widget.occasion,
                              color: selectedColor!,
                              brand: selectedBrand!,
                              gender: selectedGender!,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Find My Shoes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: children,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSquareBox({
    Color? color,
    String? label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color ?? Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color ?? Colors.black : Colors.black.withOpacity(0.5),
            width: isSelected ? 5 : 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          gradient: isSelected
              ? SweepGradient(
                  colors: colors.map((c) => c.withOpacity(0.6)).toList(),
                  startAngle: 0.0,
                  endAngle: 1.5 * pi,
                  stops: colors.map((c) => 0.2).toList(),
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

}
