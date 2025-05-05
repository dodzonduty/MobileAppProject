// lib/features/events/join_us_page.dart

import 'package:flutter/material.dart';
import 'package:project/features/auth/widgets/registerlogin_field.dart';
import 'package:project/features/auth/widgets/registerlogin_btn.dart';
import 'package:project/features/auth/widgets/registerlogin_text.dart';

class JoinUsPage extends StatefulWidget {
  const JoinUsPage({Key? key}) : super(key: key);

  @override
  State<JoinUsPage> createState() => _JoinUsPageState();
}

class _JoinUsPageState extends State<JoinUsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final _wsCtrl = TextEditingController();
  final _tgCtrl = TextEditingController();

  // Dropdown state
  String? _year;
  String? _department;
  String? _gradYear;
  String? _role;
  String _wsCode = '+20';
  String _tgCode = '+20';

  // Options
  final _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  final _departments = ['CCEP', 'Power ', 'Others'];
  final _gradYears =
      List.generate(5, (i) => (DateTime.now().year + i).toString());
  final _roles = ['HR', 'PR', 'Member'];
  final _countryCodes = ['+20', '+1', '+44'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _wsCtrl.dispose();
    _tgCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: send data to your backend or service
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your information has been submitted!')),
      );
      Navigator.of(context).pop();
    }
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width * 0.05;

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
                          icon: Icon(Icons.chevron_left, size: 30),
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
            // Form
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name
                      FormWidget(
                        labelText: 'Full name',
                        hintText: 'Enter your full name',
                        keyPad: TextInputType.name,
                        controller: _nameCtrl,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Year & Department
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          Container(
                            width: (width - 2 * hPad - 12) / 2,
                            child: DropdownButtonFormField<String>(
                              value: _year,
                              decoration: _dropdownDecoration('Year'),
                              items: _years
                                  .map((y) => DropdownMenuItem(
                                        value: y,
                                        child: Text(y,
                                            style: const TextStyle(
                                                fontFamily: 'Inter')),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _year = v),
                              validator: (v) =>
                                  v == null ? 'Select year' : null,
                            ),
                          ),
                          SizedBox(
                            width: (width - 2 * hPad - 12) / 2,
                            child: DropdownButtonFormField<String>(
                              value: _department,
                              decoration: _dropdownDecoration('Department'),
                              items: _departments
                                  .map((d) => DropdownMenuItem(
                                        value: d,
                                        child: Text(d,
                                            style: const TextStyle(
                                                fontFamily: 'Inter')),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _department = v),
                              validator: (v) =>
                                  v == null ? 'Select department' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Graduation Year & Role
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _gradYear,
                              decoration:
                                  _dropdownDecoration('Graduation Year'),
                              items: _gradYears
                                  .map((y) => DropdownMenuItem(
                                        value: y,
                                        child: Text(y,
                                            style: const TextStyle(
                                                fontFamily: 'Inter')),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _gradYear = v),
                              validator: (v) =>
                                  v == null ? 'Select graduation year' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _role,
                              decoration: _dropdownDecoration('Role'),
                              items: _roles
                                  .map((r) => DropdownMenuItem(
                                        value: r,
                                        child: Text(r,
                                            style: const TextStyle(
                                                fontFamily: 'Inter')),
                                      ))
                                  .toList(),
                              onChanged: (v) => setState(() => _role = v),
                              validator: (v) =>
                                  v == null ? 'Select role' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // WhatsApp Number
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: 63,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _wsCode,
                                items: _countryCodes
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c,
                                              style: const TextStyle(
                                                  fontFamily: 'Inter')),
                                        ))
                                    .toList(),
                                onChanged: (v) => setState(() => _wsCode = v!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FormWidget(
                              labelText: 'WhatsApp number',
                              hintText: '01xxxxxxxxx',
                              keyPad: TextInputType.phone,
                              controller: _wsCtrl,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Telegram Number (Optional)
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _tgCode,
                                items: _countryCodes
                                    .map((c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c,
                                              style: const TextStyle(
                                                  fontFamily: 'Inter')),
                                        ))
                                    .toList(),
                                onChanged: (v) => setState(() => _tgCode = v!),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FormWidget(
                              labelText: 'Telegram number (Optional)',
                              hintText: '01xxxxxxxxx',
                              keyPad: TextInputType.phone,
                              controller: _tgCtrl,
                              validator: (_) => null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Submit button
                      RegLogBtn(
                        buttonText: 'Submit',
                        onPressed: _submit,
                        buttonColor: const Color(0xFF445B70),
                        buttonTextColor: Colors.white,
                      ),
                      const SizedBox(height: 24),
                    ],
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
