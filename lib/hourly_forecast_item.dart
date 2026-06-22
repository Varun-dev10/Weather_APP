import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icons;
  final String temperature;
  final String description;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icons,
    required this.temperature,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),

          const SizedBox(height: 10),

          Icon(icons, size: 40),

          const SizedBox(height: 10),

          Text(description,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),

          const SizedBox(height: 10),

          Text(temperature,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
