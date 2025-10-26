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
  final Set<int> _expandedSemesters = {};

  // Comprehensive semester data
  final Map<int, List<Subject>> semesterData = {
    1: [
      Subject(name: 'Engineering Mathematics-I', marks: 88, totalMarks: 100, credits: 4),
      Subject(name: 'Engineering Physics', marks: 82, totalMarks: 100, credits: 4),
      Subject(name: 'Engineering Chemistry', marks: 85, totalMarks: 100, credits: 3),
      Subject(name: 'Programming for Problem Solving', marks: 92, totalMarks: 100, credits: 3),
      Subject(name: 'English', marks: 78, totalMarks: 100, credits: 3),
      Subject(name: 'Engineering Graphics', marks: 90, totalMarks: 100, credits: 2),
    ],
    2: [
      Subject(name: 'Engineering Mathematics-II', marks: 85, totalMarks: 100, credits: 4),
      Subject(name: 'Data Structures', marks: 94, totalMarks: 100, credits: 4),
      Subject(name: 'Digital Electronics', marks: 80, totalMarks: 100, credits: 3),
      Subject(name: 'Object Oriented Programming', marks: 91, totalMarks: 100, credits: 3),
      Subject(name: 'Environmental Science', marks: 88, totalMarks: 100, credits: 2),
      Subject(name: 'Workshop Practice', marks: 92, totalMarks: 100, credits: 2),
    ],
    3: [
      Subject(name: 'Engineering Mathematics-III', marks: 82, totalMarks: 100, credits: 4),
      Subject(name: 'Computer Organization', marks: 86, totalMarks: 100, credits: 4),
      Subject(name: 'Database Management Systems', marks: 90, totalMarks: 100, credits: 4),
      Subject(name: 'Operating Systems', marks: 88, totalMarks: 100, credits: 4),
      Subject(name: 'Theory of Computation', marks: 78, totalMarks: 100, credits: 3),
      Subject(name: 'Software Engineering', marks: 85, totalMarks: 100, credits: 3),
    ],
    4: [
      Subject(name: 'Computer Networks', marks: 92, totalMarks: 100, credits: 4),
      Subject(name: 'Design and Analysis of Algorithms', marks: 88, totalMarks: 100, credits: 4),
      Subject(name: 'Web Technologies', marks: 91, totalMarks: 100, credits: 3),
      Subject(name: 'Microprocessors', marks: 80, totalMarks: 100, credits: 3),
      Subject(name: 'Compiler Design', marks: 85, totalMarks: 100, credits: 3),
      Subject(name: 'Python Programming', marks: 95, totalMarks: 100, credits: 3),
    ],
    5: [
      Subject(name: 'Machine Learning', marks: 91, totalMarks: 100, credits: 4),
      Subject(name: 'Artificial Intelligence', marks: 89, totalMarks: 100, credits: 4),
      Subject(name: 'Mobile Application Development', marks: 93, totalMarks: 100, credits: 3),
      Subject(name: 'Cloud Computing', marks: 87, totalMarks: 100, credits: 3),
      Subject(name: 'Information Security', marks: 85, totalMarks: 100, credits: 3),
      Subject(name: 'Internet of Things', marks: 88, totalMarks: 100, credits: 3),
    ],
    6: [
      Subject(name: 'Deep Learning', marks: 90, totalMarks: 100, credits: 4),
      Subject(name: 'Big Data Analytics', marks: 86, totalMarks: 100, credits: 4),
      Subject(name: 'Blockchain Technology', marks: 88, totalMarks: 100, credits: 3),
      Subject(name: 'DevOps', marks: 92, totalMarks: 100, credits: 3),
      Subject(name: 'Natural Language Processing', marks: 84, totalMarks: 100, credits: 3),
      Subject(name: 'Computer Vision', marks: 89, totalMarks: 100, credits: 3),
    ],
    7: [
      Subject(name: 'Distributed Systems', marks: 85, totalMarks: 100, credits: 4),
      Subject(name: 'Cyber Security', marks: 91, totalMarks: 100, credits: 4),
      Subject(name: 'Advanced Database Systems', marks: 87, totalMarks: 100, credits: 3),
      Subject(name: 'Human Computer Interaction', marks: 90, totalMarks: 100, credits: 3),
      Subject(name: 'Project Management', marks: 88, totalMarks: 100, credits: 2),
    ],
    8: [
      Subject(name: 'Major Project', marks: 95, totalMarks: 100, credits: 8),
      Subject(name: 'Entrepreneurship Development', marks: 88, totalMarks: 100, credits: 2),
      Subject(name: 'Professional Ethics', marks: 92, totalMarks: 100, credits: 2),
      Subject(name: 'Internship Evaluation', marks: 90, totalMarks: 100, credits: 4),
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    // Expand current semester (5th) by default
    _expandedSemesters.add(5);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateSemesterGPA(List<Subject> subjects) {
    if (subjects.isEmpty) return 0.0;
    double totalGradePoints = 0.0;
    int totalCredits = 0;
    
    for (var subject in subjects) {
      final percentage = subject.marks / subject.totalMarks;
      final gradePoint = _getGradePoint(percentage);
      totalGradePoints += gradePoint * subject.credits;
      totalCredits += subject.credits;
    }
    
    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }

  double _getGradePoint(double percentage) {
    if (percentage >= 0.9) return 10.0;
    if (percentage >= 0.8) return 9.0;
    if (percentage >= 0.7) return 8.0;
    if (percentage >= 0.6) return 7.0;
    if (percentage >= 0.5) return 6.0;
    return 0.0;
  }

  double _calculateCGPA() {
    double totalGradePoints = 0.0;
    int totalCredits = 0;
    
    semesterData.forEach((semester, subjects) {
      for (var subject in subjects) {
        final percentage = subject.marks / subject.totalMarks;
        final gradePoint = _getGradePoint(percentage);
        totalGradePoints += gradePoint * subject.credits;
        totalCredits += subject.credits;
      }
    });
    
    return totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cgpa = _calculateCGPA();
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Academic Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.orange.shade900, Colors.deepOrange.shade800]
                  : [Colors.orange.shade700, Colors.deepOrange.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: Column(
        children: [
          // CGPA Overview Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.orange.shade900, Colors.deepOrange.shade800]
                    : [Colors.orange.shade600, Colors.deepOrange.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Cumulative GPA',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cgpa.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'out of 10.0',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatChip(
                      Icons.school,
                      '8 Semesters',
                      Colors.white70,
                    ),
                    _buildStatChip(
                      Icons.book,
                      '${_getTotalSubjects()} Subjects',
                      Colors.white70,
                    ),
                    _buildStatChip(
                      Icons.workspace_premium,
                      '${_getTotalCredits()} Credits',
                      Colors.white70,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Semesters List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: semesterData.length,
              itemBuilder: (context, index) {
                final semester = index + 1;
                final subjects = semesterData[semester]!;
                return _buildSemesterCard(semester, subjects, isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  int _getTotalSubjects() {
    int total = 0;
    semesterData.forEach((_, subjects) => total += subjects.length);
    return total;
  }

  int _getTotalCredits() {
    int total = 0;
    semesterData.forEach((_, subjects) {
      for (var subject in subjects) {
        total += subject.credits;
      }
    });
    return total;
  }

  Widget _buildSemesterCard(int semester, List<Subject> subjects, bool isDarkMode) {
    final isExpanded = _expandedSemesters.contains(semester);
    final semesterGPA = _calculateSemesterGPA(subjects);
    final totalCredits = subjects.fold<int>(0, (sum, subject) => sum + subject.credits);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedSemesters.remove(semester);
                } else {
                  _expandedSemesters.add(semester);
                  _controller.reset();
                  _controller.forward();
                }
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.orange.shade800, Colors.deepOrange.shade700]
                      : [Colors.orange.shade500, Colors.deepOrange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$semester',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Semester $semester',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${subjects.length} Subjects • $totalCredits Credits',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'SGPA',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        semesterGPA.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: subjects.asMap().entries.map((entry) {
                  final index = entry.key;
                  final subject = entry.value;
                  return _buildSubjectCard(subject, index, isDarkMode);
                }).toList(),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Subject subject, int index, bool isDarkMode) {
    final percentage = subject.marks / subject.totalMarks;
    final grade = _getGrade(percentage);
    final gradeColor = _getGradeColor(percentage);

    final Animation<double> fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(index * 0.08, 1.0, curve: Curves.easeOut),
    ));

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(index * 0.08, 1.0, curve: Curves.easeOut),
    ));

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: gradeColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subject.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: gradeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: gradeColor, width: 1.5),
                    ),
                    child: Text(
                      grade,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: gradeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 12.0,
                percent: percentage,
                progressColor: gradeColor,
                backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                animation: true,
                animationDuration: 800,
                barRadius: const Radius.circular(6),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.score,
                        size: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${subject.marks}/${subject.totalMarks} (${(percentage * 100).toStringAsFixed(1)}%)',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        size: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${subject.credits} Credits',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getGradeColor(double percentage) {
    if (percentage >= 0.9) {
      return Colors.green.shade600;
    } else if (percentage >= 0.8) {
      return Colors.lightGreen.shade600;
    } else if (percentage >= 0.7) {
      return Colors.amber.shade700;
    } else if (percentage >= 0.6) {
      return Colors.orange.shade700;
    } else {
      return Colors.red.shade600;
    }
  }

  String _getGrade(double percentage) {
    if (percentage >= 0.9) {
      return 'A+';
    } else if (percentage >= 0.8) {
      return 'A';
    } else if (percentage >= 0.7) {
      return 'B+';
    } else if (percentage >= 0.6) {
      return 'B';
    } else if (percentage >= 0.5) {
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
  final int credits;

  Subject({
    required this.name,
    required this.marks,
    required this.totalMarks,
    required this.credits,
  });
}