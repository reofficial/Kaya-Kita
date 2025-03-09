import 'package:flutter/material.dart';

class RatingReviewScreen extends StatefulWidget {
  final int jobId;

  const RatingReviewScreen({super.key, required this.jobId});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isRatingError = false; // Track rating validation
  bool _isReviewError = false; // Track review validation

  void _submitReview() {
    // Reset error states
    setState(() {
      _isRatingError = _rating == 0; // Rating is required
      _isReviewError = _reviewController.text.trim().isEmpty; // Review is required
    });

    // If there are validation errors, stop submission
    if (_isRatingError || _isReviewError) {
      return;
    }

    // Save the rating and review (logic to be implemented later)
    final review = {
      'jobId': widget.jobId,
      'rating': _rating,
      'review': _reviewController.text.trim(),
    };
    print("Review submitted: $review");

    // Navigate back or show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Review submitted successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate and Review", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF87027B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How would you rate this job?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                      _isRatingError = false; // Reset rating error when user selects a rating
                    });
                  },
                );
              }),
            ),
            if (_isRatingError) // Show error message if rating is missing
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Please select a rating.",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              "Leave a review:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Write your review here...",
                errorText: _isReviewError ? "Please write a review." : null, // Show error if review is missing
              ),
              onChanged: (value) {
                setState(() {
                  _isReviewError = false; // Reset review error when user starts typing
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87027B),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  "Submit Review",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}