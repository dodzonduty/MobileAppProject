import 'package:flutter/material.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import '../action_btn.dart';
import '../profile/widgets/drop_down_field.dart';
import 'add_course_page.dart';
import '../database/Database.dart';
import '../Services/auth/auth_service.dart';

class CoursesPage extends StatefulWidget {
  final VoidCallback onBackToHome; // Callback to switch to HomePage
  const CoursesPage({super.key, required this.onBackToHome});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String? _selectedCourse;
  String? _selectedGroup;
  List<Map<String, dynamic>> _enrolledCourses = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadEnrolledCourses();
  }

  Future<void> _loadEnrolledCourses() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final studentId = await _dbHelper.ensureStudentExists(
        user.uid,
        user.displayName ?? 'Unknown',
        user.email ?? '',
      );
      print('Fetching enrolled courses for student ID: $studentId');
      final courses = await _dbHelper.readData(
        'SELECT course.course_ID, course.name, course.credit_hours FROM enrollment JOIN course ON enrollment.course_ID = course.course_ID WHERE enrollment.student_id = ?',
        [studentId],
      );
      print('Enrolled courses: $courses');
      setState(() {
        _enrolledCourses = List<Map<String, dynamic>>.from(courses);
      });
    } else {
      print('No user logged in');
      setState(() {
        _enrolledCourses = [];
      });
    }
  }

  Future<void> _deleteCourse(String courseId) async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final studentId = await _dbHelper.ensureStudentExists(
        user.uid,
        user.displayName ?? 'Unknown',
        user.email ?? '',
      );
      final result = await _dbHelper.deleteEnrollment(studentId, courseId);
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course removed successfully!')),
        );
        await _loadEnrolledCourses();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove course.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to remove courses.')),
      );
    }
  }

  // Handle physical back button
  Future<bool> _onWillPop() async {
    widget.onBackToHome(); // Switch to HomePage
    return false; // Prevent default pop
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SilverAppBarWidget(
              appBarText: "Courses",
              onBackPressed: widget.onBackToHome, // Switch to HomePage
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownFormWidget(
                                labelText: "Courses",
                                hintText: "Select Courses",
                                value: _selectedCourse,
                                items: [
                                  'Level Zero',
                                  'Level One',
                                  'Level Two',
                                  'Level Three',
                                  'Level Four'
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCourse = value;
                                  });
                                },
                                itemColor: Color(0xFF445B70),
                                itemIcons: {
                                  'Level Zero': Icons.filter_none,
                                  'Level One': Icons.looks_one,
                                  'Level Two': Icons.looks_two,
                                  'Level Three': Icons.looks_3,
                                  'Level Four': Icons.looks_4,
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownFormWidget(
                                labelText: "Group",
                                hintText: "Select Group",
                                value: _selectedGroup,
                                items: [
                                  'CCEP',
                                  'EEC',
                                  'ESEE',
                                  'ISE',
                                  'CSM'
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGroup = value;
                                  });
                                },
                                itemColor: Color(0xFF834746),
                                itemImageIcons: {
                                  'CCEP': 'assets/images/ccep.png',
                                  'EEC': 'assets/images/eec.png',
                                  'ESEE': 'assets/images/esee.png',
                                  'ISE': 'assets/images/ise.png',
                                  'CSM': 'assets/images/csm.png',
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ActionBtn(
                          buttonText: "Add Course",
                          icon: Icon(Icons.add_box_outlined),
                          buttonColor: Color(0xFF445B70),
                          buttonTextColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCoursePage(),
                              ),
                            ).then((result) {
                              if (result == true) {
                                _loadEnrolledCourses();
                              }
                            });
                          },
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Enrolled Courses",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        _enrolledCourses.isEmpty
                            ? Text("No courses enrolled.")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _enrolledCourses.length,
                                itemBuilder: (context, index) {
                                  final course = _enrolledCourses[index];
                                  return ListTile(
                                    title: Text(course['name']),
                                    subtitle: Text(
                                        'ID: ${course['course_ID']} | Credits: ${course['credit_hours']}'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteCourse(course['course_ID']);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}