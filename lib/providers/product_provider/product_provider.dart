import 'package:flutter/foundation.dart';

class ProductProvider extends ChangeNotifier{
  double _quantity = 0;
  List<Map<String, dynamic>> _medList = [
    {
      "name": "Paracetamol",
      "price": 40,
      "pack": 320,
    },
    {
      "name": "Nemuslide",
      "price": 50,
      "pack": 440,
    },
    {
      "name": "Pentaprazole",
      "price": 80,
      "pack": 640,
    },
    {
      "name": "Losita-H",
      "price": 95,
      "pack": 1140,
    },
    {
      "name": "Triptans",
      "price": 50,
      "pack": 400,
    },
    {
      "name": "Aspirin",
      "price": 20,
      "pack": 160,
    },
    {
      "name": "Almotriptan",
      "price": 90,
      "pack": 720,
    },
    {
      "name": "Naproxen",
      "price": 40,
      "pack": 320,
    },
    {
      "name": "Ibuprofen",
      "price": 60,
      "pack": 480,
    },
    {
      "name": "Acetaminophen",
      "price": 100,
      "pack": 800,
    },
    {
      "name": "Anticholinergic",
      "price": 80,
      "pack": 320,
    },
    {
      "name": "Ativan",
      "price": 70,
      "pack": 560,
    },
    {
      "name": "Benzodiazepines",
      "price": 60,
      "pack": 480,
    },
  ];

  List<Map<String, dynamic>> get medList => _medList;
  double get quantity => _quantity;
}