import 'package:flutter/material.dart';
import 'package:starter/api_service.dart';

class CompletedJobScreen extends StatefulWidget {
  const CompletedJobScreen({
    super.key,
    required this.ticketNumber,
    required this.datetime,
    required this.customer,
    required this.handyman,
    required this.jobStatus,
    required this.paymentStatus,
  });

  final int ticketNumber;
  final String datetime;
  final String customer;
  final String handyman;
  final String jobStatus;
  final String paymentStatus;

  @override
  State<CompletedJobScreen> createState() => _CompletedJobScreenState();
}

class _CompletedJobScreenState extends State<CompletedJobScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  bool _isRatingError = false;
  bool _isTitleError = false;
  bool _isReviewError = false;

  Future<void> _submitReview() async {
    setState(() {
      _isRatingError = _rating == 0;
      _isTitleError = _titleController.text.trim().isEmpty;
      _isReviewError = _reviewController.text.trim().isEmpty;
    });

    if (_isRatingError || _isTitleError || _isReviewError) return;

    try {
      String currentDateTime = DateTime.now().toString();

      Map<String, dynamic> reviewDetails = {
        "review_id": 0,
        "rating": _rating,
        "created_at": currentDateTime,
        "customer_username": widget.customer,
        "worker_username": widget.handyman,
        "review": _reviewController.text,
      };

      final response = await ApiService.postReview(reviewDetails);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Review submitted successfully")),
        );
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting review: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Placeholder data (Modify later when passing actual data)
    String workerName = widget.handyman;
    String jobTime = widget.datetime;
    double workerRate = 100.0;
    double hoursWorked = 4.5;
    double tip = 50.0;
    double totalAmount = workerRate * hoursWorked + tip;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Details", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Completed Header
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Completed",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      jobTime,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Receipt Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Receipt",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildReceiptRow(
                        "Worker Rate", "P $workerRate x $hoursWorked hours"),
                    _buildReceiptRow("Tip", "P $tip", hasLink: true),
                    _buildReceiptRow("Total", "P $totalAmount",
                        isBold: true, color: Colors.purple),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Worker Profile Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Worker",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              workerName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.verified,
                                color: Colors.purple, size: 18),
                          ],
                        ),
                        const Text(
                          "View profile",
                          style: TextStyle(color: Colors.purple, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Submit Feedback Section (WITH STARS, TITLE, REVIEW)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Submit Feedback",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // ⭐ Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.0;
                              _isRatingError = false;
                            });
                          },
                        );
                      }),
                    ),
                    if (_isRatingError)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "⚠️ Please select a rating.",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // 📝 Title Input
                    const Text(
                      "Title:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Enter a title (e.g., 'Great Job!')",
                        errorText:
                            _isTitleError ? "⚠️ Please provide a title." : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isTitleError = false;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // 💬 Review Input
                    const Text(
                      "Leave a review:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Write your review here...",
                        errorText:
                            _isReviewError ? "⚠️ Please write a review." : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isReviewError = false;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // ✅ Submit Review Button
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
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
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Helper function for receipt row
  Widget _buildReceiptRow(String label, String value,
      {bool isBold = false, Color? color, bool hasLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: color ?? Colors.black)),
        ],
      ),
    );
  }
}
