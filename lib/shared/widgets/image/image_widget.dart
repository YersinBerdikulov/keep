import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/color_config.dart';

class ImageWidget extends StatelessWidget {
  final double width;
  final double height;
  final String? imageUrl;
  final Color? color;
  final double? borderRadius;
  final bool borderEnable;
  const ImageWidget({
    super.key,
    this.width = 42,
    this.height = 42,
    this.imageUrl,
    this.color,
    this.borderRadius,
    this.borderEnable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: borderEnable
            ? Border.all(color: ColorConfig.primarySwatch, width: 0.5)
            : null,
        borderRadius:
            borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
        color: color ?? ColorConfig.darkGrey,
        shape: borderRadius == null ? BoxShape.circle : BoxShape.rectangle,
        image: imageUrl != null && imageUrl != ''
            ? DecorationImage(
                image: CachedNetworkImageProvider(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
