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
  final TextEditingController _logController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAuditLogs();
  }

  @override
  void dispose() {
    _logController.dispose();
    super.dispose();
  }

  Future<void> _fetchAuditLogs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      
      final response = await ApiService.getAuditLogs(widget.username);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            auditLogs = List<dynamic>.from(data ?? []);
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

  Future<void> _createLog() async {
    try {
      if (_logController.text.isEmpty) return;
      
      setState(() => isLoading = true);
      final response = await ApiService.createLog(
        officialUsername: widget.username,
        leg: _logController.text,
      );

      if (response.statusCode == 200) {
        _logController.clear();
        await _fetchAuditLogs(); // Refresh the list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Log created successfully')),
          );
        }
      } else {
        throw Exception('Failed to create log: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      debugPrint('Error creating log: $e');
    }
  }

  Widget _buildLogItem(dynamic log) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          log['leg']?.toString() ?? 'No action',
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
              'User: ${log['official_username']?.toString() ?? 'Unknown'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Date: ${log['timestamp']?.toString() ?? 'Unknown'}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateLogDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Log'),
        content: TextField(
          controller: _logController,
          decoration: const InputDecoration(
            labelText: 'Log Action',
            hintText: 'Enter log description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _createLog();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audit Logs"),
        backgroundColor: const Color(0xFF000E53),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateLogDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchAuditLogs,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateLogDialog,
        child: const Icon(Icons.add),
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
            ElevatedButton(
              onPressed: _showCreateLogDialog,
              child: const Text('Create First Log'),
            ),
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