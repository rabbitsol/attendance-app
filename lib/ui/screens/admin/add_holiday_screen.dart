import 'dart:convert';

import 'package:face_recognition_attendance_app/model/holiday_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddHolidayScreen extends StatefulWidget {
  const AddHolidayScreen({Key? key}) : super(key: key);

  @override
  State<AddHolidayScreen> createState() => _AddHolidayScreenState();
}

class _AddHolidayScreenState extends State<AddHolidayScreen> {
  Future<List<Holiday>>? _holidays;

  @override
  void initState() {
    super.initState();
    _holidays = _fetchHolidays();
  }

  Future<List<Holiday>> _fetchHolidays() async {
    final response =
        await http.get('http://localhost:3000/api/holidays/2023' as Uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return List<Holiday>.from(
          json.map((holiday) => Holiday.fromJson(holiday)));
    } else {
      throw Exception('Failed to get holidays');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Holiday'),
      ),
      body: FutureBuilder<List<Holiday>>(
        future: _holidays,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final holiday = snapshot.data![index];
                return ListTile(
                  title: Text(holiday.name),
                  subtitle: Text(holiday.date),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
// ```

// This code first creates a Future object called `_holidays` that will fetch the holidays from the API. The `_fetchHolidays()` function uses the `http` package to make a GET request to the API. If the request is successful, the function returns a list of `Holiday` objects from the JSON response. If the request fails, the function throws an exception.

// The `build()` method first checks if the `_holidays` future has data. If it does, the method builds a ListView widget with a ListTile for each holiday. The ListTile widget displays the holiday's name and date.

// If the `_holidays` future does not have data, the method checks if it has an error. If it does, the method displays the error message. Otherwise, the method displays a CircularProgressIndicator widget to indicate that the holidays are still loading.

// I hope this helps! Let me know if you have any other questions.