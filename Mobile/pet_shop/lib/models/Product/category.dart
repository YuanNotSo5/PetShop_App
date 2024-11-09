import 'dart:convert';

class Category {
  final String id;
  final String name;
  final String description;
  final String slug;
  final String image;

  factory Category.fromJson(Map<String, dynamic> data) => Category(
        id: data['_id'],
        name: data['name'] ?? "",
        image: data['image'] ??
            "https://pbs.twimg.com/profile_images/497929479063224320/LuzRK4sp_400x400.jpeg",
        description: data['description'] ?? "",
        slug: data['slug'] ?? "",
      );

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.slug,
    required this.image,
  });
}

List<Category> categoryListFromJson(String val) {
  final data = jsonDecode(val);
  final docs = data['data']['docs'] as List<dynamic>;
  return List<Category>.from(docs.map((cate) => Category.fromJson(cate)));
}
