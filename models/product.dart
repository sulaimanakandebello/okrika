// lib/models/product.dart
class Seller {
  final String username;
  final double rating; // 0..5
  final int ratingCount;
  final String? avatarUrl; // optional

  const Seller({
    required this.username,
    required this.rating,
    required this.ratingCount,
    this.avatarUrl,
  });
}

class Product {
  final String id;
  final String title;
  final String brand;
  final double price;
  final List<String> images;
  final String condition;
  final String size;
  final String colour;
  final String categoryPath;
  final String description;
  final Seller seller;
  final List<String> badges;
  final int likes;
  final bool likedByMe;
  final DateTime uploadedAt;

  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.images,
    required this.condition,
    required this.size,
    required this.colour,
    required this.categoryPath,
    required this.description,
    required this.seller,
    this.badges = const [],
    this.likes = 0,
    this.likedByMe = false,
    required this.uploadedAt,
  });

  Product copyWith({bool? likedByMe, int? likes}) {
    return Product(
      id: id,
      title: title,
      brand: brand,
      price: price,
      images: images,
      condition: condition,
      size: size,
      colour: colour,
      categoryPath: categoryPath,
      description: description,
      seller: seller,
      badges: badges,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
      uploadedAt: uploadedAt,
    );
  }
}
