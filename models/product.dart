import 'package:flutter_okr/models/seller.dart';

class Product {
  final String id;
  final String title;
  final String brand;
  final double price;
  final List<String> images;

  final String condition;
  final String size;
  final String colour;
  final String categoryPath; // e.g. "Women > Clothing > Jeans"

  final String description;
  final Seller seller;

  final List<String> badges;
  final DateTime uploadedAt;

  // mutable-ish ui fields
  final int likes;
  final bool likedByMe;

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
    required this.badges,
    required this.uploadedAt,
    this.likes = 0,
    this.likedByMe = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? brand,
    double? price,
    List<String>? images,
    String? condition,
    String? size,
    String? colour,
    String? categoryPath,
    String? description,
    Seller? seller,
    List<String>? badges,
    DateTime? uploadedAt,
    int? likes,
    bool? likedByMe,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      images: images ?? this.images,
      condition: condition ?? this.condition,
      size: size ?? this.size,
      colour: colour ?? this.colour,
      categoryPath: categoryPath ?? this.categoryPath,
      description: description ?? this.description,
      seller: seller ?? this.seller,
      badges: badges ?? this.badges,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}
