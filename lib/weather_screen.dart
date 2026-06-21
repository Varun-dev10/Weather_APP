import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/secrets.dart'; //<--- hidden folder contains API KEY
import 'additional_info_item.dart';
import 'hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  String currentCity = "Bhilai";
  final TextEditingController cityController = TextEditingController();



  // ai interview, polymarket
  Future<Map<String, dynamic>> getCurrentWeather() async {
    // future data comprises of map of  string and numbers
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$currentCity&APPID=$openWeatherAPIKEY',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;
      //  temp = data['list'][0]['main']['temp'];
      //   // data(body) > list(40 entries) > [0] (first entry index ) > main (first entry) > temp (temp value from first entry)

      // setState(() {
      //   temp = data['list'][0]['main']['temp'];
      // });
      // print(temp);
    } catch (e) {
      // print("Error: $e");
      throw e.toString();
    }
  }

  @override
  void initState() {
    //initState is used in initial stage of loading an app
    super.initState();
    weather = getCurrentWeather(); // <--- 1. Call here to load on startup
  }

  @override
  Widget build(BuildContext context) {
    // Detect screen height for responsive sizing
    final screenHeight = MediaQuery.of(context).size.height;

    // body: temp == 0                //ternary operator if temp == 0 is true > circular loading screen, if false single child scroll
    //     ? RefreshProgressIndicator() :

    return FutureBuilder(
      future: weather,
      builder: (context, snapshot) {
        // print(snapshot);
        // print(snapshot.runtimeType);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          ); // adaptive switches the indicator based on the os platform
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "error",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        final data = snapshot.data!;
        final currentWeatherData = data['list'][0];
        final cityName = data['city']['name'];

        // main card
        final currentTemp = (currentWeatherData['main']['temp']) - 273.15;
        final currentSky = currentWeatherData['weather'][0]['main'];

        // Additional info
        final currentPressure = currentWeatherData['main']['pressure'];
        final currentAirSpeed = currentWeatherData['wind']['speed'];
        final currentHumidity = currentWeatherData['main']['humidity'];

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            centerTitle: true,
            title: Text(cityName),

            leading: IconButton(
              //<---- leading is used to show icon on the app bar at the left side,, Tip to show multiple icon wrap with Row
              onPressed: () {
                // 3. Show a dialog to enter city name
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Search City"),
                    content: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        hintText: "Enter city name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          if (cityController.text.isNotEmpty) {
                            setState(() {
                              // Update currentCity and refresh the weather
                              currentCity = cityController.text;
                              weather = getCurrentWeather();
                            });
                            cityController.clear(); // Clear input for next time
                            Navigator.pop(context); // Close the dialog
                          }
                        },
                        child: const Text("Search"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.search),
            ),

            actions: [
              //<--- actions is used to put icon on the right side of button, it will not add icons to the left
              IconButton(
                onPressed: () {
                  print("Refresh pressed"); // <--- call here to refresh
                  setState(() {
                    // 3. To refresh, simply re-assign the future and call setState
                    weather = getCurrentWeather();
                  });
                },
                icon: Icon(Icons.refresh),
              ),
            ],
          ),

          body: SingleChildScrollView(
            // provides vertical scroll in case small size phone is used to view additional details section
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*SizedBox is used to give the card a specific width and height, in this case,
                         we are giving it an infinite width to make it take up the full width of the screen.*/
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
                             in this case, we are giving it a circular border radius of 30 pixels.*/
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        /* backdropFilter is used to apply a blur effect to the background of the card,
                                in this case, we are applying a blur effect with a sigma of 10 for both x and y axis.
                                This will give the card a frosted glass effect.*/
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),

                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 12),

                            child: Column(
                              children: [
                                Text(
                                  "${currentTemp.toStringAsFixed(1)}°C",
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),

                                const SizedBox(height: 10),
                                Icon(
                                  currentSky == 'Clouds' ||
                                          currentSky == 'Rain' ||
                                          currentSky == 'Drizzle' ||
                                          currentSky == 'Thunderstorm'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 50,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  currentSky,
                                  style: TextStyle(fontSize: 20),
                                ),
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
                    height: screenHeight * 0.20, // Give the carousel a specific height

                    // child: CarouselView(
                    //   // this is for the hourly weather forecast
                    //   itemExtent: 150, // Each weather card is 120 pixels wide
                    //   shrinkExtent: 150,
                    //   /*shrinkExtent allows the carousel items to shrink when scrolled but when
                    //        set the same value as itemExtent it changes the limit at which the card shrink so card do not shrink */
                    //   enableSplash:
                    //       false, // removes the splash feature when clicked
                    //   elevation: 2, // adds a shadow to the cards
                    //   itemSnapping: true,
                    //
                    //   children: [
                    //     HourlyForecastItem(time: "1 PM", icons: Icons.cloud, temperature: "100°F",),
                    //     HourlyForecastItem(time: "2 PM", icons: Icons.cloud, temperature: "100°F",),
                    //   ],
                    // ),

                    /*ListView.builder is a way to create a list where the items are generated dynamically
                       from your API data and efficiently (it only creates the items currently visible on the screen).*/
                    child: ListView.builder(
                      itemCount: 5, // Show the next 5 hourly forecasts
                      scrollDirection: Axis.horizontal,
                      itemExtent: 150,
                      itemBuilder: (context, index) {
                        // index + 1 because index 0 is the "current" weather we used at the top
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                        final hourlyTemp = data['list'][index + 1]['main']['temp'] - 273.15;

                        // dt_txt is a string like "2023-07-21 15:00:00"
                        final time = DateTime.parse(hourlyForecast['dt_txt']);

                        return HourlyForecastItem(
                          // You can format this time better using the 'intl' package later
                          time: "${time.hour}:00",
                          icons: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          temperature: "${hourlyTemp.toStringAsFixed(1)}°C",
                        );
                      },
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 15,
                    children: [
                      AdditionalInfo(
                        icon: Icons.water_drop_outlined,
                        title: "Humidity",
                        value: "$currentHumidity%",
                      ),

                      AdditionalInfo(
                        icon: Icons.air,
                        title: "Air Speed",
                        value: "${currentAirSpeed.toString()} kph",
                      ),

                      AdditionalInfo(
                        icon: Icons.speed,
                        title: "Pressure",
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Placeholder(
//   fallbackHeight: 250,         // if there is no child then this will be the height of the card as fallback but
//   //child: Text("main card"),  // if there is child then the height of the card will be the height of the child.
// ),
