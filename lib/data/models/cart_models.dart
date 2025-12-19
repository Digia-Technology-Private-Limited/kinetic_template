import 'catalog_models.dart';

// Local cart item for offline storage
class LocalCartItem {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  LocalCartItem({
    required this.product,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': {
        'id': product.id,
        'title': product.title,
        'handle': product.handle,
        'description': product.description,
        'availableForSale': product.availableForSale,
        'featuredImage': product.featuredImage,
        'price': product.price,
        'compareAtPrice': product.compareAtPrice,
      },
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
    };
  }

  factory LocalCartItem.fromJson(Map<String, dynamic> json) {
    return LocalCartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'],
      selectedColor: json['selectedColor'],
    );
  }

  LocalCartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return LocalCartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  double get itemTotal => (product.price ?? 0) * quantity;
}

class Cart {
  final String id;
  final String? checkoutUrl;
  final int totalQuantity;
  final double subtotal;
  final double total;
  final List<CartLine> lines;

  Cart({
    required this.id,
    this.checkoutUrl,
    this.totalQuantity = 0,
    this.subtotal = 0.0,
    this.total = 0.0,
    this.lines = const [],
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final cartData =
        json['cart'] ??
        json; // Sometimes root is cart, sometimes result of mutation

    List<CartLine> cartLines = [];
    if (cartData['lines'] != null && cartData['lines']['edges'] != null) {
      for (var edge in cartData['lines']['edges']) {
        cartLines.add(CartLine.fromJson(edge['node']));
      }
    }

    double sub = 0.0;
    double tot = 0.0;

    if (cartData['cost'] != null) {
      sub =
          double.tryParse(
            cartData['cost']['subtotalAmount']?['amount'] ?? '0',
          ) ??
          0.0;
      tot =
          double.tryParse(cartData['cost']['totalAmount']?['amount'] ?? '0') ??
          0.0;
    }

    return Cart(
      id: cartData['id'] ?? '',
      checkoutUrl: cartData['checkoutUrl'],
      totalQuantity: cartData['totalQuantity'] ?? 0,
      subtotal: sub,
      total: tot,
      lines: cartLines,
    );
  }
}

class CartLine {
  final String id;
  final int quantity;
  final Product product;
  final double? amountPerQuantity;
  final double? totalAmount;

  CartLine({
    required this.id,
    required this.quantity,
    required this.product,
    this.amountPerQuantity,
    this.totalAmount,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) {
    final merkle = json['merchandise']; // ProductVariant
    final productData = merkle['product'];
    // Merge merchandise fields into product-like structure
    Map<String, dynamic> productJson = {
      'id': productData['id'],
      'title': productData['title'], // Product title
      'featuredImage': merkle['image'], // Variant image
      'price': merkle['price'],
    };

    // If merchandise has specific title (Variant title), might want to append?
    // User JSON shows merchandise -> title "Small / Red" etc.
    // We can store variant title in product or separate.

    return CartLine(
      id: json['id'],
      quantity: json['quantity'],
      product: Product.fromJson(productJson),
      amountPerQuantity: json['cost'] != null
          ? double.tryParse(json['cost']['amountPerQuantity']?['amount'] ?? '')
          : null,
      totalAmount: json['cost'] != null
          ? double.tryParse(json['cost']['totalAmount']?['amount'] ?? '')
          : null,
    );
  }
}
