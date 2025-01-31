import 'package:first_app/models/catalog.dart';
import 'package:flutter/material.dart';
import 'package:first_app/core/store.dart';
import 'package:first_app/models/cart.dart';
import 'package:pay/pay.dart';
import 'package:velocity_x/velocity_x.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: "Cart".text.make(),
      ),
      body: Column(
        children: [
          _CartList().p32().expand(),
          Divider(),
          _CartTotal(),
        ],
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  final _paymentItems = <PaymentItem>[];
  @override
  Widget build(BuildContext context) {
    final CartModel _cart = (VxState.store as MyStore).cart;
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          VxBuilder(
            mutations: {RemoveMutation},
            builder: (context, store, _) {
              // Added `store` parameter
              _paymentItems.add(PaymentItem(
                amount: _cart.totalPrice.toString(),
                label: "Codepur course",
                status: PaymentItemStatus.final_price,
              ));
              return "\$${_cart.totalPrice}"
                  .text
                  .xl5
                  .color(context.theme.colorScheme
                      .secondary) // Updated to use `colorScheme`
                  .make();
            },
          ),
          30.widthBox,
          Row(
            children: [
              ApplePayButton(
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  '''
                  {
                    "provider": "apple_pay",
                    "data": {
                      "merchantIdentifier": "merchant.com.your.app",
                      "displayName": "Your App",
                      "merchantCapabilities": ["3DS", "debit", "credit"],
                      "supportedNetworks": ["amex", "visa", "mastercard"],
                      "countryCode": "US",
                      "currencyCode": "USD"
                    }
                  }
                  ''',
                ),
                paymentItems: _paymentItems,
                width: 200,
                height: 50,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                  print(data);
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              GooglePayButton(
                paymentConfiguration: PaymentConfiguration.fromJsonString(
                  '''
                  {
                    "provider": "google_pay",
                    "data": {
                      "environment": "TEST",
                      "apiVersion": 2,
                      "apiVersionMinor": 0,
                      "allowedPaymentMethods": [
                        {
                          "type": "CARD",
                          "parameters": {
                            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                            "allowedCardNetworks": ["AMEX", "VISA", "MASTERCARD"]
                          }
                        }
                      ]
                    }
                  }
                  ''',
                ),
                paymentItems: _paymentItems,
                width: 200,
                height: 50,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: (data) {
                  print(data);
                },
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutation]);
    final CartModel _cart = (VxState.store as MyStore).cart;
    return _cart.items.isEmpty
        ? "Nothing to show".text.xl3.makeCentered()
        : ListView.builder(
            itemCount: _cart.items.length,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(Icons.done),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () => RemoveMutation(_cart.items[index]),
              ),
              title: _cart.items[index].name.text.make(),
            ),
          );
  }
}

extension on List<Item> {}
