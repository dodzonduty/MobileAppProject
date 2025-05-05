import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        // Enable scrolling
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(25.0),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  child: Image.asset(
                    'assets/images/Feng_big.png', // Local image
                    fit: BoxFit.cover, // Cover the entire container
                    height: 200, // Fixed height for the image
                  ),
                ),
              ), // Using the local image
              const SizedBox(height: 20), // Spacing
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  """
                  The origins of the faculty trace back to the Engineering Division of the Higher Technical Institute in Cairo, which was established in October 1961. The institute was affiliated with the Ministry of Higher Education and comprised three divisions: the Engineering Division, the Agricultural Division, and the Commercial Division. The Engineering Division awarded a Bachelor's degree in Engineering after five years of study in English.

                  In October 1975, the Engineering Division of the Higher Technical Institute was merged into the Faculty of Technology in Matariya - Helwan University.

                  In April 1976, Presidential Decree No. 367 of 1976 was issued, transferring the Higher Technical Institute in Shubra to Ain Shams University under the name of the Faculty of Engineering, Shubra. On October 30, 1976, Presidential Decree No. 1069 of 1976 was issued, transferring the Faculty of Engineering, Shubra, to Zagazig University / Benha Branch. Finally, Presidential Decree No. 84 of 2005 was issued to establish Benha University, with the Faculty of Engineering, Shubra, as one of its faculties.
                  """,
                  style: TextStyle(
                    fontSize: 16, // Slightly smaller font size for better fit
                    color: Colors.black,
                    height: 1.5, // Adjust line height for better readability
                  ),
                  textAlign:
                      TextAlign.left, // Justify text for proper alignment
                  softWrap: true, // Ensure text wraps properly
                ),
              ),
              // Add more components as per the Figma design
            ],
          ),
        ),
      ),
    );
  }
}
