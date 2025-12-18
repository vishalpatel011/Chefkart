import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dish_model.dart';
import '../services/api_service.dart';
import 'dish_detail_screen.dart';

class SelectDishesScreen extends StatefulWidget {
  const SelectDishesScreen({super.key});

  @override
  State<SelectDishesScreen> createState() => _SelectDishesScreenState();
}

class _SelectDishesScreenState extends State<SelectDishesScreen> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _dishesFuture;
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dishesFuture = _apiService.fetchDishesData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset('assets/start_chef2/arrow-left.svg', width: 16, height: 16,),
          onPressed: () {},
        ),
        title: const Text(
          'Select Dishes',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dishesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final popularDishes =
          snapshot.data!['popularDishes'] as List<PopularDish>;
          final dishes = snapshot.data!['dishes'] as List<Dish>;
          // Ensure popular dishes are mapped to full Dish objects so every row
          // uses the same layout (shows equipment icons, description, rating etc.)
          final allDishes = <Dish>[
            ...dishes,
            ...popularDishes.map((d) => Dish(
              id: d.id,
              name: d.name,
              image: d.image,
              rating: 4.2, // default rating to match UI badge on the first item
              description: 'Chicken fried in deep tomato sauce with delicious spices',
              // provide two equipments so icons show consistently like the first row
              equipments: ['Refrigerator', 'Refrigerator'],
            ))
          ];

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(),
                  const SizedBox(height: 6),
                  _buildPopularDishes(popularDishes),
                  const Divider(
                    thickness: 5,
                    height: 0,
                    color: Color(0xFFF7F7F7),
                  ),
                  // The Recommended header is now included inside the scrollable dish list
                  Expanded(child: _buildDishList(allDishes)),
                ],
              ),
              _buildBottomFloatingBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 190, // increased to match reference overlap with black bar
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60, // larger black bar to match reference UI
              color: Colors.black,
            ),
            Positioned(
              top: 30, // shift down so the white card overlaps more like the reference
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.12),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            // show original multicolor calendar icon at consistent size
                            SvgPicture.asset(
                              'assets/start_chef2/calendar.svg',
                              height: 23,
                              width: 23,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('dd MMM yyyy').format(_selectedDate),
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 38,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        Row(
                          children: [
                            // show original multicolor clock icon at same size
                            SvgPicture.asset(
                              'assets/start_chef2/clock.svg',
                              height: 23,
                              width: 23,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '10:30 Pm-12:30 Pm',
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildCategoryFilter(padding: const EdgeInsets.symmetric(horizontal: 0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter({EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20)}) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Chip(
            label: Text(
              ['Italian', 'Indian', 'Indian', 'Indian'][index],
              style: GoogleFonts.openSans(
                color: isSelected ? const Color(0xFFFF8A00) : Colors.grey,
                fontWeight: FontWeight.w400, // Regular
              ),
            ),
            backgroundColor: isSelected ? const Color(0xFFFFF9F2) : Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? const Color(0xFFFF8A00) : Colors.grey[300]!,
              ),
            ),
            elevation: 0,
          );
        },
      ),
    );
  }

  Widget _buildPopularDishes(List<PopularDish> dishes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Popular Dishes header (Open Sans, Bold)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Text(
            'Popular Dishes',
            style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: dishes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final dish = dishes[index];
              return SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFF8A00), width: 2),
                      ),
                      child: ClipOval(
                        // Add a dark translucent mask and name overlay inside the circular image
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                'assets/start_chef2/img_1.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // translucent black overlay to make text readable
                            Positioned.fill(
                              child: Container(
                                color: const Color.fromRGBO(0, 0, 0, 0.35),
                              ),
                            ),
                            // dish name centered inside the circle
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  dish.name,
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600, // SemiBold
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Recommended',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6), // 👈 move arrow to the right
              SvgPicture.asset(
                'assets/start_chef2/arrow-down.svg',
                width: 6,
                height: 6,
              ),
            ],
          ),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text('Menu', style: GoogleFonts.openSans(fontWeight: FontWeight.bold, color: Colors.white)),
          ),

        ],
      ),
    );
  }

  Widget _buildDishList(List<Dish> dishes) {
    // Make the Recommended header the first scrollable item so it scrolls with the list
    final totalCount = dishes.length + 1; // +1 for header
    return ListView.separated(
      itemCount: totalCount,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      // Draw a thin divider between dishes (skip between header and first dish)
      separatorBuilder: (context, index) {
        if (index == 0) return const SizedBox.shrink();
        // Add small vertical spacing above and below the divider so it doesn't
        // sit flush against the dish content.
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: Color(0xFFF7F7F7), height: 1, thickness: 1),
        );
      },
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildRecommendedHeader();
        }

        final dish = dishes[index - 1];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DishDetailScreen(dishId: dish.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            dish.name,
                            style: const TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600, // SemiBold
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset('assets/start_chef2/veg.svg',height: 13,width: 13),
                          const SizedBox(width: 11),
                          if (dish.rating > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2ECC71),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${dish.rating}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Equipment icons followed by a vertical label block (Ingredients / View list)
                      // Center icons vertically so they align with the 30px divider
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (dish.equipments.isNotEmpty)
                            // increase spacing between icons for clearer separation
                            _buildEquipmentIcon(dish.equipments, size: 20, spacing: 20),
                          if (dish.equipments.isNotEmpty)
                            Container(
                              height: 30,
                              width: 1,
                              color: Colors.grey,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingredients',
                                style: GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'View list >',
                                style: GoogleFonts.openSans(fontSize: 12, color: Color(0xFFFF8A00)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (dish.description.isNotEmpty)
                        Text(
                          dish.description,
                          style: const TextStyle(
                            fontFamily: 'Open Sans',
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/start_chef2/img.png',
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: -15,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            width: 75, // fixed compact width to match reference
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: const BorderSide(color: Colors.orange),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                elevation: 2,
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Center(child: Text('Add', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                                  Positioned(
                                    top: -4,
                                    right: -4,
                                    child: const Icon(
                                      Icons.add,
                                      size: 11, // reduced size to make the '+' smaller
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEquipmentIcon(List<String> equipments, {double size = 22, double spacing = 8}) {
    // Mock icons for equipments
    // In real app, map string to icon
    return Row(
      children: equipments
          .take(2)
          .map(
            (e) => Padding(
          // use spacing parameter to control horizontal gap between icons
          padding: EdgeInsets.only(right: spacing),
          child: SvgPicture.asset(
             e == 'Refrigerator'
                 ? 'assets/start_chef2/refrigerator.svg'
                 : e == 'Microwave'
                 ? 'assets/start_chef2/refrigerator.svg'
                 : 'assets/start_chef2/help.svg', // A default icon
             width: size,
             height: size,
           ),
         ),
       )
          .toList(),
    );
  }

  Widget _buildBottomFloatingBar() {
    // "3 food items selected ->"
    return Positioned(
      bottom: 30,
      left: 40,
      right: 40,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/start_chef2/fastfood.svg'),
                const SizedBox(width: 10),
                Text(
                  '3 food items selected',
                  style: GoogleFonts.openSans(fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
            SvgPicture.asset('assets/start_chef2/arrow-right.svg'),
          ],
        ),
      ),
    );
  }
}
