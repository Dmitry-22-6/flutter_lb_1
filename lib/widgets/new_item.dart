import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../data/categories.dart';
import '../providers/products_provider.dart';

class NewItem extends ConsumerStatefulWidget {
  final Product? product;
  const NewItem({super.key, this.product});

  @override
  ConsumerState<NewItem> createState() => _NewItemState();
}

class _NewItemState extends ConsumerState<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredCount = 1;
  var _enteredPrice = 0.0;
  var _selectedCategory = availableCategories['c1']!;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _enteredName = widget.product!.name;
      _enteredCount = widget.product!.count;
      _enteredPrice = widget.product!.price;
      _selectedCategory = widget.product!.category;
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newProduct = Product(
        id: widget.product?.id, 
        name: _enteredName, 
        count: _enteredCount, 
        price: _enteredPrice, 
        category: _selectedCategory 
      );

      if (widget.product != null) {
        ref.read(productsProvider.notifier).editProduct(newProduct);
      } else {
        ref.read(productsProvider.notifier).addProduct(newProduct);
      }
      
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _enteredName,
              decoration: const InputDecoration(labelText: 'Назва товару'),
              validator: (value) => (value == null || value.isEmpty) ? 'Введіть назву' : null,
              onSaved: (value) => _enteredName = value!,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: _enteredCount.toString(),
                    decoration: const InputDecoration(labelText: 'Кількість'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _enteredCount = int.parse(value!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: _enteredPrice.toString(),
                    decoration: const InputDecoration(labelText: 'Ціна'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _enteredPrice = double.parse(value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: [
                for (final category in availableCategories.values)
                  DropdownMenuItem(
                    value: category,
                    child: Row(children: [
                      Container(width: 16, height: 16, color: category.color),
                      const SizedBox(width: 6),
                      Text(category.title),
                    ]),
                  )
              ],
              onChanged: (value) {
                setState(() { _selectedCategory = value!; });
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _saveItem, child: Text(widget.product == null ? 'Додати' : 'Зберегти'))
          ],
        ),
      ),
    );
  }
}