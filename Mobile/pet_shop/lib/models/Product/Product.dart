import 'dart:convert';
import 'package:pet_shop/models/Product/category.dart';

List<Product> productListFromJson(String val) {
  final data = jsonDecode(val);
  final docs = data['data']['docs'] as List<dynamic>;
  return List<Product>.from(docs.map((product) => Product.fromJson(product)));
}

List<Product> productFavListFromJson(String val) {
  final data = jsonDecode(val);
  final docs = data['data'] as List<dynamic>;
  return List<Product>.from(docs.map((product) => Product.fromJson(product)));
}

List<Product> productListInCate(String val) {
  final data = jsonDecode(val);
  final docs = data['data']['docs'] as List<dynamic>;
  return List<Product>.from(docs.map((product) => Product.fromJson(product)));
}

List<Product> productListRecommendedFromJson(String val) {
  final data = jsonDecode(val);
  final docs = data['recommendations'] as List<dynamic>;
  return List<Product>.from(docs.map((product) => Product.fromJson(product)));
}

// class Product {
//   final String id;
//   final String name;
//   final String description;
//   final List<String> images;
//   final double price;
//   final double stockPrice;
//   final double discount;
//   final Map<String, double> type;
//   final Category category;
//   final int stockQuantity;

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.images,
//     required this.stockPrice,
//     required this.discount,
//     required this.type,
//     required this.category,
//     required this.stockQuantity,
//   });

//   factory Product.fromJson(Map<String, dynamic> data) {
//     List<String> parsedImages = data["Images"] != null
//         ? List<String>.from(data["Images"])
//         : [
//             "https://pbs.twimg.com/profile_images/497929479063224320/LuzRK4sp_400x400.jpeg",
//             "https://picsum.photos/250?image=9"
//           ];

//     Map<String, double> parsedType = data["Types"] != null
//         ? Map<String, double>.from(data["Types"])
//         : {
//             "màu vàng": 30.0,
//             "màu cam": 304.0,
//           };

//     return Product(
//       id: data["_id"],
//       name: data["ProductName"],
//       description: data["Description"],
//       images: parsedImages,
//       price: data["Price"]
//           .toDouble(), // Ensure price is converted to double if needed
//       stockPrice:
//           data["StockPrice"] != null ? data["StockPrice"].toDouble() : 10234.0,
//       discount: data["Discount"] != null ? data["Discount"].toDouble() : 0.3,
//       type: parsedType,
//       category: Category.fromJson(data["CategoryID"]),
//       stockQuantity: data["StockQuantity"],
//     );
//   }
//   @override
//   String toString() {
//     return 'Product{id: $id, name: $name, description: $description, images: $images, price: $price, stockPrice: $stockPrice, discount: $discount, type: $type, category: $category, stockQuantity: $stockQuantity}';
//   }
// }

// class Product {
//   final String id;
//   final String name;
//   final double price;
//   final double promotion;
//   final int quantity;
//   final String description;
//   final List<String> image;
//   final String slide;
//   final List<String> color;

//   // final Map<String, double> type;
//   final Category category;

//   factory Product.fromJson(Map<String, dynamic> data) {
//     List<String> parsedImages = data["slide"] != null
//         ? List<String>.from(data["slide"])
//         : [
//             "https://pbs.twimg.com/profile_images/497929479063224320/LuzRK4sp_400x400.jpeg",
//             "https://picsum.photos/250?image=9"
//           ];

//     return Product(
//       id: data["_id"],
//       name: data["name"],
//       description: data["description"],
//       image: parsedImages,
//       price: data["price"].toDouble(),
//       category: Category.fromJson(data["category"]),
//       promotion: data['promotion'],
//       quantity: data['quantity'],
//       slide: data['image'],
//       color: data['color'],
//     );
//   }

//   Product({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.promotion,
//     required this.quantity,
//     required this.description,
//     required this.image,
//     required this.slide,
//     required this.color,
//     required this.category,
//   });
//   @override
//   String toString() {
//     return 'Product{id: $id, name: $name, description: $description, images: $image, price: $price,  promotion: $promotion, category: $category, stockQuantity: $quantity}';
//   }
// }

class Product {
  final String id;
  final String name;
  final double price;
  final double promotion;
  final int quantity;
  final String description;
  final String image;
  final List<String> slide;
  final List<String> color;
  final int sold;
  final double rating_point;
  final int number_comment;

  final dynamic category;

  factory Product.fromJson(Map<String, dynamic> data) {
    // Parse list of slides

    List<String> parsedSlides = data["slide"] != null
        ? List<String>.from(data["slide"].where((item) => item != null))
        : ["https://picsum.photos/250?image=9"];
    // Parse list of colors

    List<String> parsedColors =
        data["color"] != null ? List<String>.from(data["color"]) : [];

    // Determine if category is an object or a string
    dynamic parsedCategory;
    if (data["category"] is Map<String, dynamic>) {
      parsedCategory = Category.fromJson(data["category"]);
    } else {
      parsedCategory = data["category"];
    }
    return Product(
      id: data["_id"],
      name: data["name"] ?? "",
      description: data["description"] ?? "",
      image: data['image'] ??
          "https://pbs.twimg.com/profile_images/497929479063224320/LuzRK4sp_400x400.jpeg",
      price: data["price"].toDouble() ?? 0.0,
      // category: Category.fromJson(data["category"]),
      category: parsedCategory,

      promotion: data['promotion'].toDouble() ?? 0.0,
      quantity: data['quantity'] ?? 0,
      slide: parsedSlides,
      color: parsedColors,

      sold: data["sold"],
      rating_point: data["rating_point"].toDouble(),
      number_comment: data["number_comment"],
    );
  }

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.promotion,
    required this.quantity,
    required this.description,
    required this.image,
    required this.slide,
    required this.color,
    required this.category,
    required this.sold,
    required this.rating_point,
    required this.number_comment,
  });

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $image, price: $price, promotion: $promotion, category: $category, stockQuantity: $quantity}';
  }
}
