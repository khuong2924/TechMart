import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart';
import 'components/search_bar.dart';
import 'components/product_card.dart';
import 'components/section_header.dart';
import 'components/flash_sale_item.dart';
import 'components/promo_banner.dart';
import 'components/brand_item.dart';
import 'components/promotion_card.dart';
import 'components/category_item.dart'; 
import 'package:tech_mart/presentation/category/CategoryDetailsPage.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _onCategoryTap(BuildContext context, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsPage(
          categoryName: categoryName,
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Tạo dữ liệu sản phẩm cho trang chủ sử dụng model Product
    final List<Product> featuredProducts = [
      Product(
        id: 'macbook-pro',
        name: 'MacBook Pro M3',
        image: 'assets/images/macbook16.jpg',
        price: 49990000,
        originalPrice: 52990000,
        rating: 4.9,
        reviews: 167,
        colors: ['Xám không gian', 'Bạc'],
        specifications: {
          "Bộ xử lý": "Apple M3 Pro",
          "RAM": "16 GB",
          "Ổ cứng": "512 GB SSD",
          "Màn hình": "14.2 inch, Liquid Retina XDR",
          "Đồ họa": "Apple M3 Pro 14-core GPU",
          "Hệ điều hành": "macOS Sonoma"
        },
      ),
      Product(
        id: 'jbl-headset',
        name: 'JBL T450BT Extra Bass',
        image: 'assets/images/jbl.jpg',
        price: 890000,
        originalPrice: 1290000,
        rating: 4.6,
        reviews: 856,
        colors: ['Đen', 'Trắng', 'Xanh'],
        specifications: {
          "Loại": "On-ear",
          "Kết nối": "Bluetooth 4.0",
          "Thời lượng pin": "11 giờ",
          "Phạm vi kết nối": "10m",
          "Trọng lượng": "150g"
        },
      ),
      Product(
        id: 'canon-90d',
        name: 'Canon EOS 90D DSLR',
        image: 'assets/images/canon90d.jpg',
        price: 25990000,
        originalPrice: 28990000,
        rating: 4.7,
        reviews: 253,
        colors: ['Đen'],
        specifications: {
          "Cảm biến": "APS-C CMOS 32.5MP",
          "Bộ xử lý": "DIGIC 8",
          "Quay video": "4K 30p",
          "Màn hình": "3.0\" LCD cảm ứng",
          "Trọng lượng": "701g"
        },
      ),
      Product(
        id: 'galaxy-watch6',
        name: 'Samsung Galaxy Watch 6',
        image: 'assets/images/galaxywatch6.jpg',
        price: 6490000,
        originalPrice: 7990000,
        rating: 4.5,
        reviews: 389,
        colors: ['Đen', 'Bạc', 'Vàng hồng'],
        specifications: {
          "Kích thước": "44mm",
          "Màn hình": "Super AMOLED",
          "Chip": "Exynos W930",
          "RAM": "2 GB",
          "Bộ nhớ": "16 GB",
          "Pin": "425 mAh (40 giờ)"
        },
      ),
    ];

    final List<Product> flashSaleProducts = [
      Product(
        id: 's24-ultra',
        name: 'Samsung Galaxy S24',
        image: 'assets/images/s24.jpg',
        price: 22490000,
        originalPrice: 25990000,
        rating: 4.7,
        reviews: 120,
        colors: ['Đen', 'Bạc', 'Xanh'],
        specifications: {
          "Màn hình": "6.1 inch, Super Retina XDR",
          "Chip": "Apple A16 Bionic",
          "RAM": "6 GB",
          "Bộ nhớ trong": "128 GB",
          "Camera sau": "48MP + 12MP",
          "Camera trước": "12MP"
        },
      ),
      Product(
        id: 'iphone15',
        name: 'iPhone 15',
        image: 'assets/images/iphone15.jpg',
        price: 19990000,
        originalPrice: 22990000,
        rating: 4.8,
        reviews: 85,
        colors: ['Đen', 'Trắng', 'Xanh'],
        specifications: {
          "Màn hình": "6.1 inch, Super Retina XDR",
          "Chip": "Apple A16 Bionic",
          "RAM": "6 GB",
          "Bộ nhớ trong": "128 GB",
          "Camera sau": "48MP + 12MP",
          "Camera trước": "12MP"
        },
      ),
      Product(
        id: 'xiaomi14',
        name: 'Xiaomi 14',
        image: 'assets/images/xiaomi14.jpg',
        price: 16990000,
        originalPrice: 19990000,
        rating: 4.6,
        reviews: 65,
        colors: ['Đen', 'Bạc', 'Xanh'],
        specifications: {
          "Màn hình": "6.1 inch, Super Retina XDR",
          "Chip": "Apple A16 Bionic",
          "RAM": "6 GB",
          "Bộ nhớ trong": "128 GB",
          "Camera sau": "48MP + 12MP",
          "Camera trước": "12MP"
        },
      ),
      Product(
        id: 'findx7',
        name: 'OPPO Find X7',
        image: 'assets/images/findx7.jpg',
        price: 18490000,
        originalPrice: 21990000,
        rating: 4.5,
        reviews: 50,
        colors: ['Đen', 'Bạc', 'Xanh'],
        specifications: {
          "Màn hình": "6.1 inch, Super Retina XDR",
          "Chip": "Apple A16 Bionic",
          "RAM": "6 GB",
          "Bộ nhớ trong": "128 GB",
          "Camera sau": "48MP + 12MP",
          "Camera trước": "12MP"
        },
      ),
    ];

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
          
            const CustomSearchBar(
              hintText: 'Tìm kiếm sản phẩm...',
            ),
            
            const SizedBox(height: 30),
            
            // Banner khuyến mãi 
            const PromoBanner(
              title: 'TUẦN LỄ VÀNG',
              subtitle: 'Giảm đến 50%',
              buttonText: 'Mua ngay',
              imagePath: 'assets/images/smartphone_banner.png',
            ),
            
            const SizedBox(height: 30),
            
            // Categories section 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Danh mục sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      List<String> categories = ['Điện thoại', 'Laptop', 'Tai nghe', 'Đồng hồ'];
                      List<IconData> icons = [Icons.smartphone, Icons.laptop, Icons.headphones, Icons.watch];
                      return GestureDetector(
                        onTap: () => _onCategoryTap(context, categories[index]),
                        child: CategoryItem(icon: icons[index], title: categories[index]),
                      );
                    }),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Flash sale section 
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.red.shade50,
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'FLASH SALE',
                    showViewAll: true,
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: flashSaleProducts.map((product) {
                        return FlashSaleItem(
                          product: product, // convert Product trực tiếp
                          soldPercent: product.reviews.toDouble(), // Giữ nguyên soldPercent
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Deals section 
            Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const SectionHeader(
                    title: 'Sản phẩm nổi bật',
                    showViewAll: true,
                  ),
                  
                  // Product grid - Việt hóa - sử dụng components
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: featuredProducts.map((product) {
                      return ProductCard(
                        product: product, // convert Product trực tiếp
                        showFavoriteButton: true, 
                        showPromotionTags: true,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
           
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thương hiệu nổi bật',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      BrandItem(name: 'Apple', icon: Icons.apple),
                      BrandItem(name: 'Samsung', icon: Icons.phone_android),
                      BrandItem(name: 'Xiaomi', icon: Icons.devices),
                      BrandItem(name: 'Dell', icon: Icons.laptop_mac),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Promotion cards 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ưu đãi đặc biệt',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: PromotionCard(
                          title: 'Trả góp 0%',
                          subtitle: 'Dành cho đơn trên 3 triệu',
                          bgColor: Colors.purple.shade100,
                          textColor: Colors.purple,
                          icon: Icons.credit_card,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PromotionCard(
                          title: 'Voucher 500K',
                          subtitle: 'Cho đơn từ 10 triệu',
                          bgColor: Colors.orange.shade100,
                          textColor: Colors.orange,
                          icon: Icons.card_giftcard,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}