/*
import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/products_repository.dart';

class AppState extends ChangeNotifier {
  AppState(this._repo);

  final ProductsRepository _repo;

  // Feed
  final List<Product> _feed = [];
  List<Product> get feed => List.unmodifiable(_feed);

  bool _loading = false;
  bool get loading => _loading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _page = 1;

  Future<void> loadInitial({String? category, String? query}) async {
    if (_loading) return;
    _loading = true;
    notifyListeners();

    _feed.clear();
    _page = 1;
    _hasMore = true;

    final items = await _repo.fetchFeed(
      page: 1,
      category: category,
      query: query,
    );
    _feed.addAll(items);
    _page = 2;
    _hasMore = items.isNotEmpty;
    _loading = false;
    notifyListeners();
  }

  Future<void> loadMore({String? category, String? query}) async {
    if (_loading || !_hasMore) return;
    _loading = true;
    notifyListeners();

    final items = await _repo.fetchFeed(
      page: _page,
      category: category,
      query: query,
    );
    _feed.addAll(items);
    _page += 1;
    _hasMore = items.isNotEmpty;
    _loading = false;
    notifyListeners();
  }

  Future<void> toggleLike(String productId) async {
    final idx = _feed.indexWhere((p) => p.id == productId);
    if (idx != -1) {
      // optimistic update
      final p = _feed[idx];
      final optimistic = p.copyWith(
        likedByMe: !p.likedByMe,
        likes: p.likes + (p.likedByMe ? -1 : 1),
      );
      _feed[idx] = optimistic;
      notifyListeners();
    }
    try {
      final updated = await _repo.toggleLike(productId);
      if (idx != -1) {
        _feed[idx] = updated;
        notifyListeners();
      }
    } catch (_) {
      // roll back if needed (skipped for brevity)
    }
  }

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
    final prod = await _repo.createListing(
      title: title,
      price: price,
      categoryPath: categoryPath,
      brand: brand,
      condition: condition,
      size: size,
      colour: colour,
      description: description,
      images: images,
    );
    _feed.insert(0, prod);
    notifyListeners();
    return prod;
  }
}
*/

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/fake_products_repository.dart';

class AppState extends ChangeNotifier {
  final FakeProductsRepository repo;

  AppState({required this.repo});

  final List<Product> _feed = [];
  bool _loading = false;

  List<Product> get feed => List.unmodifiable(_feed);
  bool get loading => _loading;

  Future<void> loadInitial() async {
    if (_loading || _feed.isNotEmpty) return;
    _loading = true;
    notifyListeners();

    // Fake async fetch (you can add a delay if you want)
    final items = repo.fetchFeed();
    _feed
      ..clear()
      ..addAll(items);

    _loading = false;
    notifyListeners();
  }

  void toggleLike(String productId) {
    final i = _feed.indexWhere((p) => p.id == productId);
    if (i == -1) return;
    final p = _feed[i];
    final liked = !p.likedByMe;
    _feed[i] = p.copyWith(
      likedByMe: liked,
      likes: (p.likes + (liked ? 1 : -1)).clamp(0, 1 << 31),
    );
    notifyListeners();
  }
}
