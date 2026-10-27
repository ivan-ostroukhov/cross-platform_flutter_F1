import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../common/utils/f1_media.dart';

class DriverHeroImage extends StatelessWidget {
  final String driverId;
  final BoxFit fit;
  final Alignment alignment;

  const DriverHeroImage({
    super.key,
    required this.driverId,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    final localPath = F1Media.getLocalAssetPath(driverId);

    Widget imageWidget;

    if (localPath != null) {
      imageWidget = Image.asset(
        localPath,
        fit: fit,
        alignment: alignment,
        errorBuilder: (_, __, ___) => _fallbackIcon(),
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: F1Media.getDriverImageUrl(driverId),
        httpHeaders: F1Media.defaultHeaders,
        fit: fit,
        alignment: alignment,
        placeholder: (_, __) => const SizedBox.shrink(),
        errorWidget: (_, __, ___) => _fallbackIcon(),
      );
    }

    return ShaderMask(
      shaderCallback: (rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.65, 0.90, 1.0],
          colors: [
            Colors.white,
            Colors.white,
            Colors.white24,
            Colors.transparent,
          ],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: imageWidget,
    );
  }

  Widget _fallbackIcon() {
    return Icon(
      Icons.sports_motorsports_rounded,
      size: 160,
      color: Colors.white.withValues(alpha: 0.35),
    );
  }
}