import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/dish_model.dart';
import '../services/api_service.dart';

class DishDetailScreen extends StatefulWidget {
  final int dishId;

  const DishDetailScreen({super.key, required this.dishId});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<DishDetail> _dishDetailFuture;

  @override
  void initState() {
    super.initState();
    _dishDetailFuture = _apiService.fetchDishDetail(widget.dishId);
  }

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
      body: FutureBuilder<DishDetail>(
        future: _dishDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final dish = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(dish),
                const Divider(
                  thickness: 8,
                  height: 42,
                  color: Color(0xFFF7F7F7),
                ),
                _buildIngredientsSection(dish),
                const SizedBox(height: 20),
                _buildAppliancesSection(dish.appliances),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(DishDetail dish) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -100,
            top: -50,
            child: Opacity(
              opacity: 1,
              child: CachedNetworkImage(
                imageUrl: dish.image,
                height: 300,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) => Image.network(
                  'https://ik.imagekit.io/utod9iykp/ChefKart/1bb54e93-7888-4079-bf29-8e281670c9d2.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dish.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.star, size: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(
                  width: 230,
                  child: Text(
                    'Mughlai Masala is a style of cookery developed in the Indian Subcontinent by the imperial kitchens of the Mughal Empire.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      dish.timeToPrepare,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(DishDetail dish) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'For 2 people',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Divider(height: 30),
          _buildDropdownSection(
            'Vegetables (${dish.vegetables.length})',
            dish.vegetables,
          ),
          const SizedBox(height: 20),
          _buildDropdownSection(
            'Spices (${dish.spices.length})',
            dish.spices,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSection(String title, List<IngredientItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = items[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 16)),
                Text(item.quantity, style: const TextStyle(fontSize: 16)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppliancesSection(List<ApplianceItem> appliances) {
    // Override with static appliances for demo
    final staticAppliances = [
      ApplianceItem(
        name: 'Refrigerator',
        image: 'https://img.freepik.com/free-psd/sleek-stainless-steel-french-door-refrigerator_632498-25861.jpg',
      ),
      ApplianceItem(
        name: 'Microwave',
        image: 'https://img.freepik.com/free-vector/microwave-oven-with-light-inside-isolated-white-background-kitchen-appliances_134830-658.jpg?semt=ais_se_enriched&w=740&q=80',
      ),
      ApplianceItem(
        name: 'Stove',
        image: 'https://img.freepik.com/free-vector/realistic-vector-icon-illustration-modern-oven-multi-function-gas-stove-with-blue-fire-burner_134830-2432.jpg?semt=ais_hybrid&w=740&q=80',
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appliances',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildAppliancesList(staticAppliances),
        ],
      ),
    );
  }

  Widget _buildAppliancesList(List<ApplianceItem> appliances) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: appliances.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final app = appliances[index];
          return Container(
            width: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.2 * 255).toInt()),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: app.image.isNotEmpty
                      ? app.image
                      : 'https://ik.imagekit.io/utod9iykp/ChefKart/641f267633517556f8f533a3_image.png',
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const Icon(Icons.kitchen, size: 40, color: Colors.grey),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  app.name,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
