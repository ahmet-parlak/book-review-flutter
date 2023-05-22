import 'package:book_review/models/create_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/review_model.dart';

class ReviewFormWidget extends StatefulWidget {
  const ReviewFormWidget({Key? key, this.currentReview}) : super(key: key);
  final Review? currentReview;
  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();
}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {
  late int reviewRating;
  bool ratingError = false;
  String ratingErrorMessage = '';
  bool isEditing = false;
  late final TextEditingController reviewTextController;
  late final String formSubmitButtonText;
  @override
  void initState() {
    if (widget.currentReview != null) isEditing = true;
    reviewRating = widget.currentReview?.rating ?? 0;
    formSubmitButtonText =
        widget.currentReview != null ? 'Düzenlemeyi Kaydet' : 'Değerlendir';
    reviewTextController =
        TextEditingController(text: widget.currentReview?.review);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double initialRating = widget.currentReview?.rating?.toDouble() ?? 0;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: 4.5,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: initialRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 36,
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
                  const SizedBox(height: 20.0),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                  if (ratingError)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(ratingErrorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                          overflow: TextOverflow.clip),
                    ),
                  const SizedBox(height: 14),
                  isEditing
                      ? ElevatedButton(
                          onPressed: () {
                            if (reviewRating == widget.currentReview!.rating &&
                                reviewTextController.value.text.trim() ==
                                    (widget.currentReview!.review ?? '')) {
                              setState(() {
                                ratingErrorMessage =
                                    'Değerlendirmenizde bir değişiklik yapmadınız!';
                                ratingError = true;
                              });
                            } else {
                              final review = CreateReview(
                                  rating: reviewRating,
                                  review:
                                      reviewTextController.value.text.trim());
                              Navigator.pop(context, review);
                            }
                          },
                          child: Text(formSubmitButtonText))
                      : ElevatedButton(
                          onPressed: () {
                            if (reviewRating == 0) {
                              setState(() {
                                ratingErrorMessage =
                                    'Değerlendirmek yapmak için kitaba puan verin!';
                                ratingError = true;
                              });
                            } else {
                              final review = CreateReview(
                                  rating: reviewRating,
                                  review:
                                      reviewTextController.value.text.trim());
                              Navigator.pop(context, review);
                            }
                          },
                          child: Text(formSubmitButtonText)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
