import 'dart:async';

import 'package:price_calculator/src/bloc/purchaseBloc.dart';
import 'package:price_calculator/src/models/item.dart';
import 'package:price_calculator/src/providers/ItemProvider.dart';

class ItemBloc {
  static final ItemBloc _singlenton = new ItemBloc._internal();
  factory ItemBloc() {
    return _singlenton;
  }
  ItemBloc._internal() {}
  final _itemBlocController = StreamController<List<Item>>.broadcast();
  get itemStream => _itemBlocController.stream;
  dispose() {
    _itemBlocController.close();
  }

  getAllItems() async {
    //  _purchases.
    // _itemBlocController.sink.add(await ItemProvider.pv.getItems());
  }

  // deleteItem(Item item) async {
  //   getAllItems({List<String> exclude = const []})
  // }
}
