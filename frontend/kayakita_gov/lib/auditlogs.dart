import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';

class AuditLogsScreen extends StatefulWidget {
  final String username;

  const AuditLogsScreen({super.key, required this.username});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  List<dynamic> auditLogs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAuditLogs();
  }

  Future<void> _fetchAuditLogs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await ApiService.getAuditLogs();

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            if (data is Map<String, dynamic>) {
              auditLogs = [data];
            } else if (data is List<dynamic>) {
              auditLogs = List<dynamic>.from(data);
            } else {
              auditLogs = [];
            }
            isLoading = false;
          });
        }
      } else {
        throw Exception('Server responded with ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load logs: ${e.toString()}';
        });
      }
      debugPrint('Error fetching audit logs: $e');
    }
  }

  Widget _buildLogItem(dynamic log) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          log['log']?.toString() ?? 'No action',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              'Official: ${log['official_username']?.toString() ?? 'Unknown'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            // Text(
            //   'Date: ${log['timestamp']?.toString() ?? 'Unknown'}',
            //   style: TextStyle(color: Colors.grey[600]),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audit Logs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAuditLogs,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchAuditLogs,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (auditLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "No logs available",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAuditLogs,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: auditLogs.length,
        itemBuilder: (context, index) => _buildLogItem(auditLogs[index]),
      ),
    );
  }
}
