import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import '../data/services/storage_service.dart';
import '../data/models/catalog_models.dart';

class StoreProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService? _storageService;

  StoreProvider(this._apiService, [this._storageService]);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Collection> _collections = [];
  List<Collection> get collections => _collections;

  // We can also keep a map if we want faster access by ID/Handle, but user asked to iterate list.
  // We will populate the 'products' field inside the Collection objects.

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? get gender => _storageService?.getGender();
  String? get avatar => _storageService?.getAvatar();

  Future<void> loadHomePageData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Fetch Collections
      final colResponse = await _apiService.getCollections();
      if (colResponse.data != null) {
        final edges = colResponse.data['data']['collections']['edges'] as List;
        _collections = edges.map((e) => Collection.fromJson(e)).toList();

        // 2. Fetch Products for EACH collection
        // "For each item (string) in this list, I want to call the Collection By Handle API"
        for (int i = 0; i < _collections.length; i++) {
          final collection = _collections[i];
          if (collection.handle != null) {
            final fullCollection = await getCollectionByHandle(
              collection.handle!,
            );
            if (fullCollection != null) {
              // Update the collection in the list with the one that has products
              _collections[i] = fullCollection;
            }
          }
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("StoreProvider Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch specific collection
  Future<Collection?> getCollectionByHandle(String handle) async {
    try {
      final response = await _apiService.getCollectionByHandle(handle);
      if (response.data != null &&
          response.data['data']['collectionByHandle'] != null) {
        return Collection.fromJson(response.data['data']['collectionByHandle']);
      }
    } catch (e) {
      debugPrint("Error fetching collection $handle: $e");
    }
    return null;
  }

  Future<void> setGender(String val) async {
    await _storageService?.saveGender(val);
    notifyListeners();
  }

  Future<void> setAvatar(String url) async {
    await _storageService?.saveAvatar(url);
    notifyListeners();
  }
}
