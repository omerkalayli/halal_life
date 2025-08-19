import 'dart:typed_data';
import 'package:cloudflare_r2/cloudflare_r2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:halal_life/constants.dart';

class CloudFlareDiskCachedImage extends StatefulWidget {
  final String placeId;
  final String photoReference;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? type;

  const CloudFlareDiskCachedImage({
    super.key,
    required this.placeId,
    required this.photoReference,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.type,
  });

  @override
  State<CloudFlareDiskCachedImage> createState() =>
      _CloudFlareDiskCachedImageState();
}

class _CloudFlareDiskCachedImageState extends State<CloudFlareDiskCachedImage> {
  Uint8List? _imageBytes;
  bool _loading = true;
  bool _error = false;

  static final _cacheManager = CacheManager(
    Config('cloudflareCache', maxNrOfCacheObjects: 10000),
  );

  Future<void> _loadImage() async {
    final cacheKey = '${widget.placeId}_${widget.photoReference}.jpg';

    try {
      final cachedFile = await _cacheManager.getFileFromCache(cacheKey);
      if (cachedFile != null) {
        _imageBytes = await cachedFile.file.readAsBytes();
        _loading = false;
        if (!mounted) return;
        setState(() {});
        return;
      }

      final bytes = await CloudFlareR2.getObject(
        bucket: dotenv.env['BUCKET_NAME'] ?? '',
        objectName: cacheKey,
      );
      _imageBytes = Uint8List.fromList(bytes);

      await _cacheManager.putFile(cacheKey, _imageBytes!);

      _loading = false;
      setState(() {});
    } catch (e) {
      _error = true;
      _loading = false;
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    if (widget.type == "restaurant") {
      iconData = Icons.restaurant_menu_rounded;
    } else if (widget.type == "cafe") {
      iconData = Icons.local_cafe;
    } else if (widget.type == "store" ||
        widget.type == "supermarket" ||
        widget.type == "grocery_or_supermarket") {
      iconData = Icons.store;
    } else if (widget.type == "bakery") {
      iconData = Icons.bakery_dining;
    } else {
      iconData = Icons.place;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.fastOutSlowIn,
      switchOutCurve: Curves.easeOut,
      child: _loading || _error || _imageBytes == null
          ? Container(
              key: const ValueKey('placeholder'),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: lightMint),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(iconData, size: 44, color: lightMint),
            )
          : ClipRRect(
              key: const ValueKey('image'),
              borderRadius: BorderRadius.circular(2),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.memory(_imageBytes!, fit: widget.fit),
              ),
            ),
    );
  }
}

class CloudFlareSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const CloudFlareSkeleton({super.key, this.width = 44, this.height = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
        border: Border.all(width: 2, color: lightMint),
      ),
    );
  }

  /// Statik çağrı için
  static Widget empty({double width = 44, double height = 44}) {
    return CloudFlareSkeleton(width: width, height: height);
  }
}
