import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_flags/country_flags.dart';
import 'package:path_provider/path_provider.dart';
import '../Services/auth/auth_service.dart';
import '../action_btn.dart';
import '../auth/widgets/registerlogin_field.dart';
import '../auth/widgets/registerlogin_text.dart';
import '../courses/courses.dart';
import '../silver_app_bar_widget.dart';
import 'widgets/drop_down_field.dart';

class EditProfilePage extends StatefulWidget {
  final VoidCallback onBackToHome; // Callback to switch to HomePage
  const EditProfilePage({super.key, required this.onBackToHome});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String? _profileImagePath;
  String displayName = 'Guest';
  bool showNote = false;
  bool _isSavingImage = false;

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
    if (user == null || user.email == null) {
      print('No user or email found');
      setState(() {
        displayName = 'Guest';
        showNote = true;
        _firstNameController.text = '';
        _lastNameController.text = '';
        _emailController.text = '';
        _phoneNumberController.text = '';
        _selectedYear = 'Level Zero';
        _selectedDep = 'CCEP';
        _gpaController.text = '';
        _profileImagePath = null;
      });
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        final firstName = data?['firstName'] as String?;
        final lastName = data?['lastName'] as String?;
        final year = data?['year'] as String?;
        final department = data?['department'] as String?;
        final profileImagePath = data?['profileImagePath'] as String?;
        print('Fetched Firestore data: $data');
        print('Raw Year: $year, Raw Department: $department, ProfileImagePath: $profileImagePath');

        // Check if the local image file exists
        String? validProfileImagePath;
        if (profileImagePath != null) {
          final file = File(profileImagePath);
          if (await file.exists()) {
            validProfileImagePath = profileImagePath;
          } else {
            print('Local image file does not exist: $profileImagePath');
          }
        }

        setState(() {
          displayName = (firstName != null && lastName != null)
              ? '$firstName $lastName'
              : firstName ?? user.email!.split('@').first;
          showNote = firstName == null;
          _firstNameController.text = firstName ?? '';
          _lastNameController.text = lastName ?? '';
          _emailController.text = data?['email'] ?? user.email!;
          _phoneNumberController.text = data?['phoneNumber'] ?? '';
          _selectedYear = year ?? 'Level Zero';
          _selectedDep = department ?? 'CCEP';
          _gpaController.text = data?['gpa']?.toString() ?? '';
          _profileImagePath = validProfileImagePath;
          print('Initialized state: Year=$_selectedYear, Dep=$_selectedDep, ImagePath=$_profileImagePath');
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
      final match = regex.firstMatch(user.email!);
      final extractedName = StringExtension(match?.group(1))?.capitalize();
      setState(() {
        displayName = extractedName ?? user.email!.split('@').first;
        showNote = true;
        _firstNameController.text = extractedName ?? '';
        _lastNameController.text = '';
        _emailController.text = user.email!;
        _phoneNumberController.text = '';
        _selectedYear = 'Level Zero';
        _selectedDep = 'CCEP';
        _gpaController.text = '0.0';
        _profileImagePath = null;
        print('Microsoft provider defaults: Year=$_selectedYear, Dep=$_selectedDep, ImagePath=$_profileImagePath');
      });
    } else {
      setState(() {
        displayName = user.email!.split('@').first;
        showNote = true;
        _firstNameController.text = user.email!.split('@').first;
        _lastNameController.text = '';
        _emailController.text = user.email!;
        _phoneNumberController.text = '';
        _selectedYear = 'Level Zero';
        _selectedDep = 'CCEP';
        _gpaController.text = '';
        _profileImagePath = null;
        print('Default provider defaults: Year=$_selectedYear, Dep=$_selectedDep, ImagePath=$_profileImagePath');
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: const Text('Would you like to take a new photo or select one from your gallery?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final pickedImage = await picker.pickImage(source: ImageSource.camera);
                if (pickedImage != null) {
                  setState(() {
                    _image = File(pickedImage.path);
                  });
                }
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final pickedImage = await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  setState(() {
                    _image = File(pickedImage.path);
                  });
                }
              },
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _isSavingImage = true;
      });
      try {
        String? profileImagePath = _profileImagePath;
        if (_image != null) {
          // Save image to local storage
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = '${directory.path}/${user.uid}.jpg';
          final newImageFile = await _image!.copy(imagePath);
          print('Image saved locally to: $imagePath');
          profileImagePath = newImageFile.path;
        }

        // Save profile data to Firestore
        final payload = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
          'year': _selectedYear,
          'department': _selectedDep,
          'gpa': _gpaController.text,
          'profileImagePath': profileImagePath,
        };
        print('Saving to Firestore: $payload');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(payload, SetOptions(merge: true));

        setState(() {
          _profileImagePath = profileImagePath;
          _image = null; // Clear local image after saving
          _isSavingImage = false;
        });

        print('Profile saved: Year=$_selectedYear, Department=$_selectedDep, ImagePath=$_profileImagePath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile saved successfully!')),
        );
      } catch (e) {
        print('Error saving profile: $e');
        setState(() {
          _isSavingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    } else {
      print('No user for saving profile');
      setState(() {
        _isSavingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to save profile.')),
      );
    }
  }

  // Synchronous wrapper for the async save operation
  void _handleSaveProfile() {
    if (_formKey.currentState!.validate()) {
      _saveProfile().then((_) {
        widget.onBackToHome();
      }).catchError((e) {
        print('Error in handleSaveProfile: $e');
      });
    }
  }

  // Handle physical back button
  Future<bool> _onWillPop() async {
    print('EditProfilePage WillPopScope triggered, canPop: ${Navigator.of(context).canPop()}');
    widget.onBackToHome();
    return false; // Prevent default pop
  }

  @override
  Widget build(BuildContext context) {
    print('Building EditProfilePage, Year=$_selectedYear, Dep=$_selectedDep, ImagePath=$_profileImagePath');
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SilverAppBarWidget(
                    appBarText: "Edit Profile",
                    onBackPressed: () {
                      print('Back button pressed');
                      widget.onBackToHome();
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _isSavingImage ? null : _pickImage,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : _profileImagePath != null
                                          ? FileImage(File(_profileImagePath!))
                                          : AssetImage('assets/images/default_profile.png')
                                              as ImageProvider,
                                ),
                                if (_isSavingImage)
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                              ],
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
                                    if (!_isSavingImage) {
                                      print('Save Changes pressed');
                                      _handleSaveProfile();
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
              if (_isSavingImage)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
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