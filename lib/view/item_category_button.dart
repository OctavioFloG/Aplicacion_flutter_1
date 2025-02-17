import 'package:flutter/material.dart';

class ItemCategoryButton extends StatelessWidget {
  const ItemCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Color(0xFFF3F8FE),
        ),
        shadowColor: WidgetStateProperty.all(
          Color.fromARGB(0, 243, 248, 254),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 12,
          bottom: 12,
        ),
        child: Text(
          "Location",
          style: TextStyle(
            color: Color(0xFF176EF2),
            fontSize: 12,
            fontFamily: 'CircularXX',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
