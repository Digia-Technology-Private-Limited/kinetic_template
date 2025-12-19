import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import '../../core/theme/app_colors.dart';

class BlurhashImage extends StatelessWidget {
  final String imageUrl;
  final String? blurHash;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const BlurhashImage({
    super.key,
    required this.imageUrl,
    this.blurHash,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final widget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) {
        if (blurHash != null && blurHash!.isNotEmpty) {
          return BlurHash(
            hash: blurHash!,
            imageFit: fit,
          );
        }
        return Container(
          color: AppColors.bgLight2,
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary100,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => Container(
        color: AppColors.bgLight2,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: widget,
      );
    }

    return widget;
  }
}

