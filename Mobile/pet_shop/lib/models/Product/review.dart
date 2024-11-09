import 'dart:convert';

class Review {
  final String id;
  final String userId; // Thay vì dynamic user, chỉ sử dụng userId và username
  final String username;
  final String product;
  final String comment;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.username,
    required this.product,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> data) {
    // Kiểm tra nếu 'user' là null
    final user = data['user'];
    final String userId = user != null ? user['_id'] : 'Unknown';
    final String username = user != null ? user['username'] : 'Unknown';

    return Review(
      id: data['_id'],
      userId: userId,
      username: username,
      product: data['product'],
      comment: data['comment'],
      rating: data['rating'].toDouble(),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'Review{id: $id, userId: $userId, username: $username, '
        'product: $product, comment: $comment, rating: $rating, '
        'createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}

List<Review> reviewsListFromJson(String val) {
  final data = json.decode(val);
  return List<Review>.from(data.map((review) => Review.fromJson(review)));
}
