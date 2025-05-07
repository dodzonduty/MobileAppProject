import 'package:flutter/material.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import '../database/Database.dart';
import '../Services/auth/auth_service.dart';
import '../action_btn.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _allCourses = [];
  List<String> _selectedCourseIds = [];

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _dbHelper.getAllCourses();
    print('Loaded courses: $courses');
    setState(() {
      _allCourses = List<Map<String, dynamic>>.from(courses);
    });
  }

  Future<void> _enrollCourses() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final studentId = await _dbHelper.ensureStudentExists(
        user.uid,
        user.displayName ?? 'Unknown',
        user.email ?? '',
      );
      print('Student ID for user ${user.uid}: $studentId');
      int successCount = 0;
      for (String courseId in _selectedCourseIds) {
        final result = await _dbHelper.enrollStudent(studentId, courseId);
        print('Enroll result for course $courseId: $result');
        if (result > 0) {
          successCount++;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '$successCount/${_selectedCourseIds.length} courses enrolled successfully!'),
        ),
      );
      if (successCount > 0) {
        Navigator.pop(context, true); // Return true to indicate successful enrollment
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to enroll in courses.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SilverAppBarWidget(
              appBarText: "Add Courses",
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  _allCourses.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _allCourses.length,
                          itemBuilder: (context, index) {
                            final course = _allCourses[index];
                            final isSelected = _selectedCourseIds.contains(course['course_ID']);
                            return CheckboxListTile(
                              title: Text(course['name']),
                              subtitle: Text(
                                  'ID: ${course['course_ID']} | Credits: ${course['credit_hours']}'),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedCourseIds.add(course['course_ID']);
                                  } else {
                                    _selectedCourseIds.remove(course['course_ID']);
                                  }
                                });
                              },
                            );
                          },
                        ),
                  SizedBox(height: 20),
                  ActionBtn(
                    buttonText: "Enroll Selected Courses",
                    icon: Icon(Icons.save),
                    buttonColor: Color(0xFF445B70),
                    buttonTextColor: Colors.white,
                    onPressed: _selectedCourseIds.isEmpty
                        ? () {}
                        : () {
                            _enrollCourses();
                          },
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