import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Category {
  final String id;
  final String title;
  final Color color;

  const Category({
    required this.id,
    required this.title,
    this.color = Colors.orange,
  });
}

class Product {
  final String id;
  final String name;
  final int count;
  final double price;
  final Category category;

  Product({
    String? id,
    required this.name,
    required this.count,
    required this.price,
    required this.category,
  }) : id = id ?? uuid.v4();
}