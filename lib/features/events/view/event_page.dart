import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:project/features/events/view/join_us_page.dart';
import 'package:share_plus/share_plus.dart';

final List<String> titles = [
  'The Student Engineering Student Union takes place on 20/10/2025 at 10:00 AM in Building 2, 2nd Floor, SB1-03, Faculty of Engineering, Benha University – Shoubra campus.',
  'IEEE Benha University Student Branch is organizing a workshop on 25/10/2025 at 2:00 PM in Building 2, 5th Floor, SB5-03, Faculty of Engineering, Benha University – Shoubra campus.',
  'GDG Benha University is hosting a seminar on 30/10/2025 at 11:00 AM in Building 2, 3nd Floor, SB2-03, Faculty of Engineering, Benha University – Shoubra campus.',
  'The MSP Faculty of Engineering is organizing a meeting on 05/11/2025 at 9:00 AM in Building 1, 2nd Floor, Room A, Faculty of Engineering, Benha University – Shoubra campus.',
  'ICPC Benha University is holding a competition on 10/11/2025 at 1:00 PM in Building 2, 4th Floor, SB4-03, Faculty of Engineering, Benha University – Shoubra campus.',
  'SRT Faculty of Engineering is organizing a workshop on 15/11/2025 at 3:00 PM in Building 2, 1st Floor, , Faculty of Engineering, Benha University – Shoubra campus.',
];

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? left;
  final double? top;
  final EdgeInsetsGeometry padding;

  CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.left,
    this.top,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFF445B70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      ),
      child: onPressed != null
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF445B70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  height: 0,
                ),
              ),
            )
          : Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  height: 0,
                ),
              ),
            ),
    );
  }
}

class EventPage extends StatelessWidget {
  final String imageAsset;

  const EventPage({super.key, required this.imageAsset});

  DateTime? _parseEventDate(String description) {
    try {
      // Extract date and time from the description string
      final dateRegex =
          RegExp(r'(\d{2}/\d{2}/\d{4}) at (\d{1,2}:\d{2} (?:AM|PM))');
      final match = dateRegex.firstMatch(description);
      if (match != null) {
        final dateStr = match.group(1);
        final timeStr = match.group(2);
        final dateTimeStr = '$dateStr $timeStr';
        final formatter = DateFormat('dd/MM/yyyy hh:mm a');
        return formatter.parse(dateTimeStr);
      }
    } catch (e) {
      // ignore parsing errors
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // pick description based on image name
    final idx = int.tryParse(imageAsset.split('/').last.split('.').first) ?? -1;
    final desc = (idx >= 1 && idx <= titles.length)
        ? titles[idx - 1]
        : 'No description available';

    // common padding
    final hPad = MediaQuery.of(context).size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Events',
          style: TextStyle(
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // … (your user icon + image + About header) …

              // description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(desc,
                    style: const TextStyle(fontSize: 16, height: 1.5)),
              ),

              const SizedBox(height: 24),

              // action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final eventDate = _parseEventDate(desc);
                        if (eventDate != null) {
                          final event = Event(
                            title: 'Event at Benha University',
                            description: desc,
                            location:
                                'Building 2, 2nd Floor, SB1-03, Faculty of Engineering, Benha University – Shoubra campus',
                            startDate: eventDate,
                            endDate: eventDate.add(const Duration(hours: 1)),
                          );
                          Add2Calendar.addEvent2Cal(event);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Could not parse event date')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF445B70),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      child: const Text('Add to Calendar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Share.share(desc, subject: 'Join this event!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF445B70),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                      ),
                      child: const Text('Invite Friends',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // join button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  //onPressed: () {Navigation.of(context).pushNamed('/join');},
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => JoinUsPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF445B70),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                  ),
                  child: const Text('Join the Event',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
