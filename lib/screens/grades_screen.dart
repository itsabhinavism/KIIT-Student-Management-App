import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/grade_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/kiit_logo_widget.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Academic Report'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: const [
          KiitLogoWidget(),
        ],
      ),
      body: FutureBuilder<List<Grade>>(
        future: context.read<ApiService>().getMyGrades(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No grades available'));
          }

          // Group by semester
          final gradesBySemester = <int, List<Grade>>{};
          for (final grade in snapshot.data!) {
            gradesBySemester.putIfAbsent(grade.semester, () => []).add(grade);
          }

          final sortedSemesters = gradesBySemester.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedSemesters.length,
            itemBuilder: (context, index) {
              final semester = sortedSemesters[index];
              final grades = gradesBySemester[semester]!;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(
                    'Semester $semester',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${grades.length} courses',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  children: grades
                      .map((grade) => _buildGradeItem(context, grade))
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildGradeItem(BuildContext context, Grade grade) {
    Color gradeColor;
    if (grade.sgpa >= 9.0) {
      gradeColor = Colors.green;
    } else if (grade.sgpa >= 8.0) {
      gradeColor = Colors.blue;
    } else if (grade.sgpa >= 7.0) {
      gradeColor = Colors.orange;
    } else {
      gradeColor = Colors.red;
    }

    return ListTile(
      title: Text(
        grade.courseName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(grade.courseCode),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                grade.sgpa.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  grade.letterGrade,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
