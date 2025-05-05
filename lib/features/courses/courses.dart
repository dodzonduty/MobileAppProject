import 'package:flutter/material.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import '../action_btn.dart';
import '../profile/widgets/drop_down_field.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  // Static list of courses (replace with Firebase or API data later)
  String? _selectedCourse;
  String? _selectedGroup;
  // ignore: unused_field
  final List<Map<String, dynamic>> _courses = [
    {
      'name': 'Introduction to Programming',
      'code': 'CS101',
      'credits': 3,
      'status': 'Completed',
    },
    {
      'name': 'Data Structures',
      'code': 'CS201',
      'credits': 4,
      'status': 'In Progress',
    },
    {
      'name': 'Database Systems',
      'code': 'CS301',
      'credits': 3,
      'status': 'In Progress',
    },
    {
      'name': 'Software Engineering',
      'code': 'CS401',
      'credits': 4,
      'status': 'Not Started',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SilverAppBarWidget(appBarText: "Courses"),
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
                                          _selectedCourse= value;
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
                                        }),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              ActionBtn(
                                buttonText: "Add Course",
                                icon: Icon(Icons.add_box_outlined),
                                buttonColor: Color(0xFF445B70),
                                buttonTextColor: Colors.white,
                                onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CoursesPage(), //wrong
                                  ),
                                );
                              },
                              ),
                              SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
    ),
);
}
}
