import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DishDetailScreen extends StatefulWidget {
  const DishDetailScreen({super.key});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + divider must be in the same Stack so the divider can render
            // behind the overflowing vegetables image.
            _buildHeaderWithDividerBehind(),
            _buildIngredientsSection(),
            const SizedBox(height: 20),
            _buildAppliancesSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithDividerBehind() {
    // Keep these in sync with the header height and divider thickness/height.
    const headerHeight = 225.0;
    const dividerThickness = 8.0;
    const dividerHeight = 42.0;

    return SizedBox(
      // Reserve enough space so the divider still occupies layout space,
      // while being painted behind the header's overflow.
      height: headerHeight + dividerHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Back layer: divider
          const Positioned(
            left: 0,
            right: 0,
            top: headerHeight,
            child: Divider(
              thickness: dividerThickness,
              height: dividerHeight,
              color: Color(0xFFF7F7F7),
            ),
          ),

          // Front layer: header (contains overflowing vegetables image)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: _buildHeader(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;

    // Static UI (as per design screenshot)
    const headerTitle = 'Masala Muglai';

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: 225,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -70,
              top: -20,
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF9F2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        headerTitle,
                        style: GoogleFonts.openSans(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 12),
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF51C452),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                '4.2',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(Icons.star, size: 12, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: screenWidth * 0.58,
                    child: Text(
                      'Mughlai Masala is a style of cookery developed in the Indian Subcontinent by the imperial kitchens of the Mughal Empire.',
                      style: GoogleFonts.openSans(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/start_chef2/clock_new.svg',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '1 hour',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Base header image: vegetables.png (can overflow into the divider).
            Positioned(
              right: -180,
              bottom: -40,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/start_chef2/vegetables.png',
                  width: 380,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Top overlay image: vegetables2.png (slightly to the right, above vegetables.png)
            Positioned(
              right: -175,
              bottom: -100,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/start_chef2/vegetables2.png',
                  width: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ingredients',
            style: GoogleFonts.openSans(
              fontSize: 26,
              fontWeight: FontWeight.w700, // Bold
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'For 2 people',
            style: GoogleFonts.openSans(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w400, // Regular
            ),
          ),
          const Divider(height: 30),
          _buildDropdownSection(
            'Vegetables (05)',
            const [
              {'name': 'Cauliflower', 'qty': '01 Pc'},
              {'name': 'Tomato', 'qty': '10 Pc'},
              {'name': 'Spinach', 'qty': '1/2 Kg'},
            ],
          ),
          const SizedBox(height: 20),
          _buildDropdownSection(
            'Spices (10)',
            const [
              {'name': 'Coriander', 'qty': '100 gram'},
              {'name': 'Mustard oil', 'qty': '1/2 litres'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection(String title, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Title + very small arrow immediately to its right (tight spacing)
            Text(
              title,
              style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.w700), // Bold
            ),
            const SizedBox(width: 10),
            SvgPicture.asset('assets/start_chef2/arrow-down.svg', width: 6, height: 6),
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final name = items[index]['name'] ?? '';
            final qty = items[index]['qty'] ?? '';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w400), // Regular
                ),
                Text(
                  qty,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400, // Regular
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppliancesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appliances',
            style: GoogleFonts.openSans(fontSize: 26, fontWeight: FontWeight.w700), // Bold
          ),
          const SizedBox(height: 20),
          _buildAppliancesList(),
        ],
      ),
    );
  }

  Widget _buildAppliancesList() {
    // 3 fixed items (no scroll) to match the design.
    const labels = ['Refrigerator', 'Refrigerator', 'Refrigerator'];

    return Row(
      children: List.generate(labels.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 14),
            child: _buildApplianceCard(labels[index]),
          ),
        );
      }),
    );
  }

  Widget _buildApplianceCard(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 62,
            child: Image.asset(
              'assets/start_chef2/fridge.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
