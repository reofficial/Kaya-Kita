import 'package:flutter/material.dart';

import 'declaration.dart';

import '../widgets/customappbar.dart';
import '../widgets/customtextfield.dart';
import '../widgets/labeledcheckbox.dart';

class ApplicationScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String address;
  final String service;

  const ApplicationScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.address,
    required this.service,
  });

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  bool _isPWD = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(titleText: 'Application'),
      body: Stack(
        children: [
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
                        'Hey ${widget.firstName}!',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        'You\'re applying for ${widget.service}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 10),
                      Text('First Name: ${widget.firstName}'),
                      Text('Last Name: ${widget.lastName}'),
                      Text('Mobile Number: ${widget.mobileNumber}'),
                      Text('Address: ${widget.address}'),
                      SizedBox(height: 10),
                      CustomTextField(hintText: 'Nationality'),
                      SizedBox(height: 10),
                      LabeledCheckbox(
                        label: 'Are you a PWD?',
                        value: _isPWD,
                        onChanged: (value) {
                          setState(() {
                            _isPWD = value;
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
                                  builder: (context) => DeclarationScreen()),
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
