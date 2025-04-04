import 'package:flutter/material.dart';

class TimeTableScreen extends StatefulWidget {
  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final TextEditingController _sectionController = TextEditingController();
  Map<String, List<String>> timetableData = {
    "CSE-1": [
      "MON: ML (A-LH-003), AI(L) (A-DL-008), CC|SPM (B-201), UHV (B-201)",
      "TUE: No classes",
      "WED: AI (B-201), AD (A-DL-008), AD(L) (A-DL-008)",
      "THU: ML (B-201), AI (B-201), UHV (B-201), CC|SPM (B-201)",
      "FRI: AI (B-201), CC|SPM (B-201), ML (B-201), UHV (B-201)",
      "SAT: ML (B-201)"
    ],
    "IT-1": [
      "MON: ML (C-WL-102), DA(L) (C-WL-102)",
      "TUE: CC|SPM (C-LH-407), DSA (C-LH-407), UHV (C-LH-407)",
      "WED: No classes",
      "THU: DSA (C-LH-203), CC|SPM (C-LH-405), ML (C-LH-405)",
      "FRI: ML (C-LH-203), AP (C-WL-103), AP(L) (C-WL-103)",
      "SAT: ML (C-LH-403), CC|SPM (C-LH-403), DSA (C-LH-403)"
    ],
  };

  List<String> _displayedTimetable = [];

  void _fetchTimetable() {
    setState(() {
      final section = _sectionController.text.toUpperCase();
      _displayedTimetable = timetableData[section] ?? ["Section not found"];
    });
  }

  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade900
        : Colors.deepPurple.shade50;
  }

  Color _getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade800
        : Colors.deepPurple.shade100;
  }

  Color _getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.deepPurple.shade200
        : Colors.deepPurple.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Academic Schedule"),
        backgroundColor: _getPrimaryColor(context),
      ),
      backgroundColor: _getBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _sectionController,
              decoration: InputDecoration(
                labelText: "Enter Section (e.g., CSE-1, IT-1)",
                border: const OutlineInputBorder(),
                suffixIcon: Icon(Icons.search, color: _getPrimaryColor(context)),
                labelStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
              ),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.schedule, color: Colors.white),
              label: const Text("View Timetable", 
                     style: TextStyle(fontSize: 16, color: Colors.white)),
              onPressed: _fetchTimetable,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getPrimaryColor(context),
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView.separated(
                itemCount: _displayedTimetable.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white24
                      : Colors.black12,
                ),
                itemBuilder: (context, index) {
                  return _ScheduleCard(
                    entry: _displayedTimetable[index],
                    cardColor: _getCardColor(context),
                    iconColor: _getPrimaryColor(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String entry;
  final Color cardColor;
  final Color iconColor;

  const _ScheduleCard({
    required this.entry,
    required this.cardColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: iconColor, size: 22),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                entry,
                style: TextStyle(
                  fontSize: 16,
                  color: entry == "No classes" 
                      ? Colors.grey 
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                  fontStyle: entry == "No classes" 
                      ? FontStyle.italic 
                      : FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}