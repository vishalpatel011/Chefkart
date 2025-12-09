import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
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
          final allDishes = <Dish>[
            ...dishes,
            ...popularDishes.map((d) => Dish(
                  id: d.id,
                  name: d.name,
                  image: d.image,
                  rating: 0, // Popular dishes don't have a rating in the API
                  description: '', // Or a default description
                  equipments: [], // No equipment for popular dishes in this context
                ))
          ];

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSelector(),
                  const SizedBox(height: 20),
                  _buildPopularDishes(popularDishes),
                  const Divider(
                    thickness: 8,
                    height: 32,
                    color: Color(0xFFF7F7F7),
                  ),
                  _buildRecommendedHeader(),
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
        height: 170, // reduced height to remove extra white space
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 70, //Black Bar
              color: Colors.black,
            ),
            Positioned(
              top: 45, // slightly pulled up so the layout matches reference image
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
                          color: Color.fromRGBO(0, 0, 0, 0.12),
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
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(_selectedDate),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '10:30 Pm-12:30 Pm',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18), // small spacing between card and chips
                  _buildCategoryFilter(padding: const EdgeInsets.symmetric(horizontal: 20)),
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
              style: TextStyle(
                color: isSelected ? Colors.orange : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? Colors.orange : Colors.grey[300]!,
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
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 0), // reduced top spacing to align under chips
          child: Text(
            'Popular Dishes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
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
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: dish.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[200]),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dish.name,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Recommended',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Menu', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDishList(List<Dish> dishes) {
    return ListView.separated(
      itemCount: dishes.length,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
      separatorBuilder: (context, index) =>
          const Divider(color: Color(0xFFF7F7F7), thickness: 1),
      itemBuilder: (context, index) {
        final dish = dishes[index];
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(4),
                            ), // Veg icon mock
                            child: const Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (dish.rating > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (dish.equipments.isNotEmpty)
                            _buildEquipmentIcon(dish.equipments),
                          if (dish.equipments.isNotEmpty)
                            Container(
                              height: 15,
                              width: 1,
                              color: Colors.grey,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                          const Text(
                            'Ingredients',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ' View list >',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (dish.description.isNotEmpty)
                        Text(
                          dish.description,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
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
                        child: CachedNetworkImage(
                          imageUrl: dish.image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: Colors.grey[200]),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                                  borderRadius: BorderRadius.circular(8),
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

  Widget _buildEquipmentIcon(List<String> equipments) {
    // Mock icons for equipments
    // In real app, map string to icon
    return Row(
      children: equipments
          .take(2)
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                e == 'Refrigerator'
                    ? Icons.kitchen
                    : e == 'Microwave'
                        ? Icons.microwave
                        : Icons.help,
                size: 15,
                color: Colors.grey,
              ), // Placeholder icon
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.fastfood, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  '3 food items selected',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
