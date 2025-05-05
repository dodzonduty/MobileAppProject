import 'package:country_flags/country_flags.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added for Firestore
import 'package:project/features/profile/widgets/list_tile_elements.dart';
import '../auth/widgets/registerlogin_btn.dart';
import '../auth/widgets/registerlogin_field.dart';
import '../auth/widgets/registerlogin_text.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Services/auth/auth_service.dart'; // Import AuthService

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
  File? _image;
  String displayName = 'Guest'; // To store the computed name
  bool showNote = false; // To conditionally show the note

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
        // First, try to fetch data from Firestore
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (doc.exists) {
            final data = doc.data();
            final firstName = data?['firstName'] as String?;
            final lastName = data?['lastName'] as String?;
            if (firstName != null && lastName != null) {
              setState(() {
                displayName = '$firstName $lastName';
                showNote = false; // No note if both names are present
                _firstNameController.text = firstName;
                _lastNameController.text = lastName;
                _emailController.text = data?['email'] ?? email;
                _phoneNumberController.text = data?['phoneNumber'] ?? '';
              });
              return;
            } else if (firstName != null) {
              setState(() {
                displayName = firstName;
                showNote = false; // No note if at least firstName exists
                _firstNameController.text = firstName;
                _lastNameController.text = lastName ?? '';
                _emailController.text = data?['email'] ?? email;
                _phoneNumberController.text = data?['phoneNumber'] ?? '';
              });
              return;
            }
          }
        } catch (e) {
          print('Error fetching Firestore data: $e');
        }

        // If Firestore data is incomplete or missing, check provider
        final provider = user.providerData
            .firstWhere((data) => data.providerId != 'firebase',
                orElse: () => user.providerData.first)
            .providerId;

        if (provider == 'microsoft.com') {
          // Microsoft user: extract first name from email
          final regex = RegExp(r'([a-zA-Z]+)\d+@feng\.bu\.edu\.eg');
          final match = regex.firstMatch(email);
          final extractedName =
              StringExtension(match?.group(1))?.capitalize() ??
                  email.split('@').first;
          setState(() {
            displayName = extractedName;
            showNote = true; // Show note if no Firestore data
            _firstNameController.text = extractedName;
            _lastNameController.text = '';
            _emailController.text = email;
            _phoneNumberController.text = '';
          });
        } else {
          // For other users without Firestore data, fall back to email local part
          setState(() {
            displayName = email.split('@').first;
            showNote = true; // Show note if no Firestore data
            _firstNameController.text = email.split('@').first;
            _lastNameController.text = '';
            _emailController.text = email;
            _phoneNumberController.text = '';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              expandedHeight: 80,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 16, left: 3, right: 20),
                child: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.chevron_left, size: 30),
                          onPressed: () => Navigator.pushNamed(context, '/home',
                              arguments: {'selectedIndex': 0}),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RegisterLoginText(
                          regTextContent: "Edit Profile",
                          regTextStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : AssetImage('assets/images/default_profile.png')
                                as ImageProvider,
                      ),
                    ),
                    SizedBox(height: 20),
                    RegisterLoginText(
                      regTextContent:
                          displayName, // Updated to show computed name
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
                    if (showNote)
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: RegisterLoginText(
                          regTextContent: 'please fill your informations',
                          regTextStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
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
                                    height: 20,
                                    width: 28,
                                    shape: const RoundedRectangle(6)),
                                SizedBox(width: 6),
                                Text('+20',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ],
                            ),
                          ),
                          SizedBox(height: 22),
                          RegLogBtn(
                            buttonText: "Save Changes",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: Implement save logic to Firestore for RawRaw
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Changes saved!')),
                                ); // Close the profile page
                              }
                            },
                            buttonColor: Color(0xFF445B70),
                            buttonTextColor: Colors.white,
                          ),
                          SizedBox(height: 24),
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
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  }
}
