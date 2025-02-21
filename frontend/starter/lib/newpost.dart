import 'package:flutter/material.dart';
import 'jobinfo.dart';
import 'package:flutter/services.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String? selectedCategory;
  TextEditingController rateController = TextEditingController();
  String selectedRateType = 'Monthly';
  String? selectedDuration;
  String? selectedLocation;

  final List<String> categories = ['Business', 'Construction', 'Education', 'Entertainment', 'Health', 'Housework', 'Food', 'Technology', 'Transport', 'Others'];
  final List<String> durations = ['Short-term', 'Long-term', 'Flexible'];
  final List<String> locations = ['Makati City', 'Taguig City', 'Pasay City'];
  final List<String> rateTypes = ['Hourly', 'Daily', 'Weekly', 'Monthly'];
  
  @override
  Widget build(BuildContext context) {
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
        child:Padding(
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
                  const Text(
                    'Kamala Harris',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildTextField('Write your header here.', 50, isRequired: true),
              const SizedBox(height: 10),
              _buildTextField('Write your post or question here.', 120, isRequired: true),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDropdown('Add Category', categories, selectedCategory, (value) => setState(() => selectedCategory = value), width: 180, isRequired: true),
                  _buildRateDropdown(isRequired: true) 
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDropdown('Add Duration', durations, selectedDuration, (value) => setState(() => selectedDuration = value), width: 180, isRequired: true),
                  _buildDropdown('Add Location', locations, selectedLocation, (value) => setState(() => selectedLocation = value), width: 180, isRequired: true), 
                ],
              ),


              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.add_photo_alternate, color: Colors.black),
                  const SizedBox(width: 5),
                  const Text('Add media', style: TextStyle(color: Colors.black)),
                ],
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (selectedCategory == null || 
                        selectedDuration == null || 
                        selectedLocation == null || 
                        rateController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all required fields'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JobInfoScreen()),
                      );
                    }
                  },
                  child: const Text('Post', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildTextField(String hint, double height, {bool isRequired = false}) {
    TextEditingController controller = TextEditingController();

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
                  contentPadding: EdgeInsets.only(top: 10),
                ),
              ),
            ),
          ),
          if (isRequired)
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
        ],
      ),
    );
  }




  Widget _buildDropdown(String hint, List<String> items, String? selectedValue, ValueChanged<String?> onChanged, {double width = 150, bool isRequired = false}) {
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
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
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
                        .map((rate) => DropdownMenuItem(value: rate, child: Text(rate)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedRateType = value ?? 'Monthly'),
                    underline: const SizedBox(),
                  ),
                  if (isRequired)
                    const Padding(
                      padding: EdgeInsets.only(left: 5), // Space between dropdown and *
                      child: Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
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