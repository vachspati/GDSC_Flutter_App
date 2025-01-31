import 'package:first_app/models/cart.dart';
import 'package:first_app/models/catalog.dart';
import 'package:velocity_x/velocity_x.dart';

class MyStore extends VxStore {
  late CatalogModel catalog;
  late CartModel cart;
  List<Item> items = [];

  MyStore() {
    catalog = CatalogModel();
    cart = CartModel(catalog); // Pass the catalog instance here
  }

  set navigator(navigator) {}
}
