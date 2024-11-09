// !!!!!!!!!!!!!!!!
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/controllers/Product/cart_controller.dart';
import 'package:pet_shop/controllers/Product/product_controller.dart';
import 'package:pet_shop/models/Product/product.dart';
import 'package:pet_shop/route/route_generator.dart';
import 'package:pet_shop/screen/Product/components/rounded_container.dart';
import 'package:pet_shop/screen/Product/detail_product.dart';

class ProductCardVertical extends StatelessWidget {
  final Product product;
  const ProductCardVertical({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductController proController = Get.find<ProductController>();
    return GestureDetector(
      onTap: () {
        proController.product.value = null;

        Navigator.of(context).pushNamed(
          Routes.details,
          arguments:
              DetailProductArguments(idProduct: product.id, product: product),
        );
      },
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 200,
          ),
          child: Container(
            margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
            width: 200,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0)),
                            child: product.image.isNotEmpty &&
                                    product.image[0] != null
                                ? Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/images/_project/Account/black_dog.png",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        if (product.quantity > 0)
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(192, 228, 42, 29),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: InkWell(
                                onTap: () => _handleAddDirectly(product),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // if (product.promotion != null)
                        //   Positioned(
                        //     bottom: 0,
                        //     right: 0,
                        //     child: RoundedContainer(
                        //       radius: 10,
                        //       backgroundColor: Colors.purple.withOpacity(1),
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 8.0, vertical: 4),
                        //       child: Text(
                        //         '${product.promotion}% Discount',
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .labelLarge!
                        //             .apply(color: Colors.black),
                        //       ),
                        //     ),
                        //   ),
                        // Positioned(
                        //   top: 4,
                        //   left: 0,
                        //   child: RoundedContainer(
                        //     radius: 10,
                        //     backgroundColor: Colors.amber,
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 8.0, vertical: 4),
                        //     child: Row(
                        //       children: [
                        //         Icon(Icons.star, size: 16, color: Colors.red),
                        //         SizedBox(width: 4),
                        //         product.promotion == 0
                        //             ? Text(
                        //                 '5.0',
                        //                 style: Theme.of(context)
                        //                     .textTheme
                        //                     .labelLarge!
                        //                     .apply(color: Colors.black),
                        //               )
                        //             : Text(
                        //                 '${product.promotion}% Discount',
                        //                 style: Theme.of(context)
                        //                     .textTheme
                        //                     .labelLarge!
                        //                     .apply(color: Colors.black),
                        //               ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 30,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.yellow[300]),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsetsDirectional.zero),
                                ),
                                onPressed: () {},
                                child: Text(
                                  product.category.slug,
                                  style: TextStyle(
                                    fontSize: 7,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${TransformCustomApp().formatCurrency(product.promotion.toInt())}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 217, 123, 117),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleAddDirectly(Product product) {
    if (product.quantity != 0) {
      CartController.instance.addToCart(product.id, 1, product.price);
    }
  }
}
