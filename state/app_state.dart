

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
