import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import '../widgets/new_item.dart';
import '../models/product.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  final Category? categoryFilter;
  const ShoppingListScreen({super.key, this.categoryFilter});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ref.read(productsProvider.notifier).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = ref.watch(productsProvider);
    final products = widget.categoryFilter == null 
        ? allProducts 
        : allProducts.where((p) => p.category.id == widget.categoryFilter!.id).toList();

    double totalSum = products.fold(0, (sum, item) => sum + (item.price * item.count));

    Widget content = const Center(child: Text('Список порожній'));

    if (products.isNotEmpty) {
      content = ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) {
           final item = products[index];
           return Dismissible(
             key: ValueKey(item.id),
             background: Container(color: Colors.red),
             onDismissed: (direction) {
               final notifier = ref.read(productsProvider.notifier);
               
               // Видаляємо візуально
               notifier.removeLocal(item);

               // Показуємо Undo
               ScaffoldMessenger.of(context).clearSnackBars();
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                 duration: const Duration(seconds: 2),
                 content: const Text('Видалено'),
                 action: SnackBarAction(
                   label: 'Undo',
                   onPressed: () {
                     notifier.restoreLocal(item, index);
                   },
                 ),
               )).closed.then((reason) {
                 if (reason != SnackBarClosedReason.action) {
                   notifier.deleteFromServer(item.id);
                 }
               });
             },
             child: InkWell(
               onTap: () {
                 // Редагування поки не чіпаємо
               },
               child: ListTile(
                 leading: Container(width: 24, height: 24, color: item.category.color),
                 title: Text(item.name),
                 subtitle: Text('${item.count} шт. x ${item.price} грн'),
                 trailing: Text('${(item.count * item.price).toStringAsFixed(1)} грн'),
               ),
             ),
           );
        },
      );
    }

    if (widget.categoryFilter != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.categoryFilter!.title)),
        body: content,
      );
    }

    return Scaffold(
      body: FutureBuilder(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(child: content),
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('РАЗОМ:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${totalSum.toStringAsFixed(2)} грн', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}