import 'package:flutter/material.dart';

class IncomingWorkerScreen extends StatefulWidget {
  const IncomingWorkerScreen({
    super.key,
    required this.worker,
  });

  final Map<String, dynamic>? worker;

  @override
  State<IncomingWorkerScreen> createState() => _IncomingWorkerScreenState();
}

class _IncomingWorkerScreenState extends State<IncomingWorkerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Incoming Worker',
          style:
              TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}