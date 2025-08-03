class Place {
  final String image;
  final String name;
  final double rating;
  final String cuisine;
  final double distance;
  final DateTime closeTime;
  final String type;
  final bool isOpen;
  final bool isLiked;
  final int likeCount;

  const Place({
    required this.image,
    required this.name,
    required this.rating,
    required this.cuisine,
    required this.distance,
    required this.closeTime,
    required this.type,
    required this.isOpen,
    required this.isLiked,
    required this.likeCount,
  });
}
