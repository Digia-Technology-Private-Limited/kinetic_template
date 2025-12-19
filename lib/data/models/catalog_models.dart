class Product {
  final String id;
  final String title;
  final String? handle;
  final String? description;
  final bool availableForSale;
  final String? featuredImage;
  final double? price;
  final double? compareAtPrice;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    this.handle,
    this.description,
    this.availableForSale = false,
    this.featuredImage,
    this.price,
    this.compareAtPrice,
    this.images = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final node = json['node'] ?? json;

    // Price handling (nested in priceRange or simple price)
    double? parsedPrice;
    if (node['priceRange'] != null) {
      parsedPrice = double.tryParse(
        node['priceRange']['minVariantPrice']['amount'] ?? '',
      );
    } else if (node['price'] != null) {
      parsedPrice = double.tryParse(node['price']['amount'] ?? '');
    }

    // CompareAtPrice handling
    double? parsedCompareAtPrice;
    if (node['compareAtPriceRange'] != null) {
      parsedCompareAtPrice = double.tryParse(
        node['compareAtPriceRange']['maxVariantPrice']['amount'] ?? '',
      );
    } else if (node['compareAtPrice'] != null) {
      parsedCompareAtPrice = double.tryParse(
        node['compareAtPrice']['amount'] ?? '',
      );
    }

    // Images handling
    List<String> imgs = [];
    if (node['images'] != null && node['images']['edges'] != null) {
      for (var edge in node['images']['edges']) {
        if (edge['node'] != null && edge['node']['url'] != null) {
          // Note: some queries don't request url in nested images? checking query 7
          // Query 7 requests: images(first: 10) { edges { node { id } } } -- Wait, Query 7 DOES NOT request URL for images list! Only featuredImage { url }.
          // However, Cart query requests image { url }.
          // Use featuredImage as primary.
        }
      }
    }

    return Product(
      id: node['id'] ?? '',
      title: node['title'] ?? '',
      handle: node['handle'],
      description: node['description'],
      availableForSale: node['availableForSale'] ?? false,
      featuredImage: node['featuredImage']?['url'] ?? node['image']?['url'],
      price: parsedPrice,
      compareAtPrice: parsedCompareAtPrice,
    );
  }
}

class Collection {
  final String id;
  final String title;
  final String? handle;
  final String? imageUrl;
  final List<Product> products;

  Collection({
    required this.id,
    required this.title,
    this.handle,
    this.imageUrl,
    this.products = const [],
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    final node = json['node'] ?? json;

    List<Product> prods = [];
    if (node['products'] != null && node['products']['edges'] != null) {
      for (var edge in node['products']['edges']) {
        prods.add(Product.fromJson(edge));
      }
    }

    return Collection(
      id: node['id'] ?? '',
      title: node['title'] ?? '',
      handle: node['handle'],
      imageUrl: node['image']?['url'],
      products: prods,
    );
  }
}
