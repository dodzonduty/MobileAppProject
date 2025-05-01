import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/features/profile/widgets/list_tile_elements.dart';
import '../auth/widgets/registerlogin_btn.dart';
import '../auth/widgets/registerlogin_field.dart';
import '../auth/widgets/registerlogin_text.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker
import 'dart:io'; // To handle file operations
import 'package:flutter/services.dart'; // For platform-specific operations

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _image; // To store the selected image
  UserCredential? userCredential; // To store the user credential
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
          // SliverAppBar that disappears on scroll
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
                        icon: Icon(
                          Icons.chevron_left,
                          size: 30),
                        onPressed: () => Navigator.pop(context),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : AssetImage('assets/images/default_profile.png') as ImageProvider,
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
                            Expanded(
                              child: FormWidget(
                                labelText: "First Name",
                                hintText: 'Enter your first name',
                                keyPad: TextInputType.name,
                              ),
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: FormWidget(
                                labelText: "Last Name",
                                hintText: 'Enter your last name',
                                keyPad: TextInputType.name,
                              ),
                            ),
                          ],
                        ),
                        FormWidget(
                          labelText: "Username",
                          hintText: 'Enter your username',
                          keyPad: TextInputType.text,
                        ),
                        SizedBox(height: 22),
                        FormWidget(
                          labelText: "E-mail Address",
                          hintText: 'Enter your e-mail',
                          keyPad: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 22),
                        FormWidget(
                          labelText: "Phone Number",
                          hintText: 'Enter your phone number',
                          keyPad: TextInputType.phone,
                        ),
                        SizedBox(height: 22),
                        RegLogBtn(
                          buttonText: "Save Changes",
                          onPressed: () {},
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