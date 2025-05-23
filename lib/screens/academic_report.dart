import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AcademicReportScreen extends StatefulWidget {
  const AcademicReportScreen({super.key});

  @override
  _AcademicReportScreenState createState() => _AcademicReportScreenState();
}

class _AcademicReportScreenState extends State<AcademicReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _expandedSemester = 1;

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
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Academic Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.orange.shade700,
        elevation: 2,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.orange.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSemesterSection(1, subjectsSemester1, isDarkMode),
            _buildSemesterSection(2, subjectsSemester2, isDarkMode),
            _buildSemesterSection(3, subjectsSemester3, isDarkMode),
            _buildSemesterSection(4, subjectsSemester4, isDarkMode),
            _buildSemesterSection(5, subjectsSemester5, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterSection(int semester, List<Subject> subjects, bool isDarkMode) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int panelIndex, bool isExpanded) {
          setState(() {
            _expandedSemester = isExpanded ? 0 : semester;
            _controller.reset();
            _controller.forward();
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Container(
                color: isDarkMode ? Colors.orange.shade900 : Colors.orange.shade100,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Text(
                  'Semester $semester',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.brown.shade800,
                  ),
                ),
              );
            },
            body: Column(
              children: subjects.asMap().entries.map((entry) {
                final index = entry.key;
                final subject = entry.value;
                final percentage = subject.marks / subject.totalMarks;

                final Animation<double> fadeAnimation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
                ));

                final Animation<Offset> slideAnimation = Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(index * 0.1, 1.0, curve: Curves.easeInOut),
                ));

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Card(
                      color: isDarkMode ? Colors.orange.shade900 : Colors.orange.shade100,
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.brown.shade800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width - 64 - 32,
                              lineHeight: 10.0,
                              percent: percentage,
                              progressColor: _getGradeColor(percentage),
                              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                              animation: true,
                              animationDuration: 1000,
                              barRadius: const Radius.circular(5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Marks: ${subject.marks} / ${subject.totalMarks} (${(percentage * 100).toStringAsFixed(1)}%)',
                              style: TextStyle(
                                fontSize: 14, 
                                color: isDarkMode ? Colors.grey[300] : Colors.brown.shade700
                              ),
                            ),
                            Text(
                              'Grade: ${_getGrade(percentage)}',
                              style: TextStyle(
                                fontSize: 14, 
                                color: isDarkMode ? Colors.grey[300] : Colors.brown.shade700
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            isExpanded: _expandedSemester == semester,
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 0.9) {
      return Colors.green;
    } else if (percentage >= 0.8) {
      return Colors.lightGreen;
    } else if (percentage >= 0.7) {
      return Colors.yellow[700]!;
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