import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  // 1. Get Collections
  Future<Response> getCollections({int first = 10}) async {
    const String query = r'''
      query MyQuery($first: Int!) { 
        collections(first: $first) { 
          edges { 
            node { 
              handle 
              id 
              image { 
                url 
              } 
              title 
            } 
          } 
        } 
      }
    ''';
    return _dioClient.post({
      'query': query,
      'variables': {'first': first},
    });
  }

  // 2. Get Cart
  Future<Response> getCart(String cartId) async {
    const String query = r'''
      query GetCart($cartId: ID!) {
        cart(id: $cartId) {
          id
          checkoutUrl
          totalQuantity
          cost {
            subtotalAmount {
              amount
              currencyCode
            }
            totalAmount {
              amount
              currencyCode
            }
          }
          lines(first: 20) {
            edges {
              node {
                id
                quantity
                merchandise {
                  ... on ProductVariant {
                    id
                    title
                    price {
                      amount
                      currencyCode
                    }
                    compareAtPrice {
                      amount
                      currencyCode
                    }
                    image {
                      url
                      altText
                    }
                    product {
                      title
                      handle
                    }
                  }
                }
              }
            }
          }
        }
      }
    ''';
    return _dioClient.post({
      'query': query,
      'variables': {'cartId': cartId},
    });
  }

  // 3. Collection by Handle
  Future<Response> getCollectionByHandle(String handle) async {
    const String query = r'''
      query MyQuery($handle: String!) {
        collectionByHandle(handle: $handle) {
          id
          handle
          title
          products(first: 10) {
            edges {
              node {
                id
                availableForSale
                featuredImage {
                  url
                }
                priceRange {
                  minVariantPrice {
                    amount
                    currencyCode
                  }
                  maxVariantPrice {
                    amount
                    currencyCode
                  }
                }
                compareAtPriceRange {
                  maxVariantPrice {
                    amount
                    currencyCode
                  }
                  minVariantPrice {
                    amount
                    currencyCode
                  }
                }
                variants(first: 10) {
                  nodes {
                    title
                    id
                  }
                }
                handle
                description
                title
                metafield(namespace: "custom", key: "gender") {
                  value
                  type
                  key
                }
              }
            }
          }
        }
      }
    ''';
    return _dioClient.post({
      'query': query,
      'variables': {'handle': handle},
    });
  }

  // 4. Create Cart
  Future<Response> createCart(String variantId, int quantity) async {
    const String query = r'''
      mutation CreateCart($variantId: ID!, $quantity: Int!) {
        cartCreate(input: {lines: [{quantity: $quantity, merchandiseId: $variantId}]}) {
          cart {
            id
            checkoutUrl
            lines(first: 10) {
              edges {
                node {
                  id
                  quantity
                  merchandise {
                    ... on ProductVariant {
                      id
                      title
                      image {
                        url
                        altText
                      }
                      product {
                        id
                        title
                      }
                    }
                  }
                }
              }
            }
          }
          userErrors {
            field
            message
          }
        }
      }
    ''';
    return _dioClient.post({
      'query': query,
      'variables': {'quantity': quantity, 'variantId': variantId},
    });
  }

  // 6. Update Cart
  Future<Response> updateCart(
    String cartId,
    String lineId,
    int quantity,
  ) async {
    const String query = r'''
      mutation UpdateCart($cartId: ID!, $lines: [CartLineUpdateInput!]!) {
        cartLinesUpdate(cartId: $cartId, lines: $lines) {
          cart {
            id
            lines(first: 10) {
              edges {
                node {
                  id
                  quantity
                  cost {
                    totalAmount {
                      amount
                      currencyCode
                    }
                  }
                  merchandise {
                    ... on ProductVariant {
                      id
                      title
                      image {
                        url
                        altText
                      }
                      product {
                        id
                        title
                      }
                    }
                  }
                }
              }
            }
          }
          userErrors {
            field
            message
          }
        }
      }
    ''';
    return _dioClient.post({
      'query': query,
      'variables': {
        'cartId': cartId,
        'lines': [
          {'id': lineId, 'quantity': quantity},
        ],
      },
    });
  }

  // 7. All Products
  Future<Response> getAllProducts() async {
    const String query = r'''
      query MyQuery {
        products(first: 100) {
          edges {
            node {
              id
              description
              availableForSale
              images(first: 10) {
                edges {
                  node {
                    id
                  }
                }
              }
              priceRange {
                maxVariantPrice {
                  amount
                  currencyCode
                }
                minVariantPrice {
                  amount
                  currencyCode
                }
              }
              title
              featuredImage {
                url
              }
              variants(first: 10) {
                edges {
                  node {
                    id
                  }
                }
              }
            }
          }
        }
      }
    ''';
    return _dioClient.post({'query': query, 'variables': null});
  }
}
