import 'package:flutter/material.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  String? selectedCategory;
  String? selectedRate;
  String? selectedDuration;
  String? selectedLocation;

  final List<String> categories = ['Rider', 'Driver', 'Barber', 'Laundry', 'Other'];
  final List<String> durations = ['Short-term', 'Long-term', 'Flexible'];
  final List<String> locations = ['Makati', 'Taguig', 'Pasay'];
  
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
      body: Padding(
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
            _buildTextField('Write your header here.', 50),
            const SizedBox(height: 10),
            _buildTextField('Write your post or question here.', 120),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdown('Add Category', categories, selectedCategory, (value) => setState(() => selectedCategory = value), width: 180),
                _buildDropdown('Add Ideal Rate', categories, selectedRate, (value) => setState(() => selectedRate = value), width: 180), 
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdown('Add Duration', durations, selectedDuration, (value) => setState(() => selectedDuration = value), width: 180),
                _buildDropdown('Add Location', locations, selectedLocation, (value) => setState(() => selectedLocation = value), width: 180), 
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
                onPressed: () {},
                child: const Text('Post', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          maxLines: null,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? selectedValue, ValueChanged<String?> onChanged, {double width = 150}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        hint: Text(hint),
        value: selectedValue,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        isExpanded: true,
        underline: const SizedBox(),
      ),
    );
  }
}