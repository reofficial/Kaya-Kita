import 'package:flutter/material.dart';
import 'dart:developer';
import 'application.dart';

import '../widgets/customappbar.dart';
import '../widgets/customtextfield.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String username;
  final String password;
  final String email;

  const PersonalInfoScreen({
    super.key,
    required this.username,
    required this.password,
    required this.email,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String dropdownValue = services.first; // Default value

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _mobileNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('Entered PersonalInfoScreen');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(titleText: 'Personal Information'),
      body: Stack(
        children: [
          Positioned(
            bottom: -30,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/personalinfo.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Worker Details',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'First Name',
                        controller: _firstNameController,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Middle Initial',
                        controller: _middleNameController,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Last Name',
                        controller: _lastNameController,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Mobile Number',
                        controller: _mobileNumberController,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'Address',
                        controller: _addressController,
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Service Preference',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 10),
                      ServicesDropdownMenu(
                        value: dropdownValue,
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                      SizedBox(height: 60),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApplicationScreen(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  mobileNumber: _mobileNumberController.text,
                                  address: _addressController.text,
                                  service: dropdownValue,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Continue',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

const List<String> services = <String>[
  'Rider',
  'Driver',
  'PasaBuy',
  'Barber',
  'Carpenter'
];

class ServicesDropdownMenu extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const ServicesDropdownMenu({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: SizedBox(), // Remove the default underline
        onChanged: onChanged,
        items: services.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
      ),
    );
  }
}
