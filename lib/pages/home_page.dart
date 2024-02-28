import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mausam/constants/consts.dart';
import 'package:weather/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherFactory wf = WeatherFactory(API_KEY);
  Weather? _weather;

  @override
  void initState() {
    wf.currentWeatherByCityName("Kolkata").then((value) {
      setState(() {
        _weather = value;
      });
    });
    super.initState();
  }

  void getWeatherData(String cityName) async {
    wf.currentWeatherByCityName(cityName).then((value) {
      setState(() {
        _weather = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: buildUI()),
    );
  }

  Widget timeTile() {
    DateTime now = _weather!.date!;
    return ListTile(
      title: Text(
        DateFormat("h:mm a").format(now),
        style: TextStyle(fontSize: 36, color: Colors.white),
      ),
    );
  }

  Widget sunriseTime() {
    DateTime now = _weather!.sunrise!;
    return Text(
      DateFormat("h:mm a").format(now),
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }

  Widget sunsetTime() {
    DateTime now = _weather!.sunset!;
    return Text(
      DateFormat("h:mm a").format(now),
      style: TextStyle(fontSize: 18, color: Colors.white),
    );
  }

  Widget buildUI() {
    final TextEditingController _controller = TextEditingController();
    if (_weather == null) {
      return Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: LottieBuilder.asset('lib/assets/loading.json'),
        ),
      );
    } else {
      return Stack(
        children: [
          Positioned(
            child: Opacity(
              opacity: 1,
              child: LottieBuilder.asset(
                'lib/assets/background.json',
                repeat: true,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      isScrollControlled: true,
                      isDismissible: true,
                      backgroundColor: Colors.blue.shade800.withOpacity(0.5),
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          // color: Colors.blue.withOpacity(0),

                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      labelText: "Enter your city",
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(enableFeedback: true),
                                  onPressed: () {
                                    getWeatherData(_controller.text.trim());
                                    Navigator.pop(context);
                                  },
                                  child: Text('Search'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white60,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        _weather!.areaName!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        _weather!.country!,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                timeTile(),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"),
                        colorFilter: ColorFilter.linearToSrgbGamma()),
                  ),
                ),
                Center(
                  child: Text(
                    _weather!.weatherMain!,
                    style: const TextStyle(fontSize: 32, color: Colors.amber),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.sunrise_fill,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          sunriseTime(),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.sunset_fill,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          sunsetTime(),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.withOpacity(0.2),
                        Colors.blueAccent.withOpacity(0.1),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _weather!.temperature!.celsius!.toStringAsFixed(1) +
                            ' °C',
                        style: TextStyle(color: Colors.white, fontSize: 28),
                      ),
                      Text(
                        "Feels Like " +
                            _weather!.tempFeelsLike!.celsius!
                                .toStringAsFixed(1) +
                            ' °C',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue,
                                  Colors.green,
                                ],
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Column(children: [
                              Text(
                                _weather!.pressure!.toStringAsFixed(0),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              Icon(
                                CupertinoIcons.thermometer,
                                size: 36,
                                color:
                                    Colors.white, // Customize color as needed
                              ),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue,
                                  Colors.green,
                                ],
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Column(children: [
                              Text(
                                _weather!.humidity!.toStringAsFixed(0),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              Icon(
                                CupertinoIcons.drop,
                                size: 36,
                                color:
                                    Colors.white, // Customize color as needed
                              ),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue,
                                  Colors.green,
                                ],
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Column(children: [
                              Text(
                                _weather!.windSpeed!.toStringAsFixed(0),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              Icon(
                                CupertinoIcons.wind,
                                size: 36,
                                color:
                                    Colors.white, // Customize color as needed
                              ),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue,
                                  Colors.green,
                                ],
                              ),
                            ),
                            width: MediaQuery.of(context).size.width * 0.18,
                            child: Column(children: [
                              Text(
                                _weather!.cloudiness!.toStringAsFixed(0),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              Icon(
                                CupertinoIcons.cloud_sun,
                                size: 36,
                                color:
                                    Colors.white, // Customize color as needed
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
