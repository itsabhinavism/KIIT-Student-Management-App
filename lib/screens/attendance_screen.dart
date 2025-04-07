import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceScreen extends StatefulWidget {
  final String rollNumber;
  const AttendanceScreen({super.key, required this.rollNumber});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Map<String, dynamic>? studentData;
  List<Map<String, dynamic>> subjectAttendance = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    try {
      final docId = '${widget.rollNumber}@kiit.ac.in';
      final doc = await FirebaseFirestore.instance.collection('students').doc(docId).get();
      if (doc.exists) {
        final data = doc.data()!;
        final attended = int.tryParse(data['classesAttended'].toString()) ?? 0;
        final total = int.tryParse(data['totalClasses'].toString()) ?? 0;
        final percentage = total > 0 ? (attended / total) * 100 : 0;

        final List<dynamic> subjects = data['subjects'] ?? [];
        subjectAttendance = subjects.map<Map<String, dynamic>>((subject) {
          final attended = subject['attended'] ?? 0;
          final total = subject['total'] ?? 0;
          final name = subject['name'] ?? 'Unknown';
          final color = _getSubjectColor(name);
          return {
            'name': name,
            'attended': attended,
            'total': total,
            'color': color,
          };
        }).toList();

        setState(() {
          studentData = {
            ...data,
            'attendedClasses': attended,
            'totalClasses': total,
            'attendancePercentage': percentage,
          };
          isLoading = false;
        });
      } else {
        setState(() {
          studentData = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching student data: $e');
      setState(() {
        studentData = null;
        isLoading = false;
      });
    }
  }

  String? getProfileImageAsset(String rollNumber) {
    final imageMap = {
      '22051624': 'assets/shreemant.jpg',
      '2205896': 'assets/debsoomonto.jpg',
      '22052611': 'assets/abhinav.jpg',
      '22053018': 'assets/shashwat.jpg',
    };
    return imageMap[rollNumber];
  }

  Color _getSubjectColor(String subjectName) {
    final colorMap = {
      'Data Structures': Colors.deepPurple,
      'Algorithms': Colors.teal,
      'Database Systems': Colors.indigo,
      'Operating Systems': Colors.blueGrey,
      'Computer Networks': Colors.deepOrange,
    };
    return colorMap[subjectName] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (studentData == null) {
      return const Scaffold(
        body: Center(child: Text("Attendance Details not Available")),
      );
    }

    final double percentage = studentData!['attendancePercentage'];
    final Color attendanceColor = percentage >= 75
        ? (isDarkMode ? Colors.green[400]! : Colors.green[700]!)
        : percentage >= 50
        ? (isDarkMode ? Colors.orange[400]! : Colors.orange[700]!)
        : (isDarkMode ? Colors.red[400]! : Colors.red[700]!);

    final Color summaryCardColor = isDarkMode ? Colors.blueGrey[900]! : Colors.blue[50]!;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color secondaryTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[700]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Attendance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.blue[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileCard(summaryCardColor, isDarkMode),
            const SizedBox(height: 24),
            _buildSummaryCard(summaryCardColor, attendanceColor, percentage, isDarkMode),
            const SizedBox(height: 24),
            _buildSubjectWiseCard(summaryCardColor, textColor, secondaryTextColor, subjectAttendance, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(Color cardColor, bool isDarkMode) {
    final String? imagePath = getProfileImageAsset(widget.rollNumber);
    final roll = studentData?['rollNumber'] ?? widget.rollNumber;

    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: isDarkMode ? Colors.deepPurple[800] : Colors.deepPurple[100],
              backgroundImage: imagePath != null ? AssetImage(imagePath) : null,
              child: imagePath == null
                  ? Icon(Icons.school, size: 40, color: isDarkMode ? Colors.white70 : Colors.deepPurple)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              studentData!['name'] ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.deepPurple[900],
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              backgroundColor: isDarkMode ? Colors.deepPurple[800] : Colors.deepPurple[100],
              label: Text(
                'Roll No: $roll',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.deepPurple[800]),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Computer Science • 5th Semester',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.grey[400] : Colors.deepPurple[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(Color cardColor, Color progressColor, double percentage, bool isDarkMode) {
    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.assessment, color: isDarkMode ? Colors.blue[200] : Colors.blue[800]),
                const SizedBox(width: 8),
                Text(
                  'Attendance Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard('Total Classes', studentData!['totalClasses'].toString(), Icons.calendar_today, isDarkMode),
                _buildStatCard('Attended', studentData!['attendedClasses'].toString(), Icons.check_circle, isDarkMode),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 12,
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                color: progressColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance Percentage',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode ? Colors.grey[300] : Colors.blue[800],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: progressColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)} %',
                    style: TextStyle(fontWeight: FontWeight.bold, color: progressColor),
                  ),
                ),
              ],
            ),
            if (percentage < 75)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: isDarkMode ? Colors.orange[200] : Colors.orange[800]),
                    const SizedBox(width: 8),
                    Text(
                      'You need ${(75 - percentage).toStringAsFixed(1)}% more to reach 75%',
                      style: TextStyle(color: isDarkMode ? Colors.orange[200] : Colors.orange[800]),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectWiseCard(Color cardColor, Color textColor, Color secondaryColor,
      List<Map<String, dynamic>> subjects, bool isDarkMode) {
    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
                const SizedBox(width: 8),
                Text(
                  'Subject-wise Attendance',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.grey[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...subjects.map((subject) {
              final percent = (subject['attended'] / subject['total']) * 100;
              final percentColor = percent >= 75
                  ? (isDarkMode ? Colors.green[400]! : Colors.green[700]!)
                  : percent >= 50
                  ? (isDarkMode ? Colors.orange[400]! : Colors.orange[700]!)
                  : (isDarkMode ? Colors.red[400]! : Colors.red[700]!);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.book, color: subject['color'], size: 20),
                            const SizedBox(width: 8),
                            Text(subject['name'], style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: percentColor.withOpacity(isDarkMode ? 0.3 : 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${percent.toStringAsFixed(1)} %',
                              style: TextStyle(fontWeight: FontWeight.bold, color: percentColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percent / 100,
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      color: percentColor,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 4),
                    Text('${subject['attended']} of ${subject['total']} classes attended',
                        style: TextStyle(color: secondaryColor)),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDarkMode) {
    final Color color = title == 'Attended' ? Colors.green : Colors.blue;
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
            style: TextStyle(color: isDarkMode ? Colors.grey[300] : color.withOpacity(0.8)),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
