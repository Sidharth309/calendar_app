import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<DateTime, String> notes = {};

  TextEditingController noteController = TextEditingController();

  bool isDateClicked = false;

  DateTime? clickedDate;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    List<DateTime> daysInMonth = _getDaysInMonth(firstDayOfMonth);
    String monthName = getMonthName(now.month);
    String fullYear = now.year.toString();
    int firstDayWeekday = firstDayOfMonth.weekday;
    int startingIndex = firstDayWeekday;
    List<Widget> calendarChildren =
        List.generate(startingIndex, (index) => Container());

    calendarChildren.addAll(
      daysInMonth.map(
        (day) => GestureDetector(
          onTap: () {
            setState(() {
              noteController.text = notes[day] ?? '';
              clickedDate = day;
              isDateClicked = true;
            });
          },
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: clickedDate != null && day == clickedDate
                          ? Colors.deepPurple
                          : null,
                      borderRadius: BorderRadius.circular(
                          notes.containsKey(day) ? 30 : 10),
                      border: notes.containsKey(day)
                          ? Border.all(color: Colors.deepPurple, width: 1)
                          : Border.all(color: Colors.transparent)),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: clickedDate != null && day == clickedDate
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Weekday headers
    List<String> weekdayHeaders = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendar Notes'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isDateClicked)
                Expanded(
                  child: Card(
                    color: const Color(0xFF673AB7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          hintText: 'Enter note...',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                        maxLines: null,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              notes[clickedDate!] = value;
                            });
                          } else {
                            setState(() {
                              notes.remove(clickedDate!);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "$monthName $fullYear",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: weekdayHeaders
                      .map((header) => Expanded(
                            child: Center(
                              child: Text(header),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: calendarChildren.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, // 7 days in a week
                  ),
                  itemBuilder: (context, index) {
                    return calendarChildren[index];
                  },
                ),
              ),
            ],
          ),
        ));
  }

  List<DateTime> _getDaysInMonth(DateTime firstDayOfMonth) {
    int daysInMonth =
        DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0).day;
    List<DateTime> days = [];
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(DateTime(firstDayOfMonth.year, firstDayOfMonth.month, day));
    }
    return days;
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
