import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet_shop/config/validators/transform.dart';
import 'package:pet_shop/models/Product/review.dart';
import 'package:intl/intl.dart';

class UserReviewCard extends StatelessWidget {
  final Review item;
  const UserReviewCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage:
                      AssetImage("assets/images/_project/Logo/logo.png"),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          item.username,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.more_vert),
                        // ),
                      ],
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: item.rating,
                          itemSize: 20,
                          unratedColor: Colors.grey,
                          itemBuilder: (_, __) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          '${TransformCustomApp().formateDateTime(item.createdAt)}',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        //Review

        SizedBox(
          height: 15,
        ),
        Text('${item.comment}'),
        SizedBox(
          height: 20,
        ),
        Divider()
      ],
    );
  }
}
