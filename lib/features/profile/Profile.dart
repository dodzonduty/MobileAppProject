import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/features/courses/courses.dart';
import 'package:project/features/profile/widgets/list_tile_elements.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import '../action_btn.dart';
import '../auth/widgets/registerlogin_field.dart';
import '../auth/widgets/registerlogin_text.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widgets/drop_down_field.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  File? _image; // To store the selected image
  UserCredential? userCredential; // To store the user credential

  String? _selectedYear;
  String? _selectedDep;
  final TextEditingController _gpaController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTileElements(
                titleListTile: "Gallery",
                leadingIcon: Icons.photo_library,
                iconColor: Color(0xFF888888),
                listTileColor: Color(0xFF888888),
                listTileSource: ImageSource.gallery,
              ),
              ListTileElements(
                titleListTile: "Camera",
                leadingIcon: Icons.camera_alt,
                iconColor: Color(0xFF888888),
                listTileColor: Color(0xFF888888),
                listTileSource: ImageSource.camera,
              ),
            ],
          ),
        );
      },
    );
    if (pickedSource != null) {
      final XFile? image = await picker.pickImage(source: pickedSource);
      setState(() {
        if (image != null) {
          _image = File(image.path);
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SilverAppBarWidget(appBarText: "Edit Profile",),
            SliverToBoxAdapter(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : AssetImage(
                                        'assets/images/default_profile.png')
                                    as ImageProvider,
                          ),
                        ),
                        SizedBox(height: 20),
                        RegisterLoginText(
                          regTextContent: userCredential.toString(),
                          regTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                        RegisterLoginText(
                          regTextContent: 'Student',
                          regTextStyle: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF888888),
                          ),
                        ),
                        SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: FormWidget(
                                      labelText: "First Name",
                                      hintText: 'Enter your first name',
                                      keyPad: TextInputType.name,
                                      controller: _firstNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 9),
                                  Flexible(
                                    child: FormWidget(
                                      labelText: "Last Name",
                                      hintText: 'Enter your last name',
                                      keyPad: TextInputType.name,
                                      controller: _lastNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 22),
                              FormWidget(
                                labelText: "E-mail Address",
                                hintText: 'Enter your e-mail',
                                keyPad: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 22),
                              FormWidget(
                                labelText: "Phone Number",
                                hintText: 'Phone number as 1XXXXXXXX',
                                keyPad: TextInputType.phone,
                                controller: _phoneNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  if (!RegExp(r'^(\+20|0)?1[0-2,5]\d{8}$')
                                      .hasMatch(value)) {
                                    return "Phone must have 9 digits after 1 (e.g., 1XXXXXXXX)";
                                  }
                                  return null;
                                },
                                prefixWidget: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CountryFlag.fromCountryCode('EG',
                                        height: 20, width: 28),
                                    SizedBox(width: 6),
                                    Text('+20',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.black)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 22),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownFormWidget(
                                      labelText: "Year",
                                      hintText: "Select Year",
                                      value: _selectedYear,
                                      items: [
                                        'Level Zero',
                                        'Level One',
                                        'Level Two',
                                        'Level Three',
                                        'Level Four'
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedYear = value;
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
                                        labelText: "Department",
                                        hintText: "Select Department",
                                        value: _selectedDep,
                                        items: [
                                          'CCEP',
                                          'EEC',
                                          'ESEE',
                                          'ISE',
                                          'CSM'
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedDep = value;
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
                              SizedBox(height: 22),
                              ActionBtn(
                                buttonText: "Save Changes",
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
