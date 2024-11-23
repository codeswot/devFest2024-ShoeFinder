import 'package:cached_network_image/cached_network_image.dart';
import 'package:colornames/colornames.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoe_finder/controller/gemini_service.dart';
import 'package:shoe_finder/view/shoe_detail.dart';

class ResultScreen extends StatefulWidget {
  final String occasion;
  final Color color;
  final String brand;
  final String gender;

  const ResultScreen({
    super.key,
    required this.occasion,
    required this.color,
    required this.brand,
    required this.gender,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  static String apiKey = const String.fromEnvironment("API_KEY");

  final geminiService = GeminiService(apiKey);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shoe Recommendations')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.occasion,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  height: 30,
                  child: VerticalDivider(color: Colors.red, thickness: 2, width: 2),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 8),
                    _buildRect(label: widget.color.colorName, color: widget.color),
                    const SizedBox(width: 5),
                    _buildRect(label: widget.brand, color: Colors.blue),
                    const SizedBox(width: 5),
                    _buildRect(label: widget.gender, color: Colors.green),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Shoe>>(
                  // future: null,
                  future: geminiService.getRecommendations(
                    occasion: widget.occasion,
                    color: widget.color.colorName,
                    brand: widget.brand,
                    gender: widget.gender,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingList();
                    }
                    final shoes = snapshot.data ?? [];
                    if (shoes.isEmpty) {
                      return NoShoesFound(
                        onTryAgain: () => Navigator.popUntil(context, (route) => route.isFirst),
                      );
                    }

                    return ListView.builder(
                      itemCount: shoes.length,
                      itemBuilder: (context, index) {
                        final shoe = shoes[index];
                        final image = shoe.image;
                        final id = index + 1;
                        return ListTile(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShoeDetail(
                                id: id,
                                shoe,
                                color: widget.color,
                                brand: widget.brand,
                                gender: widget.gender,
                                occasion: widget.occasion,
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Hero(
                              tag: "${image}_$id",
                              child: CachedNetworkImage(
                                imageUrl: image,
                                imageBuilder: (context, imageProvider) => Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          title: Hero(
                              tag: "${shoe.name}_$id",
                              child: Material(
                                type: MaterialType.transparency,
                                child: Text(shoe.name),
                              )),
                          trailing: Text(
                            shoe.price.toString(),
                          ),
                        ).animate().fadeIn();
                      },
                    );
                  }),
            ),
          ],
        ).animate().fadeIn(),
      ),
    );
  }

  Widget _buildRect({
    Color? color,
    String? label,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 75,
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color != null ? color.withOpacity(0.4) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color ?? Colors.black.withOpacity(0.2),
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Text(
          label ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}

class LoadingList extends StatelessWidget {
  const LoadingList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: Colors.white,
            ),
            title: Container(
              width: double.infinity,
              height: 10,
              color: Colors.white,
            ),
            subtitle: Container(
              width: 100,
              height: 10,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class NoShoesFound extends StatelessWidget {
  final VoidCallback onTryAgain;

  const NoShoesFound({super.key, required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 28, color: Colors.black),
          children: [
            const TextSpan(text: 'No shoes found for the given criteria. '),
            TextSpan(
              text: 'Please try a different combination.',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTryAgain,
            ),
          ],
        ),
      ),
    );
  }
}
