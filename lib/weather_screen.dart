import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*SizedBox is used to give the card a specific width and height, in this case,
             we are giving it an infinite width to make it take up the full width of the screen.**/
            SizedBox(
              //main card
              width: double.infinity,

              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                /*ClipRRect is used to clip the child widget with a rounded rectangle shape,
                  so that the blur effect applied by the backdropFilter does not overflow outside the card,
                  in this case, we are giving it a circular border radius of 30 pixels.
                     */
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  /* backdropFilter is used to apply a blur effect to the background of the card,
                    in this case, we are applying a blur effect with a sigma of 10 for both x and y axis.
                    This will give the card a frosted glass effect.
                     */
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 12),

                      child: Column(
                        children: [
                          const Text(
                            "100°F",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              height: 1.3, // reduces the text top height
                            ),
                          ), // this will be the current temperature

                          const SizedBox(height: 10),
                          const Icon(Icons.cloud, size: 50),
                          const SizedBox(height: 10),
                          const Text("Clear", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), //spacing

            const Text(
              "Hourly Forecast",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),

            SizedBox(
              height: 200, // Give the carousel a specific height

              child: const CarouselView(
                // this is for the hourly weather forecast
                itemExtent: 150, // Each weather card is 120 pixels wide
                shrinkExtent: 150,
                /*shrinkExtent allows the carousel items to shrink when scrolled but when
                  set the same value as itemExtent it changes the limit at which the card shrink so card do not shrink */
                enableSplash: false, // removes the splash feature when clicked
                elevation: 8, // adds a shadow to the cards

                children: [

                  HourlyForecastItem(time: "1 PM", icons: Icons.cloud, temperature: "100°F"),
                  HourlyForecastItem(time: "2 PM", icons: Icons.cloud, temperature: "100°F"),
                  HourlyForecastItem(time: "3 PM", icons: Icons.cloud, temperature: "100°F"),
                  HourlyForecastItem(time: "4 PM", icons: Icons.cloud, temperature: "100°F"),
                  HourlyForecastItem(time: "5 PM", icons: Icons.cloud, temperature: "100°F"),
                  HourlyForecastItem(time: "6 PM", icons: Icons.cloud, temperature: "100°F"),

                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Additional Details",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                height: 2,
              ),
            ),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 15,
              children: [
                AdditionalInfo(icon: Icons.water_drop_outlined, title: "Humidity", value: "90%"),

                AdditionalInfo(icon: Icons.air, title: "Air Speed", value: "7.4 mph",),

                AdditionalInfo(icon: Icons.speed, title: "Pressure", value: "1013 hPa",),

                // Placeholder(
                //   fallbackHeight: 250, // if there is no child then this will be the height of the card as fallback but
                //   //child: Text("main card"),     // if there is child then the height of the card will be the height of the child.
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
