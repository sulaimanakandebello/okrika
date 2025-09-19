import 'dart:math';
import '../models/product.dart';
import '../models/seller.dart';
import 'products_repository.dart';

class ProductsRepositoryFake implements ProductsRepository {
  final _rnd = Random();

  // In-memory DB
  final List<Product> _db = [
    Product(
      id: '1',
      title: 'Nike Tee',
      brand: 'Nike',
      price: 17.00,
      images: const [
        'https://images.unsplash.com/photo-1523381294911-8d3cead13475?w=1200',
      ],
      condition: 'New with tags',
      size: 'M',
      colour: 'Black',
      categoryPath: 'Men > Tops',
      description: 'Lightweight cotton tee.',
      seller: const Seller(username: 'theslyman', rating: 5, ratingCount: 1027),
      badges: const ['Speedy Shipping'],
      uploadedAt: DateTime.now().subtract(const Duration(minutes: 33)),
      likes: 17,
      likedByMe: false,
    ),
    Product(
      id: '2',
      title: 'Minimal Shirt',
      brand: 'COS',
      price: 20.00,
      images: const [
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=1200',
      ],
      condition: 'New without tags',
      size: 'M',
      colour: 'White',
      categoryPath: 'Men > Tops',
      description: 'Crisp, minimal shirt.',
      seller: const Seller(username: 'theslyman', rating: 5, ratingCount: 1027),
      badges: const ['Speedy Shipping'],
      uploadedAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 79,
      likedByMe: false,
    ),
    // add more seeds as needed...
  ];

  @override
  Future<List<Product>> fetchFeed({
    int page = 1,
    int pageSize = 20,
    String? category,
    String? query,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250)); // fake latency
    Iterable<Product> items = _db;

    if (category != null && category.isNotEmpty) {
      items = items.where((p) => p.categoryPath.contains(category));
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      items = items.where(
        (p) =>
            p.title.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q),
      );
    }

    final start = (page - 1) * pageSize;
    final end = min(start + pageSize, items.length);
    final list = items.toList();
    if (start >= list.length) return [];
    return list.sublist(start, end);
  }

  @override
  Future<Product> toggleLike(String productId) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final idx = _db.indexWhere((p) => p.id == productId);
    if (idx == -1) throw StateError('Product not found');
    final p = _db[idx];
    final nowLiked = !p.likedByMe;
    final updated = p.copyWith(
      likedByMe: nowLiked,
      likes: p.likes + (nowLiked ? 1 : -1),
    );
    _db[idx] = updated;
    return updated;
  }

  @override
  Future<Product> createListing({
    required String title,
    required double price,
    required String categoryPath,
    String brand = '—',
    String condition = 'Used - good',
    String size = '—',
    String colour = '—',
    String description = '',
    List<String> images = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final prod = Product(
      id: id,
      title: title,
      brand: brand == '—' ? title.split(' ').first : brand,
      price: price,
      images: images.isEmpty
          ? const [
              'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=1200',
            ]
          : images,
      condition: condition,
      size: size,
      colour: colour,
      categoryPath: categoryPath,
      description: description,
      seller: const Seller(username: 'me', rating: 5, ratingCount: 3),
      badges: const [],
      uploadedAt: DateTime.now(),
      likes: 0,
      likedByMe: false,
    );
    _db.insert(0, prod);
    return prod;
  }
}
