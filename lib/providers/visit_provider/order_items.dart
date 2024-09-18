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
    name: 'Lenovo ideapad gaming 13 i5 12600K 16 GB RAM 512 GB SSD',
    price: 125000.0,
    color: Colors.amber,
  ),
  Product(
    id: 1,
    name: 'iphone 15 pro max 256 GB',
    price: 215000.0,
    color: Colors.red,
  ),
  Product(
    id: 2,
    name:
        'Macbook pro M3 pro 16 inch 12-core CPU 18-core GPU 18 GB RAM 512 GB SSD',
    price: 410000.0,
    color: Colors.green,
  ),
  Product(
    id: 3,
    name: 'Ultima Smartwatch',
    price: 2100.0,
    color: Colors.blue,
  ),
  Product(
    id: 4,
    name: 'Samsung S24 Ultra',
    price: 160000.0,
    color: Colors.pink,
  ),
  Product(
    id: 5,
    name: 'Samsung 4K TV',
    price: 85000,
    color: Colors.purple,
  ),
  Product(
    id: 6,
    name: 'Dell Desktop Computer',
    price: 90000.0,
    color: Colors.teal,
  ),
  Product(
    id: 7,
    name: 'Bluetooth Speaker',
    price: 1200.0,
    color: Colors.indigo,
  ),
  Product(
    id: 8,
    name: 'Camera Drone',
    price: 30000,
    color: Colors.lime,
  ),
  Product(
    id: 9,
    name: 'JBL 710B over-ear Headphone',
    price: 10500,
    color: Colors.cyan,
  ),
];
