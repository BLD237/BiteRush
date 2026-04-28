class BurgerProduct {
  const BurgerProduct({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.imageAsset,
    required this.categoryId,
  });

  final String id;
  final String title;
  final String subtitle;
  final double rating;
  final String imageAsset;
  final String categoryId;
}
