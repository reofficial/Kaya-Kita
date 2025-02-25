import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starter/api_service.dart';
import 'package:provider/provider.dart';
import 'package:starter/jobinfo.dart';
import 'package:starter/providers/profile_provider.dart';
import 'dart:convert';

class JobEditScreen extends StatefulWidget {
  const JobEditScreen({
    super.key,
    required this.jobId,
  });

  final int jobId;

  @override
  State<JobEditScreen> createState() => _JobEditScreenState();
}

class _JobEditScreenState extends State<JobEditScreen> {
  late String username; // Declare username here

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  String? selectedCategory;
  String? selectedRateType;
  String? selectedDuration;
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    fetchJobListing();
  }

  Future<void> fetchJobListing() async {
    try {
      final response = await ApiService.getJobListing(widget.jobId);
      if (response.statusCode == 200) {
        final jobListing = json.decode(response.body)[0];

        // Validate and set the fetched values
        setState(() {
          titleController.text = jobListing['job_title'];
          descriptionController.text = jobListing['description'];
          rateController.text = jobListing['salary'].toString();

          // Validate selectedCategory
          selectedCategory = categories.contains(jobListing['tag'].isNotEmpty)
              ? jobListing['tag'][0]
              : null;

          // Validate selectedRateType
          selectedRateType = rateTypes.contains(jobListing['salary_frequency'])
              ? jobListing['salary_frequency']
              : null;

          // Validate selectedDuration
          selectedDuration = durations.contains(jobListing['duration'])
              ? jobListing['duration']
              : null;

          // Validate selectedLocation
          selectedLocation = locations.contains(jobListing['location'])
              ? jobListing['location']
              : null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Failed to fetch job listing: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching job listing: $e")),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    rateController.dispose();
    super.dispose();
  }

  final List<String> categories = [
    'Business',
    'Construction',
    'Education',
    'Entertainment',
    'Health',
    'Housework',
    'Food',
    'Technology',
    'Transport',
    'Others'
  ];
  final List<String> durations = ['Short-term', 'Long-term', 'Flexible'];
  final List<String> locations = ['Makati City', 'Taguig City', 'Pasay City'];
  final List<String> rateTypes = ['Hourly', 'Daily', 'Weekly', 'Monthly'];

  Future<void> handleUpdate() async {
    try {
      Map<String, dynamic> jobListing = {
        'job_id': widget.jobId,
        'username': username,
        'tag': [selectedCategory],
        'job_title': titleController.text,
        'description': descriptionController.text,
        'location': selectedLocation,
        'salary': rateController.text,
        'salary_frequency': selectedRateType,
        'duration': selectedDuration,
      };

      final response = await ApiService.updateJobListing(jobListing);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job Listing updated successfully.")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JobInfoScreen(jobId: widget.jobId),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating Job Listing: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    username = Provider.of<UserProvider>(context, listen: false).username;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Post', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/kamala.png'),
                    radius: 25,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Posting as $username:',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildTextField(
                'Write your header here.',
                50,
                titleController,
                isRequired: true,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                'Write your post or question here.',
                120,
                descriptionController,
                isRequired: true,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDropdown('Add Category', categories, selectedCategory,
                      (value) => setState(() => selectedCategory = value),
                      width: 180, isRequired: true),
                  _buildRateDropdown(isRequired: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDropdown('Add Duration', durations, selectedDuration,
                      (value) => setState(() => selectedDuration = value),
                      width: 180, isRequired: true),
                  _buildDropdown('Add Location', locations, selectedLocation,
                      (value) => setState(() => selectedLocation = value),
                      width: 180, isRequired: true),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.add_photo_alternate, color: Colors.black),
                  const SizedBox(width: 5),
                  const Text('Add media',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (selectedCategory == null ||
                        selectedDuration == null ||
                        selectedLocation == null ||
                        titleController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        rateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      handleUpdate();
                    }
                  },
                  child: const Text('Post',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint, double height, TextEditingController controller,
      {bool isRequired = false}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: controller,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 10),
                ),
              ),
            ),
          ),
          if (isRequired)
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: const Text('*',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged,
      {double width = 150, bool isRequired = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              hint: Text(hint),
              value: selectedValue,
              items: items
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child:
                  Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
        ],
      ),
    );
  }

  Widget _buildRateDropdown({bool isRequired = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: rateController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'Rate',
                  border: InputBorder.none,
                ),
              ),
            ),
            const Text(' / ', style: TextStyle(fontSize: 16)),
            IntrinsicWidth(
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: selectedRateType,
                    items: ['Hourly', 'Daily', 'Weekly', 'Monthly']
                        .map((rate) =>
                            DropdownMenuItem(value: rate, child: Text(rate)))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedRateType = value ?? 'Monthly'),
                    underline: const SizedBox(),
                  ),
                  if (isRequired)
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 5), // Space between dropdown and *
                      child: Text('*',
                          style: TextStyle(color: Colors.red, fontSize: 16)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
