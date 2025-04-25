import 'package:flutter/material.dart';
import 'components/filter_options_bar.dart';
import 'components/product_list_item.dart';
import 'components/filter_chip_section.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String categoryName;

  const CategoryDetailsPage({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  int filterCount = 3;
  Map<String, bool> favorites = {};

  void toggleFavorite(String productId) {
    setState(() {
      favorites[productId] = !(favorites[productId] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter options bar
          FilterOptionsBar(
            filterCount: filterCount,
            onComparePressed: () {},
            onSortPressed: () {},
            onFilterPressed: () {},
          ),
          
          // Product list
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Product 1
                ProductListItem(
                  categoryName: widget.categoryName,
                  title: 'Acer Aspire 5 Core i5 10th Gen - (8 GB/512 GB SSD/Windows 10 Home)',
                  rating: '4.4',
                  ratingCount: '(130)',
                  price: '₹53,990',
                  originalPrice: '₹69,949',
                  discount: '10% off',
                  specs: [
                    '35.56 cm (14 inch) Full HD Display',
                    '1.50 kg',
                    'No Optical Disk Drive',
                  ],
                  isFavorite: favorites['acer5'] ?? false,
                  onFavoriteToggle: () => toggleFavorite('acer5'),
                ),

                // Product 2
                ProductListItem(
                  categoryName: widget.categoryName,
                  title: 'Acer Aspire 7 Core i5 9th Gen - (8 GB/512 GB SSD/Windows 10 Home)',
                  rating: '4.5',
                  ratingCount: '(3,959)',
                  price: '₹58,990',
                  originalPrice: '₹79,949',
                  discount: '26% off',
                  specs: [
                    'NVIDIA Geforce GTX 1650 4 GB Gfx',
                    'No Optical Disk Drive',
                    '39.62 cm (15.6 inch) Full HD Display',
                  ],
                  isFavorite: favorites['acer7'] ?? true,
                  onFavoriteToggle: () => toggleFavorite('acer7'),
                ),

                // Product 3
                ProductListItem(
                  categoryName: widget.categoryName,
                  title: 'Dell Vostro Core i5 10th Gen - (8 GB/1 TB HDD/256 GB SSD/Windows 10)',
                  rating: '4.3',
                  ratingCount: '(577)',
                  price: '₹53,490',
                  originalPrice: '₹53,859',
                  specs: [
                    '35.56 cm (14 inch) Full HD Display',
                    '1.66 kg',
                    'Microsoft Office',
                    'No Optical Disk Drive',
                  ],
                  isFavorite: favorites['dell'] ?? true,
                  onFavoriteToggle: () => toggleFavorite('dell'),
                ),

                // Filter section
                FilterChipSection(
                  title: 'Select Processor',
                  options: [
                    'Intel Core i3',
                    'Intel Core i5',
                    'Intel Pentium Series',
                    'Intel Core i7',
                    'AMD A Series',
                  ],
                  onOptionSelected: (option) {
                    // Handle filter selection
                  },
                ),

                // Product 4
                ProductListItem(
                  categoryName: widget.categoryName,
                  title: 'Apple MacBook Pro Core i7 9th 11, Gen - (16 GB/512 GB SSD/Mac OS)',
                  rating: '4.7',
                  ratingCount: '(90)',
                  price: '₹1,99,900',
                  specs: [
                    'AMD Radeon Pro 5300M 4 GB Gfx',
                    '40.64 cm (16 inch) Quad HD Display',
                    'No Optical Disk Drive',
                  ],
                  isFavorite: favorites['apple'] ?? true,
                  onFavoriteToggle: () => toggleFavorite('apple'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}