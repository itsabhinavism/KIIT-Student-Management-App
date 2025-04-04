import 'package:flutter/material.dart';

class AttendanceScreen extends StatelessWidget {
  final Map<String, dynamic> student = {
    'name': 'Abhinav Anand',
    'rollNumber': 22052611,
    'department': 'Computer Science',
    'semester': '5th',
    'totalClasses': 100,
    'attendedClasses': 85,
    'attendancePercentage': 85.0,
  };

  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Data Structures',
      'attended': 18,
      'total': 20,
      'color': Colors.deepPurple,
    },
    {
      'name': 'Algorithms',
      'attended': 15,
      'total': 20,
      'color': Colors.teal,
    },
    {
      'name': 'Database Systems',
      'attended': 20,
      'total': 20,
      'color': Colors.indigo,
    },
    {
      'name': 'Operating Systems',
      'attended': 17,
      'total': 20,
      'color': Colors.blueGrey,
    },
    {
      'name': 'Computer Networks',
      'attended': 19,
      'total': 20,
      'color': Colors.deepOrange,
    },
  ];

  // Removed const here
  AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final percentage = student['attendancePercentage'] as double;

    final attendanceColor = percentage >= 75
        ? isDarkMode
        ? Colors.green[400]!
        : Colors.green[700]!
        : percentage >= 50
        ? isDarkMode
        ? Colors.orange[400]!
        : Colors.orange[700]!
        : isDarkMode
        ? Colors.red[400]!
        : Colors.red[700]!;

    final cardColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final profileCardColor =
    isDarkMode ? Colors.deepPurple[900] : Colors.deepPurple[50];
    final summaryCardColor =
    isDarkMode ? Colors.blueGrey[900] : Colors.blue[50];
    final subjectCardColor = isDarkMode ? Colors.grey[850] : Colors.grey[50];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.blue[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Student Profile Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: profileCardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.deepPurple[400]!
                              : Colors.deepPurple,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: isDarkMode
                            ? Colors.deepPurple[800]!
                            : Colors.deepPurple[100],
                        child: Icon(
                          Icons.school,
                          size: 40,
                          color: isDarkMode
                              ? Colors.deepPurple[200]!
                              : Colors.deepPurple[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      student['name'],
                      style:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.white
                            : Colors.deepPurple[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      backgroundColor: isDarkMode
                          ? Colors.deepPurple[800]!
                          : Colors.deepPurple[100],
                      label: Text(
                        'Roll No: ${student['rollNumber']}',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : Colors.deepPurple[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student['department']} • ${student['semester']} Semester',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? Colors.grey[400]
                            : Colors.deepPurple[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Attendance Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: summaryCardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assessment,
                          color:
                          isDarkMode ? Colors.blue[200] : Colors.blue[800],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Attendance Summary',
                          style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAttendanceStat(
                          context,
                          'Total Classes',
                          student['totalClasses'].toString(),
                          Icons.calendar_today,
                          isDarkMode ? Colors.blue[200]! : Colors.blue[800]!,
                          isDarkMode,
                        ),
                        _buildAttendanceStat(
                          context,
                          'Attended',
                          student['attendedClasses'].toString(),
                          Icons.check_circle,
                          isDarkMode ? Colors.green[200]! : Colors.green[800]!,
                          isDarkMode,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor:
                        isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                        color: attendanceColor,
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Attendance Percentage',
                          style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDarkMode
                                ? Colors.grey[300]
                                : Colors.blue[800],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: attendanceColor
                                .withOpacity(isDarkMode ? 0.3 : 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${percentage.toStringAsFixed(1)} %',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: attendanceColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (percentage < 75)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.orange[900]!
                                : Colors.orange[100]!,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: isDarkMode
                                    ? Colors.orange[200]!
                                    : Colors.orange[800]!,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'You need ${(75 - percentage).toStringAsFixed(1)} % more attendance to reach 75%',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.orange[200]!
                                        : Colors.orange[800]!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Subject-wise Attendance
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: subjectCardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          color:
                          isDarkMode ? Colors.grey[300] : Colors.grey[800],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Subject-wise Attendance',
                          style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...subjects.map((subject) {
                      final percent =
                          (subject['attended'] / subject['total']) * 100;
                      final color = subject['color'] as Color;
                      final percentColor = percent >= 75
                          ? isDarkMode
                          ? Colors.green[400]!
                          : Colors.green[700]!
                          : percent >= 50
                          ? isDarkMode
                          ? Colors.orange[400]!
                          : Colors.orange[700]!
                          : isDarkMode
                          ? Colors.red[400]!
                          : Colors.red[700]!;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(
                                            isDarkMode ? 0.3 : 0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.book,
                                        size: 20,
                                        color: color,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      subject['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: percentColor
                                        .withOpacity(isDarkMode ? 0.3 : 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${percent.toStringAsFixed(1)} %',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: percentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: percent / 100,
                                backgroundColor: isDarkMode
                                    ? Colors.grey[800]!
                                    : Colors.grey[200]!,
                                color: percentColor,
                                minHeight: 8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${subject['attended']} of ${subject['total']} classes attended',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStat(
      BuildContext context,
      String title,
      String value,
      IconData icon,
      Color color,
      bool isDarkMode,
      ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(isDarkMode ? 0.3 : 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDarkMode ? Colors.grey[300] : color.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : color,
            ),
          ),
        ],
      ),
    );
  }
}
