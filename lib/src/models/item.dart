import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:price_calculator/src/models/purchase.dart';

abstract class Sale {
  String get name;
  int get price;
  Item get item;
  const Sale();
  Purchase get toPurchase => Purchase(item, 0);
  @override
  bool operator ==(other) {
    return (other is Sale && other.name == name);
  }
}

class Item extends Sale {
  final String _name;
  final int _price;
  String get name => _name;
  int get price => _price;
  Item get item => this;

  const Item(this._name, this._price) : super();
  Item.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _price = json['price'];
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
      };
  bool get isEmpty => this.name == 'None' && this.price == 0;
  Item.clone(Item item) : this(item.name, item.price);
  // bool operator ==(other) {
  //   return (other is Item && other.name == name);
  // }

  static const Item empty = Item('None', 0);
  static Future<List<Item>> getItems(List<String> exclude) async {
    final data = await rootBundle.loadString('data/items.json');
    Map dataMap = json.decode(data);
    return dataMap['items']
        .map((itemJson) => Item.fromJson(itemJson as Map<String, dynamic>))
        .where((element) => !exclude.contains(element.name))
        .toList()
        .cast<Item>();
  }
}
