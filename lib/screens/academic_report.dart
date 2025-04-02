import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AcademicReportScreen extends StatefulWidget {
  @override
  _AcademicReportScreenState createState() => _AcademicReportScreenState();
}

class _AcademicReportScreenState extends State<AcademicReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _expandedSemester = 1; // Track expanded semester, default to 1

  List<Subject> subjectsSemester1 = [
    Subject(name: 'Java', marks: 85, totalMarks: 100),
    Subject(name: 'C++', marks: 78, totalMarks: 100),
    Subject(name: 'Computer Networks', marks: 92, totalMarks: 100),
    Subject(name: 'Data Structures', marks: 65, totalMarks: 100),
    Subject(name: 'Algorithms', marks: 88, totalMarks: 100),
  ];
  List<Subject> subjectsSemester2 = [
    Subject(name: 'Python', marks: 70, totalMarks: 100),
    Subject(name: 'Database Management', marks: 80, totalMarks: 100),
    Subject(name: 'Operating Systems', marks: 75, totalMarks: 100),
  ];
  List<Subject> subjectsSemester3 = [
    Subject(name: 'Software Engineering', marks: 82, totalMarks: 100),
    Subject(name: 'Web Development', marks: 90, totalMarks: 100),
  ];
  List<Subject> subjectsSemester4 = [
    Subject(name: 'Mobile App Development', marks: 88, totalMarks: 100),
    Subject(name: 'Cloud Computing', marks: 76, totalMarks: 100),
  ];
  List<Subject> subjectsSemester5 = [
    Subject(name: 'Machine Learning', marks: 91, totalMarks: 100),
    Subject(name: 'Data Analysis', marks: 85, totalMarks: 100),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Report'),
        backgroundColor: Colors.orange.shade400, // Darker orange app bar
      ),
      backgroundColor: Colors.orange.shade100, // More vibrant orange background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSemesterSection(1, subjectsSemester1),
            _buildSemesterSection(2, subjectsSemester2),
            _buildSemesterSection(3, subjectsSemester3),
            _buildSemesterSection(4, subjectsSemester4),
            _buildSemesterSection(5, subjectsSemester5),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterSection(int semester, List<Subject> subjects) {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.zero,
      expansionCallback: (int panelIndex, bool isExpanded) {
        setState(() {
          _expandedSemester = isExpanded ? 0 : semester;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                'Semester $semester',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
          body: Column(
            children: subjects.map((subject) {
              final percentage = subject.marks / subject.totalMarks;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return LinearPercentIndicator(
                            width: MediaQuery.of(context).size.width - 64 - 32,
                            lineHeight: 10.0,
                            percent: percentage * _controller.value,
                            progressColor: _getGradeColor(percentage),
                            backgroundColor: Colors.grey[300],
                            animation: true,
                            animationDuration: 1000,
                            barRadius: const Radius.circular(5),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Marks: ${subject.marks} / ${subject.totalMarks} (${(percentage * 100).toStringAsFixed(1)}%)',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Grade: ${_getGrade(percentage)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          isExpanded: _expandedSemester == semester,
        ),
      ],
    );
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 0.9) {
      return Colors.green;
    } else if (percentage >= 0.8) {
      return Colors.lightGreen;
    } else if (percentage >= 0.7) {
      return Colors.yellow;
    } else if (percentage >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String _getGrade(double percentage) {
    if (percentage >= 0.9) {
      return 'A+';
    } else if (percentage >= 0.8) {
      return 'A';
    } else if (percentage >= 0.7) {
      return 'B';
    } else if (percentage >= 0.6) {
      return 'C';
    } else {
      return 'F';
    }
  }
}

class Subject {
  final String name;
  final int marks;
  final int totalMarks;

  Subject({required this.name, required this.marks, required this.totalMarks});
}
