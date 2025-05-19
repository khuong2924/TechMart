import 'package:flutter/material.dart';
import 'package:tech_mart/models/product.dart' hide ProductSpecification;
import 'package:tech_mart/models/product_specification.dart';
import 'package:tech_mart/models/category.dart';
import 'package:tech_mart/presentation/cart/CartPage.dart';
import 'package:tech_mart/data/repositories/category_repository.dart';
import 'package:tech_mart/core/network/api_client.dart';
import 'package:provider/provider.dart';
import 'package:tech_mart/presentation/profile/ProfilePage.dart';

import 'components/search_bar.dart';
import 'components/product_card.dart';
import 'components/section_header.dart';
import 'components/flash_sale_item.dart';
import 'components/brand_item.dart';
import 'components/promotion_card.dart';
import 'components/category_item.dart'; 
import 'package:tech_mart/presentation/category/CategoryDetailsPage.dart';
import 'package:tech_mart/presentation/product/ProductDetailPage.dart' ;

import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryRepository _categoryRepository = CategoryRepository(ApiClient());
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _categoryRepository.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
    }
  }

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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;
    final isLargeScreen = size.width >= 1200;

    // Tạo dữ liệu sản phẩm cho trang chủ sử dụng model Product
    final List<Product> featuredProducts = [
      Product(
        id: 1,
        name: 'MacBook Pro M3',
        description: 'MacBook Pro với chip M3 mạnh mẽ',
        price: 49990000,
        stockQuantity: 10,
        imageUrl: 'https://yabloki.ua/media/cache/sylius_shop_product_original/8a/86/noutbuk-macbook-pro-16-apple-m3-pro-36gb-12cpu-18gpu-512gb-ssd-silver-2023_966aa556-8719-4948-b745-7a0b0968d5f0-2.png.webp',
        active: true,
        discountPercentage: 5,
        averageRating: 4.9,
        reviewCount: 167,
        category: {'id': 1, 'name': 'Laptop'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 2,
        name: 'JBL T450BT Extra Bass',
        description: 'Tai nghe không dây với âm bass mạnh mẽ',
        price: 890000,
        stockQuantity: 20,
        imageUrl: 'https://vn.jbl.com/on/demandware.static/-/Sites-masterCatalog_Harman/default/dw3b9796ab/450BT_black_angle_01-1606x1606px.png',
        active: true,
        discountPercentage: 30,
        averageRating: 4.6,
        reviewCount: 856,
        category: {'id': 2, 'name': 'Tai nghe'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 3,
        name: 'Iphone 12 Mini',
        description: 'Iphone nhỏ gọn đời mới dung lượng cao',
        price: 25990000,
        stockQuantity: 15,
        imageUrl: 'https://didongmango.com/images/products/2022/11/04/resized/anh-chup-man-hinh-2022-09-08-luc-01-57-13-removebg-preview_1666200054png_1667546697.png',
        active: true,
        discountPercentage: 10,
        averageRating: 4.7,
        reviewCount: 253,
        category: {'id': 3, 'name': 'Máy ảnh'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 4,
        name: 'Samsung Galaxy Watch 6',
        description: 'Đồng hồ thông minh cao cấp',
        price: 6490000,
        stockQuantity: 25,
        imageUrl: 'https://samplaza.vn/filemanager/userfiles/2023/07/sm-r930-001-front-graphite-1.png',
        active: true,
        discountPercentage: 20,
        averageRating: 4.5,
        reviewCount: 389,
        category: {'id': 4, 'name': 'Đồng hồ'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final List<Product> flashSaleProducts = [
      Product(
        id: 5,
        name: 'Samsung Galaxy S24',
        description: 'Điện thoại thông minh mới nhất từ Samsung',
        price: 22490000,
        stockQuantity: 15,
        imageUrl: 'https://bizweb.dktcdn.net/thumb/1024x1024/100/116/615/products/a-nh-chu-p-ma-n-hi-nh-2024-10-07-lu-c-02-11-55.png',
        active: true,
        discountPercentage: 15,
        averageRating: 4.7,
        reviewCount: 120,
        category: {'id': 1, 'name': 'Điện thoại'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 6,
        name: 'iPhone 15',
        description: 'iPhone 15 mới nhất từ Apple',
        price: 19990000,
        stockQuantity: 20,
        imageUrl: 'https://cdn.xtmobile.vn/vnt_upload/product/09_2023/thumbs/(600x600)_crop_15p-tita.jpg',
        active: true,
        discountPercentage: 15,
        averageRating: 4.8,
        reviewCount: 85,
        category: {'id': 1, 'name': 'Điện thoại'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 7,
        name: 'Xiaomi 14',
        description: 'Điện thoại thông minh cao cấp từ Xiaomi',
        price: 16990000,
        stockQuantity: 18,
        imageUrl: 'https://clickbuy.com.vn/uploads/pro/xiaomi-14-5g-chinh-hang-5357-xkzf-1024x1024-197639.jpg',
        active: true,
        discountPercentage: 15,
        averageRating: 4.6,
        reviewCount: 65,
        category: {'id': 1, 'name': 'Điện thoại'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 8,
        name: 'OPPO Find X7',
        description: 'Điện thoại thông minh cao cấp từ OPPO',
        price: 18490000,
        stockQuantity: 12,
        imageUrl: 'https://clickbuy.com.vn/uploads/pro/xiaomi-14-5g-chinh-hang-5357-xkzf-1024x1024-197639.jpg',
        active: true,
        discountPercentage: 15,
        averageRating: 4.5,
        reviewCount: 50,
        category: {'id': 1, 'name': 'Điện thoại'},
        variants: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(
              Icons.recycling,
              size: isSmallScreen ? 24 : 30,
              color: Colors.white,
            ),
            SizedBox(width: isSmallScreen ? 6 : 8),
            Text(
              'Tech Mart',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 18 : 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: isSmallScreen ? 16 : 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : (isMediumScreen ? 24 : 48)),
                  child: const CustomSearchBar(
                    hintText: 'Tìm kiếm sản phẩm...',
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),
                // Banner khuyến mãi 
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWebWide = constraints.maxWidth > 900;
                    final banner = ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://cdnv2.tgdd.vn/mwg-static/common/News/1573973/Thumb.jpg',
                        height: isSmallScreen ? 120 : (isWebWide ? 260 : 150),
                        width: isWebWide ? constraints.maxWidth : double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: isSmallScreen ? 120 : (isWebWide ? 260 : 150),
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
                        ),
                      ),
                    );
                    if (isWebWide) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: banner,
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : (isMediumScreen ? 24 : 48)),
                        child: banner,
                      );
                    }
                  },
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),
                // Categories section 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : (isMediumScreen ? 24 : 48)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Danh mục sản phẩm',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : (isMediumScreen ? 16 : 18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Wrap(
                              spacing: isSmallScreen ? 8 : 12,
                              runSpacing: isSmallScreen ? 8 : 12,
                              children: _categories.map((category) {
                                return GestureDetector(
                                  onTap: () => _onCategoryTap(context, category.name),
                                  child: CategoryItem(
                                    icon: _getCategoryIcon(category.name),
                                    title: category.name,
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),
                // Flash sale section 
                Container(
                  padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                  color: Colors.red.shade900.withOpacity(0.08),
                  child: Column(
                    children: [
                      SectionHeader(
                        title: 'FLASH SALE',
                        showViewAll: true,
                        titleColor: Colors.black,
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                        child: Row(
                          children: flashSaleProducts.map((product) {
                            return Padding(
                              padding: EdgeInsets.only(right: isSmallScreen ? 8 : 12),
                              child: FlashSaleItem(
                                product: product,
                                soldPercent: product.reviews.toDouble(),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),
                // Deals section 
                Container(
                  color: const Color(0xFFF5F5F5),
                  padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 24 : (isSmallScreen ? 12 : 16)),
                  child: Column(
                    children: [
                      SectionHeader(
                        title: 'Sản phẩm nổi bật',
                        showViewAll: true,
                        titleColor: Colors.black,
                        fontSize: isLargeScreen ? 28 : (isMediumScreen ? 22 : 18),
                        icon: Icons.star,
                      ),
                      // Product grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isLargeScreen ? 5 : (isMediumScreen ? 3 : 2),
                        childAspectRatio: isLargeScreen ? 0.8 : (isSmallScreen ? 0.65 : 0.68),
                        padding: EdgeInsets.symmetric(
                          horizontal: isLargeScreen ? 32 : (isMediumScreen ? 24 : 8),
                          vertical: isLargeScreen ? 24 : (isSmallScreen ? 8 : 12),
                        ),
                        mainAxisSpacing: isLargeScreen ? 24 : (isSmallScreen ? 8 : 12),
                        crossAxisSpacing: isLargeScreen ? 24 : (isSmallScreen ? 8 : 12),
                        children: featuredProducts.map((product) {
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ProductCard(
                                product: product,
                                showFavoriteButton: true,
                                showPromotionTags: true,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isLargeScreen ? 32 : (isSmallScreen ? 20 : 24)),
                // Brands section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 48 : (isMediumScreen ? 24 : 12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thương hiệu nổi bật',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 24 : (isMediumScreen ? 18 : 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.1,
                        ),
                      ),
                      SizedBox(height: isLargeScreen ? 18 : (isSmallScreen ? 12 : 16)),
                      Wrap(
                        spacing: isLargeScreen ? 18 : (isSmallScreen ? 8 : 12),
                        runSpacing: isLargeScreen ? 18 : (isSmallScreen ? 8 : 12),
                        alignment: WrapAlignment.spaceEvenly,
                        children: const [
                          BrandItem(name: 'Apple', icon: Icons.apple, iconSize: 38),
                          BrandItem(name: 'Samsung', icon: Icons.phone_android, iconSize: 38),
                          BrandItem(name: 'Xiaomi', icon: Icons.devices, iconSize: 38),
                          BrandItem(name: 'Dell', icon: Icons.laptop_mac, iconSize: 38),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isLargeScreen ? 32 : (isSmallScreen ? 20 : 24)),
                // Promotion cards 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 48 : (isMediumScreen ? 24 : 12)),
                  child: Card(
                    color: const Color(0xFF23272F),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF23272F), Color(0xFF2C3140)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isLargeScreen ? 32 : (isSmallScreen ? 16 : 20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: Colors.amber,
                                  size: isLargeScreen ? 28 : (isSmallScreen ? 18 : 22),
                                ),
                                Icon(
                                  Icons.local_offer,
                                  color: Colors.blue,
                                  size: isLargeScreen ? 28 : (isSmallScreen ? 18 : 22),
                                ),
                                SizedBox(width: isLargeScreen ? 12 : (isSmallScreen ? 6 : 8)),
                                Text(
                                  'Ưu đãi đặc biệt',
                                  style: TextStyle(
                                    fontSize: isLargeScreen ? 22 : (isSmallScreen ? 14 : 18),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isLargeScreen ? 24 : (isSmallScreen ? 12 : 16)),
                            SizedBox(
                              height: isLargeScreen ? 180 : (isSmallScreen ? 140 : 160),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  PromotionCard(
                                    title: 'Trả góp 0%',
                                    subtitle: 'Duyệt nhanh',
                                    bgColor: Colors.purple.shade100,
                                    textColor: Colors.purple,
                                    icon: Icons.credit_card,
                                  ),
                                  SizedBox(width: isLargeScreen ? 24 : (isSmallScreen ? 12 : 16)),
                                  PromotionCard(
                                    title: 'Voucher 500K',
                                    subtitle: 'Cho đơn từ 5 triệu',
                                    bgColor: Colors.orange.shade100,
                                    textColor: Colors.orange,
                                    icon: Icons.card_giftcard,
                                  ),
                                  SizedBox(width: isLargeScreen ? 24 : (isSmallScreen ? 12 : 16)),
                                  PromotionCard(
                                    title: 'Freeship',
                                    subtitle: 'Toàn quốc',
                                    bgColor: Colors.blue.shade100,
                                    textColor: Colors.blue,
                                    icon: Icons.local_shipping,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isLargeScreen ? 40 : (isSmallScreen ? 24 : 30)),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'điện thoại':
        return Icons.smartphone;
      case 'laptop':
        return Icons.laptop;
      case 'tai nghe':
        return Icons.headphones;
      case 'đồng hồ':
        return Icons.watch;
      default:
        return Icons.category;
    }
  }
}