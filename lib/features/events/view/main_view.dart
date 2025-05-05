import 'package:flutter/material.dart';
import 'page_view_model.dart';

class MainView extends StatelessWidget {
  /// Called when one of the 6 cards is tapped.
  final void Function(PageViewModel viewModel) onItemTapped;
  const MainView({super.key, required this.onItemTapped});
  static const int cardsPerRow = 2;
  static const double horizontalSpacing = 27;
  static const double verticalSpacing = 28;

  final List<PageViewModel> _pages = const [
    PageViewModel(
      pageNumber: 1,
      title: 'Shoubra Student Union',
      description:
          'The Shoubra Engineering Student Union is a dynamic organization dedicated to representing and supporting students at Shoubra Faculty of Engineering. It fosters academic excellence, professional development, and extracurricular engagement through various initiatives, including workshops, competitions, and networking events. The union serves as a bridge between students and faculty, ensuring their voices are heard and their concerns addressed. It also organizes social and cultural activities to enhance student life and create a strong sense of community. Through its efforts, the union empowers future engineers with the skills, knowledge, and opportunities needed for success.',
      imageAsset: 'assets/images/1.png',
    ),
    PageViewModel(
      pageNumber: 2,
      title: 'IEEE',
      description:
          'The IEEE Student Branch at Shoubra fosters innovation in engineering through events, workshops, and competitions.',
      imageAsset: 'assets/images/2.png',
    ),
    PageViewModel(
      pageNumber: 3,
      title: 'Google Devs',
      description:
          'A hub for Google Developer student clubs at Shoubra, offering resources, hackathons, and mentorship.',
      imageAsset: 'assets/images/3.png',
    ),
    PageViewModel(
      pageNumber: 4,
      title: 'MSP Shoubra',
      description:
          '''
Microsoft Student Partners - Shoubra (MSP Shoubra) is a dynamic student-run community at Shoubra Faculty of Engineering, Benha University. As part of the global Microsoft Learn Student Ambassadors program, MSP Shoubra empowers students by bridging the gap between academic knowledge and industry skills. The club organizes workshops, tech talks, and hands-on events focused on Microsoft technologies and broader fields like AI, cybersecurity, cloud computing, and software development. With a strong culture of collaboration, learning, and innovation, MSP Shoubra provides students with the opportunity to build real-world skills, connect with like-minded peers, and become future tech leaders.
''',
      imageAsset: 'assets/images/4.png',
    ),
    PageViewModel(
      pageNumber: 5,
      title: 'ICPC Shoubra',
      description:
          '''
ICPC Shoubra is the competitive programming hub of Shoubra Faculty of Engineering, where students come together to sharpen their problem-solving skills and dive deep into algorithms, data structures, and logic. As part of the global International Collegiate Programming Contest (ICPC) community, the Shoubra team trains rigorously to compete at local and regional levels, representing the faculty with pride. More than just contests, ICPC Shoubra is about teamwork, perseverance, and continuous learning. It's where aspiring programmers transform into world-class competitors—and where passion for code meets the thrill of competition.
          ''',
      imageAsset: 'assets/images/5.png',
    ),
    PageViewModel(
      pageNumber: 6,
      title: 'SRT',
      description:
          'SRT provides rapid transit solutions and student discounts for our campus community.',
      imageAsset: 'assets/images/6.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Partners & Events'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 43),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final gapTotal = horizontalSpacing * (cardsPerRow - 1);
            final cardSize = (constraints.maxWidth - gapTotal) / cardsPerRow;

            return Wrap(
              spacing: horizontalSpacing,
              runSpacing: verticalSpacing,
              children: _pages.map((p) {
                final idx = _pages.indexOf(p);
                final bg = idx == 3 ? Colors.black : Colors.white;
                return SizedBox(
                  width: cardSize,
                  height: 200,
                  child: GestureDetector(
                    onTap: () => onItemTapped(p),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          p.imageAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 100);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
