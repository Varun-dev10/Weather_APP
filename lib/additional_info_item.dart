import 'package:flutter/material.dart';


class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 150,
      width: 120,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          spacing: 13,

          children: [
            Icon(icon, size: 40),
           // SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 20)),
           // SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
