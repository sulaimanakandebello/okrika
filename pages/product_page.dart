import 'package:flutter/material.dart';
import 'package:flutter_okr/models/seller.dart';
import '../models/product.dart'; // <-- your single source of truth
import 'make_offer_page.dart';
import 'checkout_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    super.key,
    required this.product,
    this.sellersOtherItems,
    this.similarItems,
  });

  final Product product;
  final List<Product>? sellersOtherItems;
  final List<Product>? similarItems;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _pageCtrl = PageController();
  int _page = 0;

  late int _likes;
  late bool _liked;

  @override
  void initState() {
    super.initState();
    _likes = widget.product.likes;
    _liked =
        widget.product.likedByMe; // if you don’t have this field, set false
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes = (_likes + (_liked ? 1 : -1)).clamp(0, 1 << 31);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final avatar = p.seller.avatarUrl ?? '';

    final others = widget.sellersOtherItems ?? _demoProductsForSeller(p);
    final similar = widget.similarItems ?? _demoSimilarProducts(p);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // ------------------ images ------------------
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageCtrl,
                    itemCount: p.images.isEmpty ? 1 : p.images.length,
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (_, i) {
                      final url = p.images.isEmpty ? null : p.images[i];
                      return url == null
                          ? const ColoredBox(color: Color(0xFFEFEFEF))
                          : Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const ColoredBox(color: Color(0xFFEFEFEF)),
                            );
                    },
                  ),
                  Positioned(
                    bottom: 14,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        (p.images.isEmpty ? 1 : p.images.length),
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: _page == i
                                ? Colors.white
                                : Colors.white.withOpacity(.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // like bubble
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: _toggleLike,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _liked ? Icons.favorite : Icons.favorite_border,
                              color: _liked ? Colors.red : Colors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$_likes',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ------------------ seller row ------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: cs.primaryContainer,
                    backgroundImage: avatar.isNotEmpty
                        ? NetworkImage(avatar)
                        : null,
                    child: avatar.isEmpty
                        ? Text(
                            (p.seller.username.isNotEmpty
                                    ? p.seller.username[0]
                                    : '?')
                                .toUpperCase(),
                            style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.seller.username,
                          style: t.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < p.seller.rating.round()
                                    ? Icons.star
                                    : Icons.star_border,
                                size: 18,
                                color: Colors.amber[700],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(${p.seller.ratingCount})',
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: BorderSide(color: cs.outline),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Ask seller'),
                  ),
                ],
              ),
            ),
          ),

          if (p.badges.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: p.badges
                      .map(
                        (b) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 18,
                                color: cs.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                b,
                                style: TextStyle(color: cs.primary, height: 1),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: Divider(height: 1)),

          // ------------------ title & price ------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: t.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: [
                      Text(
                        p.size,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const Text('·', style: TextStyle(color: Colors.black45)),
                      Text(
                        p.condition,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const Text('·', style: TextStyle(color: Colors.black45)),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          p.brand,
                          style: TextStyle(
                            color: cs.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: cs.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '€${p.price.toStringAsFixed(2)}',
                    style: t.titleLarge?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '€${(p.price * 1.09).toStringAsFixed(2)} Includes Buyer Protection',
                        style: TextStyle(
                          color: Colors.teal[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.verified_user,
                        size: 18,
                        color: Colors.teal[700],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Divider(height: 1)),

          // ------------------ description & facts ------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(p.description),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Tap to translate'),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _FactsTable(
              rows: [
                _FactRow('Category', p.categoryPath.split(' > ').last),
                _FactRow('Brand', p.brand),
                _FactRow('Size', p.size),
                _FactRow('Condition', p.condition),
                _FactRow('Colour', p.colour),
                _FactRow('Uploaded', _timeAgo(p.uploadedAt)),
              ],
            ),
          ),

          // ------------------ tabs ------------------
          SliverToBoxAdapter(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.black,
                    indicatorColor: Colors.teal,
                    tabs: [
                      Tab(text: "Member's items"),
                      Tab(text: 'Similar items'),
                    ],
                  ),
                  SizedBox(
                    height: 640,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _MemberItemsTab(products: others),
                        _SimilarItemsTab(products: similar),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),

      // ------------------ bottom buttons ------------------
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MakeOfferPage(
                          productTitle: p.title,
                          productPrice: p.price,
                          thumbUrl: p.images.isNotEmpty ? p.images.first : null,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Make an offer'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(product: p),
                      ),
                    );
                  },
                  child: const Text('Buy now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------ sub-widgets & helpers ------------- */

class _FactsTable extends StatelessWidget {
  const _FactsTable({required this.rows});
  final List<_FactRow> rows;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: Theme.of(context).dividerColor, height: 1);
    return Column(
      children: [
        for (final r in rows) ...[
          ListTile(
            dense: true,
            title: Text(
              r.label,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(r.value),
          ),
          divider,
        ],
      ],
    );
  }
}

class _FactRow {
  final String label, value;
  const _FactRow(this.label, this.value);
}

class _MemberItemsTab extends StatelessWidget {
  const _MemberItemsTab({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shop bundles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Get up to 10% off',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: BorderSide(color: cs.outline),
                ),
                child: const Text('Create bundle'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: .72,
              ),
              itemCount: products.length,
              itemBuilder: (_, i) => _GridProductCard(p: products[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimilarItemsTab extends StatelessWidget {
  const _SimilarItemsTab({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .72,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) => _GridProductCard(p: products[i]),
      ),
    );
  }
}

class _GridProductCard extends StatelessWidget {
  const _GridProductCard({required this.p});
  final Product p;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => ProductPage(product: p)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: p.images.isEmpty
                  ? const ColoredBox(color: Color(0xFFEFEFEF))
                  : Image.network(p.images.first, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '€${p.price.toStringAsFixed(2)}',
                    style: t.bodyMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ------------ tiny helpers to fill the two tabs with demo data ------------- */

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} h ago';
  final d = diff.inDays;
  return d == 1 ? '1 day ago' : '$d days ago';
}

List<Product> _demoProductsForSeller(Product base) => List.generate(
  6,
  (i) => Product(
    id: 's-${i + 1}',
    title: '${base.brand} item ${i + 1}',
    brand: base.brand,
    price: (base.price * (0.8 + i * 0.07)),
    images: base.images,
    condition: 'Good',
    size: base.size,
    colour: base.colour,
    categoryPath: base.categoryPath,
    description: 'Another ${base.brand} piece from ${base.seller.username}.',
    seller: base.seller,
    badges: const [],
    likes: 3 + i,
    likedByMe: false,
    uploadedAt: DateTime.now().subtract(Duration(hours: 2 * (i + 1))),
  ),
);

List<Product> _demoSimilarProducts(Product base) => List.generate(
  6,
  (i) => Product(
    id: 'm-${i + 1}',
    title: 'Similar ${base.title} ${i + 1}',
    brand: base.brand,
    price: (base.price * (0.75 + i * 0.06)),
    images: base.images,
    condition: 'Very good',
    size: base.size,
    colour: base.colour,
    categoryPath: base.categoryPath,
    description: 'Similar item in ${base.categoryPath}.',
    seller: Seller(username: 'otherUser', rating: 5, ratingCount: 200),
    badges: const [],
    likes: 1 + i,
    likedByMe: false,
    uploadedAt: DateTime.now().subtract(Duration(hours: 3 * (i + 1))),
  ),
);
