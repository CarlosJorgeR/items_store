import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_calculator/src/bloc/purchaseBloc.dart';
import 'package:price_calculator/src/routes/routes.dart';
import 'package:price_calculator/src/models/item.dart';
import 'package:price_calculator/src/models/purchase.dart';
import 'package:price_calculator/src/widgets/appBarWidget.dart';
import 'package:price_calculator/src/widgets/tableWidget.dart';

class PurchasePage extends StatefulWidget {
  final _priceStyle = TextStyle(fontSize: 11, color: Colors.black);
  final _priceStyleTotal = TextStyle(fontSize: 11, color: Colors.green);
  final purchaseBloc = PurchaseBloc();

  PurchasePage({Key? key}) : super(key: key);
  static of(BuildContext context, {bool root = false}) => root
      ? context.findRootAncestorStateOfType<_PurchasePageState>()
      : context.findAncestorStateOfType<_PurchasePageState>();
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  double get appHeight => MediaQuery.of(context).size.height;
  List<TextEditingController> _controllers = <TextEditingController>[];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SaleState>(
        stream: widget.purchaseBloc.purchaseStream,
        initialData: SaleState([], []),
        builder: (context, AsyncSnapshot<SaleState> snapshot) {
          final saleState = snapshot.data ?? SaleState([], []);
          _controllers =
              (saleState.purchase).map((p) => TextEditingController()).toList();
          final func = (List<Sale> sales) => TableWidget(
                snapshot.data?.purchase ?? [],
                (sale) => 1,
                getPurchaseContainerFunc,
                getPurchaseInfoFunc,
              );
          return Scaffold(
            appBar: CustomAppBar(
              'Artículos',
              func,
            ),
            body: getSingleChildScrollView(saleState.purchase, func),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: getAddButton(context),
            bottomNavigationBar:
                getBottomNavigatorBar(context, snapshot.data?.purchase ?? []),
          );
        });
  }

  SingleChildScrollView getSingleChildScrollView(
      List<Sale> sales, Widget Function(List<Sale>) func) {
    return SingleChildScrollView(
      child: Column(
        children: [
          func(sales),
        ],
      ),
    );
  }

  Container getBottomNavigatorBar(
      BuildContext context, List<Purchase> purcahes) {
    final bottomNavigatorBarHeight = appHeight / 14;
    final bottomNavigatorBarPadding = appHeight / 90;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: bottomNavigatorBarPadding,
      ),
      height: bottomNavigatorBarHeight,
      color: Colors.black12,
      child: InkWell(
        child: Column(
          children: [
            Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.blueAccent,
            ),
            Text("${totalPrice(purcahes)}"),
          ],
        ),
      ),
    );
  }

  int totalPrice(List<Purchase> purcahes) {
    return purcahes.fold<int>(
      0,
      (previousValue, element) =>
          previousValue + element.amount * element.item.price,
    );
  }

  Widget getAddButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).pushNamed(
          RoutePaths.Add,
        );
      },
    );
  }

  Widget getPurchaseContainerFunc(Sale purchase) =>
      _getDeleteSection(purchase as Purchase);

  Widget getPurchaseInfoFunc(Sale purchase, double opacity, int position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _createImputNumber(purchase as Purchase, position),
        SizedBox(
          width: 5.0,
        ),
        _getPurchaseAmount(purchase),
      ],
    );
  }

  Widget _getDeleteSection(Purchase purchase) => Align(
        alignment: Alignment.bottomRight,
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.bottomRight,
          ),
          onPressed: () {
            setState(() {
              widget.purchaseBloc.removePurchase(purchase);
            });
          },
          child: Icon(Icons.cancel_sharp),
        ),
      );
  Widget _createImputNumber(Purchase purchase, int position) {
    print(purchase.amount + 1);
    // print(_controllers);
    if (_controllers[position].text.isEmpty) {
      _controllers[position].value = TextEditingValue(
          text: purchase.amount.toString(),
          selection: TextSelection.fromPosition(
            TextPosition(offset: purchase.amount.toString().length),
          ));
    }
    return SizedBox(
      width: appHeight / 10,
      height: appHeight / 16.6,
      child: TextFormField(
        maxLength: 4,
        controller: _controllers[position],
        // initialValue: purchase.amount.toString(),
        decoration: InputDecoration(
          labelText: 'Cantidad:',
          border: OutlineInputBorder(),
          counterText: "",
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: widget._priceStyle,
        onChanged: (String value) {
          widget.purchaseBloc
              .changePurchase(purchase, value.isEmpty ? 0 : int.parse(value));
        },
      ),
    );
  }

  Text _getPurchaseAmount(Purchase purchase) {
    return Text(
      '${purchase.item.price * purchase.amount} CUP',
      style: widget._priceStyleTotal,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllers.forEach((element) => element.dispose());
    super.dispose();
  }
}
