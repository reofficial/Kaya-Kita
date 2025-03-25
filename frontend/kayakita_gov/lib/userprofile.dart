import 'package:flutter/material.dart';
import 'dart:convert';

import 'api_service.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  final bool isWorker;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.isWorker,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class UserDetails {
  final String firstName;
  final String middleInitial;
  final String lastName;
  final String address;
  final String suspensionStatus;

  UserDetails({
    required this.firstName,
    required this.middleInitial,
    required this.lastName,
    required this.address,
    required this.suspensionStatus,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      firstName: json['first_name'] ?? '',
      middleInitial: json['middle_initial'] ?? '',
      lastName: json['last_name'] ?? '',
      address: json['address'] ?? '',
      suspensionStatus: json['suspension_status'] ?? 'No',
    );
  }
}

class Review {
  final String workerUsername;
  final String customerUsername;
  final int rating;
  final String reviewText;

  Review({
    required this.workerUsername,
    required this.customerUsername,
    required this.rating,
    required this.reviewText,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      workerUsername: json['worker_username'] ?? '',
      customerUsername: json['customer_username'] ?? '',
      rating: json['rating'] ?? 0,
      reviewText: json['review'] ?? '',
    );
  }
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<UserDetails> _userDetailsFuture;
  late Future<List<Review>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = _fetchUserDetails();
    _reviewsFuture = _fetchReviews();
  }

  Future<UserDetails> _fetchUserDetails() async {
    try {
      final response = widget.isWorker
          ? await ApiService.getWorkers()
          : await ApiService.getCustomers();
      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        Map<String, dynamic>? matchedUser = users.firstWhere(
          (user) => user['username'] == widget.username,
          orElse: () => null,
        );
        if (matchedUser != null) {
          return UserDetails(
            firstName: matchedUser['first_name'] ?? '',
            middleInitial: matchedUser['middle_initial'] ?? '',
            lastName: matchedUser['last_name'] ?? '',
            address: matchedUser['address'] ?? '',
            suspensionStatus: matchedUser['is_suspended'] ?? '',
          );
        } else {
          throw Exception('No matching user found');
        }
      } else {
        throw Exception('${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }

  Future<List<Review>> _fetchReviews() async {
    try {
      final response = widget.isWorker
          ? await ApiService.getWorkerReviews(widget.username)
          : await ApiService.getCustomerReviews(widget.username);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Review.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      throw Exception('Error fetching reviews: $e');
    }
  }

  void _showBanDialog(UserDetails user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manage User Ban'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current status: ${user.suspensionStatus}'),
              const SizedBox(height: 20),
              const Text('Select ban option:'),
            ],
          ),
          actions: [
            if (user.suspensionStatus != 'No')
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  //_updateSuspensionStatus('No');
                },
                child: const Text('Remove Ban'),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                //_updateSuspensionStatus('Temporary');
              },
              child: const Text('Temporary Ban'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                //_updateSuspensionStatus('Permanent');
              },
              child: const Text('Permanent Ban'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isWorker
                  ? 'From: ${review.customerUsername}'
                  : 'To: ${review.workerUsername}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            _buildRatingStars(review.rating),
            const SizedBox(height: 8),
            Text(
              review.reviewText,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isWorker ? 'Worker Details' : 'Customer Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<UserDetails>(
              future: _userDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('No user details available')),
                  );
                }

                final user = snapshot.data!;
                return Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${user.firstName} ${user.middleInitial.isNotEmpty ? '${user.middleInitial}. ' : ''}${user.lastName}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.gavel),
                              onPressed: () => _showBanDialog(user),
                              tooltip: 'Manage Ban',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                user.address,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.warning, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Is Suspended: ${user.suspensionStatus}',
                              style: TextStyle(
                                fontSize: 16,
                                color: user.suspensionStatus == 'Permanent'
                                    ? Colors.red
                                    : user.suspensionStatus == 'Temporary'
                                        ? Colors.orange
                                        : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.isWorker ? 'Reviews Received' : 'Reviews Given',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<Review>>(
              future: _reviewsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'No reviews available',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }

                return Column(
                  children: snapshot.data!
                      .map((review) => _buildReviewCard(review))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
