import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../data/categories.dart';

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super([]);

  // Твоє посилання на базу даних
  static const firebaseURL = 'https://lb4-shopping-list-default-rtdb.europe-west1.firebasedatabase.app/products.json';

  // 1. ЗАВАНТАЖЕННЯ (GET)
  Future<void> loadProducts() async {
    try {
      final response = await http.get(Uri.parse(firebaseURL));

      if (response.body == 'null') {
        state = [];
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<Product> loadedItems = [];

      for (final item in listData.entries) {
        final category = availableCategories.values.firstWhere(
            (cat) => cat.title == item.value['category'],
            orElse: () => availableCategories['c1']!);

        loadedItems.add(Product(
          id: item.key,
          name: item.value['name'],
          count: item.value['count'],
          price: double.parse(item.value['price'].toString()),
          category: category,
        ));
      }
      state = loadedItems;
    } catch (error) {
      print('Помилка: $error');
    }
  }

  // 2. ДОДАВАННЯ (POST)
  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(firebaseURL),
      body: json.encode({
        'name': product.name,
        'count': product.count,
        'price': product.price,
        'category': product.category.title,
      }),
    );

    final newId = json.decode(response.body)['name'];

    final newProduct = Product(
      id: newId,
      name: product.name,
      count: product.count,
      price: product.price,
      category: product.category,
    );

    state = [...state, newProduct];
  }

  // 3. ВИДАЛЕННЯ (DELETE)
  void removeLocal(Product product) {
     state = state.where((p) => p.id != product.id).toList();
  }
  
  void restoreLocal(Product product, int index) {
     final newState = [...state];
     newState.insert(index, product);
     state = newState;
  }

  Future<void> deleteFromServer(String id) async {
    final url = Uri.parse(firebaseURL.replaceFirst('products.json', 'products/$id.json'));
    await http.delete(url);
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});