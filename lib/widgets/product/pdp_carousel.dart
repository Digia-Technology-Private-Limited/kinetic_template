import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import '../../core/theme/app_colors.dart';

class PDPCarousel extends StatefulWidget {
  final List<String> imageUrls;

  const PDPCarousel({super.key, required this.imageUrls});

  @override
  State<PDPCarousel> createState() => _PDPCarouselState();
}

class _PDPCarouselState extends State<PDPCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 300, // Adjust based on design
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return OctoImage(
                image: NetworkImage(widget.imageUrls[index]),
                fit: BoxFit
                    .contain, // Contain usually better for PDP to show full item
                progressIndicatorBuilder: (context, progress) =>
                    const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image)),
              );
            },
          ),
        ),
        if (widget.imageUrls.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.imageUrls.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? AppColors.primary100
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
