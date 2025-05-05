import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_flags/country_flags.dart';
import '../Services/auth/auth_service.dart';
import '../action_btn.dart';
import '../auth/widgets/registerlogin_field.dart';
import '../auth/widgets/registerlogin_text.dart';
import '../courses/courses.dart';
import '../silver_app_bar_widget.dart';
import 'widgets/drop_down_field.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String displayName = 'Guest';
  bool showNote = false;

  String? _selectedYear;
  String? _selectedDep;
  final TextEditingController _gpaController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    if (user != null) {
      String? email = user.email;
      if (email != null) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (doc.exists) {
            final data = doc.data();
            final firstName = data?['firstName'] as String?;
            final lastName = data?['lastName'] as String?;
            setState(() {
              displayName = (firstName != null && lastName != null)
                  ? '$firstName $lastName'
                  : firstName ?? email.split('@').first;
              showNote = firstName == null;
              _firstNameController.text = firstName ?? '';
              _lastNameController.text = lastName ?? '';
              _emailController.text = data?['email'] ?? email;
              _phoneNumberController.text = data?['phoneNumber'] ?? '';
            });
            return;
          }
        } catch (e) {
          print('Error fetching Firestore data: $e');
        }

        final provider = user.providerData
            .firstWhere((data) => data.providerId != 'firebase',
                orElse: () => user.providerData.first)
            .providerId;

        if (provider == 'microsoft.com') {
          final regex = RegExp(r'([a-zA-Z]+)\d+@feng\.bu\.edu\.eg');
          final match = regex.firstMatch(email);
          final extractedName =
              match != null ? match.group(1)?.capitalize() : null;
          setState(() {
            displayName = extractedName ?? email.split('@').first;
            showNote = true;
            _firstNameController.text = extractedName ?? '';
            _lastNameController.text = '';
            _emailController.text = email;
            _phoneNumberController.text = '';
          });
        } else {
          setState(() {
            displayName = email.split('@').first;
            showNote = true;
            _firstNameController.text = displayName;
            _lastNameController.text = '';
            _emailController.text = email;
            _phoneNumberController.text = '';
          });
        }
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
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
            SilverAppBarWidget(appBarText: "Edit Profile"),
            SliverToBoxAdapter(
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
                                'assets/images/default_profile.png') as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RegisterLoginText(
                      regTextContent: displayName,
                      regTextStyle: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    RegisterLoginText(
                      regTextContent: 'Student',
                      regTextStyle: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF888888),
                      ),
                    ),
                    if (showNote) ...[
                      const SizedBox(height: 8),
                      RegisterLoginText(
                        regTextContent:
                            'Name retrieved from email. Please update it if incorrect.',
                        regTextStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
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
                              const SizedBox(width: 9),
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
                          const SizedBox(height: 22),
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
                          const SizedBox(height: 22),
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
                                const SizedBox(width: 6),
                                const Text('+20',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
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
                                  itemColor: const Color(0xFF445B70),
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
                                  items: ['CCEP', 'EEC', 'ESEE', 'ISE', 'CSM'],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDep = value;
                                    });
                                  },
                                  itemColor: const Color(0xFF834746),
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
                          const SizedBox(height: 22),
                          FormWidget(
                              labelText: "GPA",
                              hintText: 'Enter your GPA (e.g., 3.50)',
                              keyPad: TextInputType.number,
                              controller: _gpaController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your GPA';
                                }
                                final gpa = double.tryParse(value);
                                if (gpa == null || gpa < 0 || gpa > 4) {
                                  return 'Please enter a valid GPA (0.0 to 4.0)';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 22),
                          ActionBtn(
                            buttonText: "Save Changes",
                            buttonColor: const Color(0xFF445B70),
                            buttonTextColor: Colors.white,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CoursesPage(), //wrong
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Extension to capitalize the first letter
extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}':this;
}
}
