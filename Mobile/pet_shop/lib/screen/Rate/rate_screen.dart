import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pet_shop/components/Header/header_appbar.dart';
import 'package:pet_shop/config/constant.dart';
import 'package:pet_shop/controllers/Order/order_controller.dart';
import 'package:pet_shop/models/Order/order.dart';
import 'package:readmore/readmore.dart';

class RateScreen extends StatefulWidget {
  final ProductUnreviewed productUnreviewed;
  const RateScreen({Key? key, required this.productUnreviewed})
      : super(key: key);

  @override
  _RateScreenState createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  double _rating = 4.0;
  TextEditingController _commentController = TextEditingController();
  OrderController orderController = Get.find<OrderController>();
  List<String> _selectedTags = [];

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomAppColor.lightBackgroundColor_Home,
      appBar: Header_Appbar(
        context: context,
        name: "Đánh giá ${widget.productUnreviewed.product.name}",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                          widget.productUnreviewed.product.image ??
                              'https://tiki.vn/blog/wp-content/uploads/2023/12/tam-cho-cho-bang-sua-tam-tri-ve-1024x633.jpeg',
                        ),
                        onBackgroundImageError: (error, stackTrace) {
                          setState(() {
                            // Fallback to local asset image on error
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.productUnreviewed.product.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: HtmlWidget(
                          widget.productUnreviewed.product.description,
                          customWidgetBuilder: (element) {
                            return ReadMoreText(
                              element.text,
                              trimLines: 5,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: '\n Xem thêm',
                              trimExpandedText: '\n Thu nhỏ',
                              moreStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Sản phẩm bạn vừa nhận như thế nào',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 40.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Ý kiến của bạn!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ReviewTag(
                            label: 'Đúng với mô tả',
                            isSelected:
                                _selectedTags.contains('Đúng với mô tả'),
                            onTap: () => _toggleTag('Đúng với mô tả'),
                          ),
                          ReviewTag(
                            label: 'Rất thất vọng',
                            isSelected: _selectedTags.contains('Rất thất vọng'),
                            onTap: () => _toggleTag('Rất thất vọng'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _commentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Nhập bình luận của bạn',
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String msg =
                      "${_selectedTags.join(', ')} ${_commentController.text}";
                  var isPostSuccess = orderController.commentProduct(
                      msg,
                      _rating,
                      widget.productUnreviewed.orderId,
                      widget.productUnreviewed.product.id);

                  if (await isPostSuccess) {
                    await orderController.getAllStatusOrder();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Đánh giá',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTag extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ReviewTag({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
