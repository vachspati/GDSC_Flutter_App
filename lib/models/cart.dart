import 'package:first_app/core/store.dart';
import 'package:first_app/models/catalog.dart';
import 'package:velocity_x/velocity_x.dart';

class CartModel {
  CatalogModel _catalog;
  final List<int> _itemIds = [];

  CartModel(this._catalog); // Initialize _catalog in the constructor

  CatalogModel get catalog => _catalog;

  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
  }

  // Ensure _catalog.getById(id) returns a single Item
  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  num get totalPrice =>
      items.fold(0, (total, current) => total + current.price);
}

class AddMutation extends VxMutation<MyStore> {
  final Item item;

  AddMutation(this.item);

  @override
  perform() {
    assert(store != null, "Store is null");
    store!.cart._itemIds.add(item.id);
  }
}

class RemoveMutation extends VxMutation<MyStore> {
  final Item item;

  RemoveMutation(this.item);

  @override
  perform() {
    assert(store != null, "Store is null");
    store!.cart._itemIds.remove(item.id);
  }
}
