import 'dart:convert';
// import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:price_calculator/src/models/item.dart';

class ItemProvider {
  static ItemProvider pv = ItemProvider();
  Future<List<Item>> getItems(List<String> exclude) async {
    final data = await rootBundle.loadString('data/items.json');
    Map dataMap = json.decode(data);
    return dataMap['items']
        .map((itemJson) => Item.fromJson(itemJson as Map<String, dynamic>))
        .where((element) => !exclude.contains(element.name))
        .toList()
        .cast<Item>();
  }
}
