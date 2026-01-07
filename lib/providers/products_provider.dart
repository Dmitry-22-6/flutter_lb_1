import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../data/categories.dart';

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super([
    // Початкові тестові дані
    Product(name: 'Молоко', count: 2, price: 35.0, category: availableCategories['c1']!),
    Product(name: 'Мило', count: 1, price: 45.5, category: availableCategories['c2']!),
  ]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void removeProduct(Product product) {
    state = state.where((p) => p.id != product.id).toList();
  }
  
  // Для Undo
  void undoDelete(Product product, int index) {
    final newState = [...state];
    newState.insert(index, product);
    state = newState;
  }

  void editProduct(Product product) {
    state = [
      for (final p in state)
        if (p.id == product.id) product else p
    ];
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});