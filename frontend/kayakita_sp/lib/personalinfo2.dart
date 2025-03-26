import 'package:flutter/material.dart';
import 'application.dart';
import 'widgets/customappbar.dart';
import 'widgets/customtextfield.dart';
import 'api_service.dart';
import 'dart:convert';
import 'register.dart';


class SecondPersonalInfoScreen extends StatefulWidget {
  final String email;
  final String password;

  const SecondPersonalInfoScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  _SecondPersonalInfoScreenState createState() => _SecondPersonalInfoScreenState();
}

class _SecondPersonalInfoScreenState extends State<SecondPersonalInfoScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? selectedService;
  bool isLoading = false;
  List<String> availableServices = ["", "Rider", "Driver", "PasaBuy", "Barber", "Carpenter"];

  late Map<String, dynamic> workerData;

  @override
void initState() {
  super.initState();
  workerData = {
    'email': widget.email,
    'password': widget.password,
    'firstName': '',
    'middleInitial': '',
    'lastName': '',
    'contactNumber': '',
    'address': '',
    'service': '',
    'is_certified': 'pending',
  };

  _loadWorkerData();
}

  Future<void> _loadWorkerData() async {
  setState(() {
    isLoading = true;
  });

  try {
    final workerResponse = await ApiService.getWorkers();
    if (workerResponse.statusCode == 200) {
      final List<dynamic> workers = jsonDecode(workerResponse.body);

      final existingWorker = workers.firstWhere(
        (worker) => worker['email'] == widget.email,
        orElse: () => null,
      );

      if (existingWorker != null) {
        setState(() {
          workerData = existingWorker;
          firstNameController.text = existingWorker['first_name'] ?? '';
          middleInitialController.text = existingWorker['middle_initial'] ?? '';
          lastNameController.text = existingWorker['last_name'] ?? '';
          mobileNumberController.text = existingWorker['contact_number'] ?? '';
          addressController.text = existingWorker['address'] ?? '';

          selectedService = existingWorker['service']?.toString() ?? '';

          availableServices = availableServices.where((service) => service != selectedService).toList();
        });
      }

    } else {
      _showErrorMessage("Failed to load worker data.");
    }
  } catch (e) {
    _showErrorMessage("An error occurred: $e");
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}





  @override
  void dispose() {
    firstNameController.dispose();
    middleInitialController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void onContinue() {
    if (firstNameController.text.isEmpty ||
        middleInitialController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        mobileNumberController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedService == null) {
      _showErrorMessage("⚠️ Please fill in all fields.");
      return;
    }

    workerData['firstName'] = firstNameController.text;
    workerData['middleInitial'] = middleInitialController.text;
    workerData['lastName'] = lastNameController.text;
    workerData['contactNumber'] = mobileNumberController.text;
    workerData['address'] = addressController.text;
    workerData['service'] = selectedService!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationScreen(workerData: workerData),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Personal Information'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Worker Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'First Name', controller: firstNameController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Middle Initial', controller: middleInitialController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Last Name', controller: lastNameController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Mobile Number', controller: mobileNumberController),
            const SizedBox(height: 10),
            CustomTextField(hintText: 'Address', controller: addressController),
            const SizedBox(height: 20),

            Text(
              'Select Service',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF87027B),
                  ),
            ),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.purple.shade50, 
              ),
              value: availableServices.contains(selectedService) ? selectedService : null,
              hint: const Text("Choose a service"),
              items: availableServices.where((s) => s.isNotEmpty).map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(
                    service,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF87027B), 
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedService = newValue;
                });
              },
            ),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF87027B), 
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
