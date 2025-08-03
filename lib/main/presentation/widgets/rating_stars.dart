import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20.0,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final stars = List<Widget>.generate(5, (index) {
      final starIndex = index + 1;
      if (rating >= starIndex) {
        return Icon(Icons.star, color: filledColor, size: size);
      } else if (rating >= starIndex - 0.5) {
        return Stack(
          children: [
            Icon(Icons.star, color: emptyColor, size: size),
            ClipRect(
              clipper: _HalfClipper(),
              child: Icon(Icons.star, color: filledColor, size: size),
            ),
          ],
        );
      } else {
        return Icon(Icons.star, color: emptyColor, size: size);
      }
    });

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...stars,
        Gap(4),
        Text(rating.toString(), style: TextStyle(color: darkMint)),
      ],
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => false;
}
