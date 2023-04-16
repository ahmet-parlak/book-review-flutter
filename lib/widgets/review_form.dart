import 'package:book_review/models/create_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewFormWidget extends StatefulWidget {
  const ReviewFormWidget({Key? key}) : super(key: key);

  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();
}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {
  int reviewRating = 0;
  bool ratingError = false;

  final TextEditingController reviewTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, top: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 24,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    reviewRating = rating.toInt();
                    ratingError = false;
                  });
                },
              ),
              const SizedBox(height: 12.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                child: TextField(
                  controller: reviewTextController,
                  keyboardType: TextInputType.multiline,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Görüşlerinizi bildirin (opsiyonel)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              if (ratingError)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                      'Değerlendirmede bulunmak için kitaba puan verin!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                      overflow: TextOverflow.clip),
                ),
              ElevatedButton(
                  onPressed: () {
                    if (reviewRating == 0) {
                      setState(() {
                        ratingError = true;
                      });
                    } else {
                      Navigator.pop(
                          context,
                          CreateReview(
                              rating: reviewRating,
                              review: reviewTextController.value.text.trim()));
                    }
                  },
                  child: const Text('Değerlendir'))
            ],
          ),
        ),
      ),
    );
  }
}
