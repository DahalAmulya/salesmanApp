import 'package:flutter/material.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final Color color;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
  });
}

final List<Product> PRODUCTS = [
  Product(
    id: 0,
    name: 'Laptop',
    price: 999.99,
    color: Colors.amber,
  ),
  Product(
    id: 1,
    name: 'Smartphone',
    price: 699.99,
    color: Colors.red,
  ),
  Product(
    id: 2,
    name: 'Wireless Earbuds',
    price: 129.99,
    color: Colors.green,
  ),
  Product(
    id: 3,
    name: 'Smartwatch',
    price: 199.99,
    color: Colors.blue,
  ),
  Product(
    id: 4,
    name: 'Gaming Console',
    price: 499.99,
    color: Colors.pink,
  ),
  Product(
    id: 5,
    name: '4K TV',
    price: 799.99,
    color: Colors.purple,
  ),
  Product(
    id: 6,
    name: 'Desktop Computer',
    price: 1299.99,
    color: Colors.teal,
  ),
  Product(
    id: 7,
    name: 'Bluetooth Speaker',
    price: 79.99,
    color: Colors.indigo,
  ),
  Product(
    id: 8,
    name: 'Camera Drone',
    price: 299.99,
    color: Colors.lime,
  ),
  Product(
    id: 9,
    name: 'Fitness Tracker',
    price: 129.99,
    color: Colors.cyan,
  ),
];
