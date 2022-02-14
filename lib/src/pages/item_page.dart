import 'package:flutter/material.dart';
import 'package:price_calculator/src/bloc/purchaseBloc.dart';
import 'package:price_calculator/src/models/item.dart';
import 'package:price_calculator/src/widgets/appBarWidget.dart';
import 'package:price_calculator/src/widgets/tableWidget.dart';

class ItemPage extends StatefulWidget {
  // Purchase purchase = Purchase.empty;
  final purchaseBloc = PurchaseBloc();
  ItemPage({
    Key? key,
  }) : super(key: key);

  @override
  _ItemPageState createState() {
    return _ItemPageState();
  }
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    widget.purchaseBloc.initItems();

    return StreamBuilder<SaleState>(
        stream: widget.purchaseBloc.purchaseStream,
        builder: (context, AsyncSnapshot<SaleState> purchaseSnapshot) {
          final saleState = purchaseSnapshot.data ?? SaleState([], []);
          final func = (List<Sale> sales) => TableWidget(
                sales,
                (Sale sale) => saleState.purchase
                        .any((element) => element.name == sale.name)
                    ? 0.2
                    : 1,
                _getActionSection,
                getInfoWidgetFunc,
              );
          return Scaffold(
            appBar: getAppBar(context, func),
            body: getScaffloldBody(saleState.items, func),
          );
        });
  }

  ListView getScaffloldBody(
      List<Sale> sales, Widget Function(List<Sale>) func) {
    return ListView(
      children: [
        func(sales),
      ],
    );
  }

  TextStyle priceStyleTotal(Sale sale, double opacity) => TextStyle(
        fontSize: 11,
        color: Colors.green.withOpacity(opacity),
      );
  Widget getInfoWidgetFunc(sale, double opacity, int position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${sale.price} CUP',
          style: priceStyleTotal(sale, opacity),
        ),
      ],
    );
  }

  PreferredSizeWidget getAppBar(
      BuildContext context, Widget Function(List<Sale>) func) {
    return CustomAppBar(
      'Artículo',
      func,
      iconThemeData:
          IconThemeData(color: Colors.white, size: 30.0, opacity: 10.0),
    );
  }

  Widget _getActionSection(Sale sale) => Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.bottomRight,
          ),
          onPressed: () => !widget.purchaseBloc.containPurchase(sale.name)
              ? widget.purchaseBloc.addPurchase(sale.toPurchase)
              : widget.purchaseBloc.removePurchase(sale.toPurchase),
          child: widget.purchaseBloc.containPurchase(sale.name)
              ? Icon(Icons.remove_circle)
              : Icon(Icons.add_circle),
        ),
      );
}
