import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../globle_widget.dart';

class NetWorkImage extends StatelessWidget {
  final Color? color;
  final BlendMode? blendMode;
  final double? width;
  final double? height;
  final String imageUrl;
  final BoxFit? fit;
  const NetWorkImage(this.imageUrl,
      {super.key,
      this.color,
      this.blendMode,
      this.width,
      this.height,
      this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: key,
      color: color,
      colorBlendMode: blendMode,
      width: width,
      height: height,
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, _) => const SimmerLoader(),
      errorWidget: (context, url, error) => _placeholderImage(),
    );
  }

  Widget _placeholderImage() {
    return Image.asset(
      "assets/images/placeholder.png",
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      color: color,
      colorBlendMode: blendMode,
    );
  }
}
