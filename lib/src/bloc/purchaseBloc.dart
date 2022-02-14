import 'dart:async';

import 'package:price_calculator/src/models/item.dart';
import 'package:price_calculator/src/models/purchase.dart';
import 'package:price_calculator/src/providers/ItemProvider.dart';

class SaleState {
  List<Purchase> purchase;
  List<Item> items;
  SaleState(this.items, this.purchase);
}

class PurchaseBloc {
  static final PurchaseBloc _singlenton = new PurchaseBloc._internal();
  late SaleState saleState;
  factory PurchaseBloc() {
    return _singlenton;
  }
  PurchaseBloc._internal() {
    saleState = SaleState([], []);
  }
  final _purchaseBlocController = StreamController<SaleState>.broadcast();
  Stream<SaleState> get purchaseStream => _purchaseBlocController.stream;

  dispose() {
    _purchaseBlocController.close();
  }

  getAllPurchases() async {
    _purchaseBlocController.sink.add(saleState);
  }

  addPurchase(Purchase purchase) async {
    saleState.purchase.add(purchase);
    await getAllPurchases();
    // _itemBlocController.sink.add(await ItemProvider.pv.getItems(exclude));
  }

  removePurchase(Purchase purchase) async {
    saleState.purchase.remove(purchase);
    await getAllPurchases();
  }

  changePurchase(Purchase purchase, int value) async {
    saleState.purchase
        .firstWhere((element) => element.name == purchase.name)
        .amount = value;
    await getAllPurchases();
  }

  bool containPurchase(String name) {
    return saleState.purchase.any((element) => element.name == name);
  }

  initItems() async {
    saleState.items = await ItemProvider.pv
        .getItems(saleState.purchase.map((p) => p.name).toList());
    // print(_items.length);
    getAllItems();
  }

  getAllItems() async {
    _purchaseBlocController.sink.add(saleState);
  }
}
