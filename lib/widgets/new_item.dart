import 'package:flutter/material.dart';
import '../models/product.dart';

class NewItem extends StatefulWidget {
  final Product? product; // Якщо це редагування, сюди прийде товар

  const NewItem({super.key, this.product});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  // Контролери для зчитування тексту
  final _nameController = TextEditingController();
  final _countController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Якщо ми редагуємо, заповнюємо поля старими даними
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _countController.text = widget.product!.count.toString();
      _priceController.text = widget.product!.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitData() {
    final enteredName = _nameController.text;
    final enteredCount = int.tryParse(_countController.text) ?? 1;
    final enteredPrice = double.tryParse(_priceController.text) ?? 0.0;

    if (enteredName.isEmpty || enteredCount <= 0 || enteredPrice <= 0) {
      return; // Якщо дані неправильні, нічого не робимо
    }

    // Повертаємо готовий об'єкт назад
    Navigator.of(context).pop(
      Product(name: enteredName, count: enteredCount, price: enteredPrice),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        // Щоб клавіатура не перекривала поля:
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Назва товару'),
          ),
          TextField(
            controller: _countController,
            decoration: const InputDecoration(labelText: 'Кількість'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Ціна за шт.'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitData,
            child: Text(widget.product == null ? 'Додати' : 'Зберегти'),
          ),
        ],
      ),
    );
  }
}