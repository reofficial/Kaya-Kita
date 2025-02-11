import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;

  const CustomAppBar({
    super.key,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    final title = Text(titleText,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold));

    return AppBar(
      title: title,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF000000)),
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); //
}
