import 'package:flutter/material.dart';
import 'package:starter/home.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreen();
}

class _NewPostScreen extends State<NewPostScreen> {
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<String> categories = ['Rider', 'Driver', 'Barber', 'Laundry', 'Other'];
    String? selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Post',
          style:
              TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF000000)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Profile picture and username
            Row(
              children: [
                Icon(Icons.account_circle, size: 60), 
                SizedBox(width: 10), Text('(username)', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)
              ],
            ),
            // Text fields
            CustomTextField(hintText: 'Write your header here.', height: 50),
            CustomTextField(hintText: 'Write your post or question here.', height: 200),
            
            // Dropdowns
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Categories
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: DropdownButton<String>(
                    padding: EdgeInsets.only(left: 10),
                    hint: Text('Add Category'),
                    value: selectedCategory,
                    items: categories.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(), 
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    underline: SizedBox()
                  )
                ),

                // Ideal Rate
                CustomDropdown(
                  items: categories, 
                  hint: 'Add Ideal Rate',
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                )
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Categories
                CustomDropdown(
                  items: categories, 
                  hint: 'Add Category',
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),

                // Ideal Rate
                CustomDropdown(
                  items: categories, 
                  hint: 'Add Ideal Rate',
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                )
              ],
            )
            
          ],
        ),
      )
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText, required this.height});

  final double height;
  final String hintText;
  final Color borderColor = const Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        maxLines: 8,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Roboto', 
            color: Colors.black87.withAlpha(95),
          ),
          filled: true,
          fillColor: borderColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xFF87027B)),
          ),
        ),
      )
    );
  }
}


class CustomDropdown extends StatelessWidget {
  const CustomDropdown({super.key, required this.items, required this.hint, required this.onChanged});

  final List<String> items;
  final String hint;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(10)
      ),
      child: DropdownButton(
        padding: EdgeInsets.only(left: 10),
        hint: Text(hint),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(), 
        onChanged: onChanged
      )
    );
  }
}