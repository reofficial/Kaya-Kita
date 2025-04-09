import 'package:flutter/material.dart';
import 'api_service.dart';
import 'orders.dart';

class DisputeScreen extends StatefulWidget {
  final String workerUsername;
  final String customerUsername;
  final DateTime createdAt;
  final int ticketNumber;

  const DisputeScreen({
    super.key,
    required this.workerUsername,
    required this.customerUsername,
    required this.createdAt,
    required this.ticketNumber,
  });

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  String? selectedReason;
  String? selectedSolution;
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> reasonOptions = [
    "Poor quality of work",
    "Service not completed",
    "Overcharged",
    "Wrong service provided",
    "Delay in service",
  ];

  final List<String> solutionOptions = [
    "Partial refund",
    "Full refund",
    "Redo service",
    "Discount on next service",
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispute Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField("Reason", selectedReason, reasonOptions,
                (value) => setState(() => selectedReason = value)),
            const SizedBox(height: 16),
            _buildDropdownField("Solution", selectedSolution, solutionOptions,
                (value) => setState(() => selectedSolution = value)),
            const Divider(height: 30),
            const Text("Refund Amount",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("₱500",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Refund To",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("kayakita Balance",
                    style: TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Leave your comments here (optional)',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Optional: Upload a clear photo/video showing the service received for this request to better expedite the process.",
                style: TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMediaUploadBox(Icons.photo, "Add Photo\n0/6"),
                const SizedBox(width: 10),
                _buildMediaUploadBox(Icons.videocam, "Add Video\n0/1"),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final reason = selectedReason;
                final solution = selectedSolution;
                final description = _descriptionController.text;

                if (reason == null || solution == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select both reason and solution'),
                    ),
                  );
                  return;
                }

                try {
                  final response = await ApiService.postDispute({
                    "workerUsername": widget.workerUsername,
                    "customerUsername": widget.customerUsername,
                    "ticketNumber": widget.ticketNumber,
                    "reason": reason,
                    "solution": solution,
                    "description": description,
                    "createdAt": widget.createdAt.toIso8601String(),
                  });

                  if (response.statusCode == 200) {
                    final updateResponse = await ApiService.updateDisputes({
                      "ticketNumber": widget.ticketNumber,
                      "dispute_status": "Under Review",
                    });

                    if (updateResponse.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Dispute submitted successfully')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrdersScreen(raised_dispute: true),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Dispute posted but failed to update status: ${updateResponse.statusCode}')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Failed to submit dispute: ${response.statusCode}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Submit Dispute"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String? value, List<String> options,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaUploadBox(IconData icon, String label) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
