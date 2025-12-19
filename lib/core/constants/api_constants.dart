class ApiConstants {
  static const String baseUrl =
      'https://digia-ecomm-template.myshopify.com/api/2025-07/graphql.json';
  static const String storeName = 'digia-ecomm-template';
  static const String accessToken = '472ea71507675de777481cc13d7ed8ee';

  static const Map<String, String> defaultHeaders = {
    'accept': '*/*',
    'accept-language': 'en-US,en;q=0.9',
    'content-type': 'application/json',
    'origin': 'https://app.digia.tech',
    'priority': 'u=1, i',
    'referer': 'https://app.digia.tech/',
    'sec-ch-ua':
        '"Google Chrome";v="143", "Chromium";v="143", "Not A(Brand";v="24"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"macOS"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'cross-site',
    'x-shopify-storefront-access-token': accessToken,
  };
}
