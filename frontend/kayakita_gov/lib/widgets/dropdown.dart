import 'package:flutter/material.dart';

const List<String> services = <String>[
  'Rider',
  'Driver',
  'PasaBuy',
  'Barber',
  'Carpenter'
];

class ServicesDropdownMenu extends StatefulWidget {
  const ServicesDropdownMenu({super.key});

  @override
  State<ServicesDropdownMenu> createState() => _ServicesDropdownMenuState();
}

class _ServicesDropdownMenuState extends State<ServicesDropdownMenu> {
  String dropdownValue = services.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: 'Select',
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          services.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
