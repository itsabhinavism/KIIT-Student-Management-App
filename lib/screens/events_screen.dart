import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  final List<Map<String, String>> pastEvents = [
    {'name': "Pratijja '24", 'date': "18 March 2024"},
    {'name': "Kritarth V.06", 'date': "9 November 2024"},
    {'name': "KIIT MUN '24", 'date': "26-27-28 October 2024"},
    {'name': "ICDCIT 2024", 'date': "12 December 2024"},
    {'name': "KIITFEST '25", 'date': "14-15-16 February 2025"},
    {'name': "CHIMERA '25", 'date': "15 March 2025"},
  ];

  final List<Map<String, String>> upcomingEvents = [
    {'name': "TedXKIIT", 'date': "5 April 2025"},
    {'name': "KIITMUN '25", 'date': "August 2025"},
    {'name': "Halloween", 'date': "October 2025"},
    {'name': "Kritarth", 'date': "November 2025"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.event,
              size: 100,
              color: Colors.purple,
            ),
            SizedBox(height: 20),
            Text(
              'Events',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Events:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ...upcomingEvents.map((event) => ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.green, width: 1),
                              ),
                              title: Text(event['name']!),
                              subtitle: Text(event['date']!),
                              leading: Icon(Icons.calendar_today,
                                  color: Colors.green),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Past Events:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: pastEvents
                                .map((event) => ListTile(
                                      tileColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: Colors.red, width: 1),
                                      ),
                                      title: Text(event['name']!),
                                      subtitle: Text(event['date']!),
                                      leading: Icon(Icons.history,
                                          color: Colors.red),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
