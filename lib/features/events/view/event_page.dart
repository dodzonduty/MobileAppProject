import 'package:flutter/material.dart';

final List<Text> titles = [
  Text(
    'the event done on date 20/10/2025 and the time is 10:00 AM and location in faculty of engineering of benha university at shoubra in the building 2 of mainstrean secound floor no SB1-03',
  ),
  Text(
    'the event done on date 7/9/2025 and the time is 9:00 AM and location in faculty of engineering of benha university at Benha in the building 2 of mainstrean secound floor no SB1-03',
  ),
  Text(
    'the event done on date 20/5/2025 and the time is 1:00 PM and location in faculty of engineering of benha university at shoubra in the building 1 of Credit secound floor no B',
  ),
  Text('koko'),
  Text('lolo'),
  Text('momo'),
];

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? left;
  final double? top;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.left,
    this.top,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
  });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: BackButton(
          color: Colors.black87,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.perm_identity),
                  const SizedBox(width: 8),
                  const Text(
                    'Student',
                    style: TextStyle(
                      color: Color(0xFF0A2533),
                      fontSize: 24,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                width: 350,
                height: 167,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 5,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    imageAsset,
                    width: 139,
                    height: 139,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 139);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25),
            //   child: Text(
            //     'Events',
            //     style: const TextStyle(
            //       color: Color(0xFF0A2533),
            //       fontSize: 24,
            //       fontFamily: 'Inter',
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'About',
                style: TextStyle(
                  color: Color(0xFF0A2533),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 7,
                ),
                width: 380,
                height: 160,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: Text(
                  imageAsset == 'assets/images/1.png'
                      ? titles[0].data!
                      : imageAsset == 'assets/images/2.png'
                          ? titles[1].data!
                          : imageAsset == 'assets/images/3.png'
                              ? titles[2].data!
                              : imageAsset == 'assets/images/4.png'
                                  ? titles[3].data!
                                  : imageAsset == 'assets/images/5.png'
                                      ? titles[4].data!
                                      : imageAsset == 'assets/images/6.png'
                                          ? titles[5].data!
                                          : 'No description available $imageAsset',
                ),
              ),
            ),
            //const Spacer(),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  CustomButton(
                    text: 'Add to Calendar',
                    onPressed: () {
                      // Add your calendar logic here
                    },
                  ),
                  const SizedBox(width: 5),
                  CustomButton(text: 'Invite Friends', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 396,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(
                text: 'Join the Event',
                padding: const EdgeInsets.symmetric(horizontal: 1),
                onPressed: () => {},
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
