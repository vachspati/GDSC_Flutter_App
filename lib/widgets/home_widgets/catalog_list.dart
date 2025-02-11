import 'package:flutter/material.dart';
import 'package:first_app/models/catalog.dart';
import 'package:first_app/pages/home_detail_page.dart';
import 'package:first_app/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:first_app/core/store.dart'; // Import MyStore

import 'add_to_cart.dart';
import 'catalog_image.dart';

class CatalogList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: VxBuilder<MyStore>(
        mutations: {}, // Use empty Set<Type>
        builder: (BuildContext context, MyStore store, _) {
          return !context.isMobile
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  shrinkWrap: true,
                  itemCount: CatalogModel.items.length,
                  itemBuilder: (context, index) {
                    final catalog = CatalogModel.items[index];
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeDetailPage(catalog: catalog),
                        ),
                      ),
                      child: CatalogItem(catalog: catalog),
                    );
                  },
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: CatalogModel.items.length,
                  itemBuilder: (context, index) {
                    final catalog = CatalogModel.items[index];
                    return InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        MyRoutes.homeDetailsRoute,
                        arguments: catalog,
                      ),
                      child: CatalogItem(catalog: catalog),
                    );
                  },
                );
        },
      ),
    );
  }
}

class CatalogItem extends StatelessWidget {
  final Item catalog;

  const CatalogItem({Key? key, required this.catalog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: Row(
        children: [
          Hero(
            tag: Key(catalog.id.toString()),
            child: CatalogImage(
              image: catalog.image,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                catalog.name.text.lg.color(context.accentColor).bold.make(),
                catalog.desc.text.textStyle(context.captionStyle).make(),
                10.heightBox,
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  buttonPadding: EdgeInsets.zero,
                  children: [
                    "\$${catalog.price}".text.bold.xl.make(),
                    AddToCart(catalog: catalog),
                  ],
                ).pOnly(right: 8.0)
              ],
            ),
          )
        ],
      ),
    ).color(context.cardColor).rounded.square(150).make().py16();
  }
}
