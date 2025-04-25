import 'package:flutter/material.dart';
import 'components/search_bar.dart';
import 'components/product_card.dart';
import 'components/section_header.dart';
import '../category/CategoryDetailsPage.dart';  
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: const [
            Icon(Icons.recycling, size: 30, color: Colors.white),
            SizedBox(width: 8),
            Text('Tech Mart', style: TextStyle(color: Colors.white)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SearchBarWidget(),
            const SizedBox(height: 30),
            
            // Categories section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  List<String> categories = ['Smartphones', 'Laptops', 'Accessories', 'Audio'];
                  List<IconData> icons = [Icons.smartphone, Icons.laptop, Icons.headphones, Icons.speaker];
                  return CategoryItem(icon: icons[index], title: categories[index]);
                }),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Deals section
            Container(
              color: const Color(0xFFF5F5F5),
              child: Column(
                children: [
                  const SectionHeader(title: 'Top Deals on Electronics'),
                  
                  // Product grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    children: const [
                      ProductCard(
                        rating: '4.6',
                        title: 'Apple MacBook Pro \nCore i9 9th Gen - ',
                        price: '₹2,24,900',
                        originalPrice: '₹2,39,900',
                        discount: '6% off',
                        imageUrl: 'https://via.placeholder.com/163x103',
                      ),
                      ProductCard(
                        rating: '4.6',
                        title: 'JBL T450BT Extra Bass \nBluetooth Headset',
                        price: '2,799',
                        originalPrice: '₹3,499',
                        discount: '20% off',
                        imageUrl: 'https://placehold.co/163x103',
                      ),
                      ProductCard(
                        rating: '4.6',
                        title: 'Canon EOS 90D DSLR\nCamera Body with...',
                        price: '1,13,990',
                        originalPrice: '₹1,27,495',
                        discount: '10% off',
                        imageUrl: 'https://placehold.co/163x103',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const CategoryItem({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsPage(categoryName: title),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class CategoryDetailsPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailsPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Center(
        child: Text('Details for $categoryName'),
      ),
    );
  }
}