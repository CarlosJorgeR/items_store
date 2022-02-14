import 'package:price_calculator/src/models/item.dart';

class Purchase extends Sale {
  Item item;
  int amount;
  Purchase(this.item, this.amount) : super();
  Purchase.clone(Purchase purchase)
      : this(Item.clone(purchase.item), purchase.amount);
  bool get isEmpty => amount == 0;
  static Purchase get empty => Purchase(Item.empty, 0);
  @override
  bool operator ==(other) =>
      other is Purchase && item == other.item && amount == other.amount;

  @override
  String get name => item.name;

  @override
  int get price => item.price;
}
