import 'package:cached_network_image/cached_network_image.dart';
import 'package:colornames/colornames.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shoe_finder/controller/gemini_service.dart';
import 'package:shoe_finder/controller/http_service.dart';

class ShoeDetail extends StatefulWidget {
  const ShoeDetail(
    this.shoe, {
    super.key,
    required this.color,
    required this.brand,
    required this.gender,
    required this.occasion,
    required this.id,
  });
  final int id;
  final Shoe shoe;
  final Color color;
  final String brand;
  final String gender;
  final String occasion;

  @override
  State<ShoeDetail> createState() => _ShoeDetailState();
}

class _ShoeDetailState extends State<ShoeDetail> {
  Shoe? shoe;
  @override
  void initState() {
    super.initState();
    updateImage();
  }

  updateImage() async {
    final image = await fetchSneaker(color: widget.color.colorName, brand: widget.brand);
    if (image != null) {
      shoe = widget.shoe.copyWith(image: image);
      if (kDebugMode) {
        print("NEW SHOW ${shoe?.image}");
      }
    } else {
      shoe = widget.shoe;
      if (kDebugMode) {
        print("OLD SHOW ${shoe?.image}");
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "${widget.shoe.image}_${widget.id}",
              child: CachedNetworkImage(
                imageUrl: shoe?.image ?? widget.shoe.image,
                height: 350,
                imageBuilder: (context, imageProvider) => Container(
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
            const SizedBox(height: 16),
            Hero(
              tag: "${widget.shoe.name}_${widget.id}",
              child: Material(
                child: Text(
                  widget.shoe.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.shoe.price.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRect(label: widget.occasion, color: Colors.white),
                _buildRect(label: widget.color.colorName, color: widget.color),
                _buildRect(label: widget.brand, color: Colors.blue),
                _buildRect(label: widget.gender, color: Colors.green),
              ],
            ),
          ],
        ),
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
          color: Colors.black.withOpacity(0.2),
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
