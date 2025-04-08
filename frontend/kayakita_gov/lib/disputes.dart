import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'api_service.dart';

class DisputesScreen extends StatefulWidget {
  const DisputesScreen({super.key});

  @override
  State<DisputesScreen> createState() => _DisputesScreenState();
}

class _DisputesScreenState extends State<DisputesScreen> {
  List<Map<String, dynamic>> _disputes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDisputes();
  }

  Future<void> _fetchDisputes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _disputes = [];
    });

    try {
      final response = await ApiService.getDisputes();

      if (response.statusCode == 200) {
        final List<dynamic> rawData = jsonDecode(response.body);
        _processData(rawData);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: ${e.toString()}';
      });
    }
  }

  void _processData(List<dynamic> rawData) {
    final List<Map<String, dynamic>> validDisputes = [];

    for (var item in rawData) {
      try {
        if (item is! Map<String, dynamic>) continue;

        final dispute = Map<String, dynamic>.from(item);
        if (_isValidDispute(dispute)) {
          dispute['created_at'] = _parseDateTime(dispute['created_at']);
          validDisputes.add(dispute);
        }
      } catch (e) {
        continue;
      }
    }

    setState(() {
      _disputes = validDisputes;
      _isLoading = false;
    });
  }

  bool _isValidDispute(Map<String, dynamic> dispute) {
    if (dispute['dispute_id'] == null) return false;
    if (dispute['ticket_number'] == null) return false;
    if (dispute['reason'] == null || dispute['reason'].isEmpty) return false;
    if (dispute['description'] == null || dispute['description'].isEmpty) {
      return false;
    }
    if (dispute['dispute_status'] == null || dispute['reason'].isEmpty) {
      return false;
    }

    try {
      if (dispute['created_at'] == null) return false;
      DateTime.parse(dispute['created_at']);
    } catch (e) {
      return false;
    }

    return true;
  }

  DateTime? _parseDateTime(dynamic dateTime) {
    try {
      if (dateTime == null) return null;
      if (dateTime is DateTime) return dateTime;
      if (dateTime is String) return DateTime.parse(dateTime);
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disputes'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchDisputes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_disputes.isEmpty) {
      return const Center(child: Text('No valid disputes found'));
    }

    return RefreshIndicator(
      onRefresh: _fetchDisputes,
      child: ListView.builder(
        itemCount: _disputes.length,
        itemBuilder: (context, index) {
          return _buildDisputeCard(_disputes[index]);
        },
      ),
    );
  }

  Widget _buildDisputeCard(Map<String, dynamic> dispute) {
    final createdAt = dispute['created_at'] as DateTime?;
    final formattedDate = createdAt != null
        ? DateFormat('MMM dd, yyyy - hh:mm a').format(createdAt)
        : 'Date not available';

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dispute #${dispute['dispute_id']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(dispute['dispute_status']),
                  backgroundColor: _getStatusColor(dispute['dispute_status']),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Ticket #${dispute['ticket_number']}'),
            const SizedBox(height: 8),
            _buildUserInfoRow(
              icon: Icons.person,
              label: 'Worker: ${dispute['worker_username'] ?? 'Not specified'}',
            ),
            _buildUserInfoRow(
              icon: Icons.person_outline,
              label:
                  'Customer: ${dispute['customer_username'] ?? 'Not specified'}',
            ),
            const SizedBox(height: 12),
            _buildLabeledText('Reason:', dispute['reason']),
            _buildLabeledText('Description:', dispute['description']),
            if (dispute['solution'] != null && dispute['solution'].isNotEmpty)
              _buildLabeledText('Solution:', dispute['solution']),
            const SizedBox(height: 12),
            Text(
              'Created: $formattedDate',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget _buildLabeledText(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value ?? 'Not available'),
        const SizedBox(height: 8),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Under Review':
        return Colors.orange[100]!;
      case 'Resolved':
        return Colors.green[100]!;
      case 'Rejected':
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }
}
