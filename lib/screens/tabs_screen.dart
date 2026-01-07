import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'categories_screen.dart';
import 'shopping_list_screen.dart';
import '../widgets/new_item.dart';
import '../providers/theme_provider.dart'; // Важливий імпорт для теми

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _addItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => const NewItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CategoriesScreen();
    String activePageTitle = 'Категорії';

    if (_selectedPageIndex == 1) {
      activePage = const ShoppingListScreen();
      activePageTitle = 'Всі покупки';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: [
          // Кнопка перемикання теми
          IconButton(
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            icon: const Icon(Icons.brightness_6),
          ),
          // Кнопка додавання (тільки для екрану списку)
          if (_selectedPageIndex == 1)
            IconButton(
              onPressed: _addItem, 
              icon: const Icon(Icons.add)
            ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category), 
            label: 'Категорії'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list), 
            label: 'Список'
          ),
        ],
      ),
    );
  }
}