import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_mart/models/product.dart' hide ProductSpecification;
import 'package:tech_mart/models/product_specification.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final int reviews;
  final List<String> colors;
  final ProductSpecification specifications;
  final double? discountPrice; // Giá gốc trước khuyến mãi
  final String? discountPercent; // Phần trăm giảm giá
  final bool isFreeShipping; // Miễn phí vận chuyển

  const ProductDetailPage({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.colors,
    required this.specifications,
    this.discountPrice,
    this.discountPercent,
    this.isFreeShipping = true,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;
  int _selectedColorIndex = 0;
  final List<String> _mockImages = [
    'assets/images/macbook1.jpg',
    'assets/images/macbook2.jpg',
    'assets/images/macbook3.jpg',
  ];

  final List<Map<String, String>> _offers = [
    {
      'icon': 'bank_offer',
      'title': 'Giảm thêm 500.000₫ khi thanh toán qua thẻ VIB',
      'description': '',
    },
    {
      'icon': 'rupay',
      'title': 'Giảm ngay 1.000.000₫ khi thanh toán qua ví ZaloPay',
      'description': 'cho đơn hàng từ 20.000.000₫',
    },
    {
      'icon': 'upi',
      'title': 'Trả góp 0% lãi suất với thẻ tín dụng',
      'description': 'Kỳ hạn 6-12 tháng',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Carousel
            _buildImageCarousel(),

            // Product Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge cho sản phẩm bán chạy
                  if (widget.rating >= 4.5)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "BÁN CHẠY",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),

                  // Ratings
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.star, color: Colors.white, size: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "(${widget.reviews} đánh giá)",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _formatPrice(widget.price),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.discountPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          _formatPrice(widget.discountPrice!),
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (widget.discountPercent != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              "-${widget.discountPercent}",
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ],
                  ),
                ],
              ),
            ),

            if (widget.colors.isNotEmpty) _buildColorSelection(),

            const Divider(height: 1),

            // Ưu đãi hiện có
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ưu đãi hiện có",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Offers list
                  ..._offers.map((offer) => _buildOfferItem(offer)).toList(),

                  const SizedBox(height: 4),

                  // +5 more text
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Xem thêm ưu đãi",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Delivery Options
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDeliveryOption(
                    widget.isFreeShipping ? "Miễn phí\nvận chuyển" : "Vận chuyển\ntiêu chuẩn",
                    Icons.local_shipping_outlined,
                  ),
                  _buildDeliveryOption(
                    "Trả góp 0%\n24 tháng",
                    Icons.calendar_month_outlined,
                  ),
                  _buildDeliveryOption(
                    "Thu cũ\nđổi mới",
                    Icons.swap_horiz,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Share and Compare
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text("Chia sẻ"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      shape: const RoundedRectangleBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.compare_arrows, size: 18),
                    label: const Text("So sánh"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      shape: const RoundedRectangleBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 1),

            // Delivery Location
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Giao đến: Quận 1, TP. Hồ Chí Minh",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text("Thay đổi"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Delivery by date
                  Row(
                    children: [
                      Text(
                        "Giao hàng",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "25/04/2025",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "|",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Miễn phí",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        " 40.000₫",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Specifications
            _buildSpecificationsSection(),

            const Divider(height: 1),

            // View Details button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Xem chi tiết",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildColorSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Màu sắc",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                widget.colors.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedColorIndex == index
                            ? Colors.blue.shade700
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedColorIndex == index
                          ? Colors.blue.shade50
                          : Colors.white,
                    ),
                    child: Text(
                      widget.colors[index],
                      style: TextStyle(
                        color: _selectedColorIndex == index
                            ? Colors.blue.shade700
                            : Colors.black,
                        fontWeight: _selectedColorIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection() {
    Map<String, String> specificationsMap = widget.specifications.toMap();
    if (specificationsMap.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Thông số kỹ thuật",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          ...specificationsMap.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "${entry.key}:",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        // Image slider
        Container(
          height: 300,
          width: double.infinity,
          color: Colors.white,
          child: PageView.builder(
            itemCount: _mockImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: Image.asset(
                  _mockImages[index],
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      'https://live.staticflickr.com/5711/22581254829_d5a4f6b19a_b.jpg',
                      fit: BoxFit.contain,
                    );
                  },
                ),
              );
            },
          ),
        ),

        // Favorite button
        Positioned(
          top: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey.shade800,
                ),
              ),
            ),
          ),
        ),

        // Page indicator dots
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _mockImages.length,
              (index) => Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Colors.black
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferItem(Map<String, String> offer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.local_offer,
            size: 18,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: "${offer['title']} ",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (offer['description']!.isNotEmpty)
                    TextSpan(
                      text: offer['description'],
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption(String text, IconData icon) {
    return Container(
      width: 100,
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.grey.shade800,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            color: Colors.grey.shade300,
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'THÊM VÀO GIỎ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade800,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'MUA NGAY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(price);
  }
}