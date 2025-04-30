import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_mart/models/product.dart' hide ProductSpecification;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Danh sách sản phẩm trong giỏ hàng (mẫu)
  final List<CartItem> _cartItems = [
    CartItem(
      product: Product(
        id: 'iphone15',
        name: 'iPhone 15',
        image: 'assets/images/iphone15.jpg',
        price: 19990000,
        originalPrice: 22990000,
        rating: 4.8,
        reviews: 85,
        colors: ['Đen', 'Trắng', 'Xanh'], specifications: null,
      ),
      quantity: 1,
      color: 'Đen',
    ),
    CartItem(
      product: Product(
        id: 'jbl-headset',
        name: 'JBL T450BT Extra Bass',
        image: 'assets/images/jbl.jpg',
        price: 890000,
        originalPrice: 1290000,
        rating: 4.6,
        reviews: 856,
        colors: ['Đen'], specifications: null,
      ),
      quantity: 2,
      color: 'Đen',
    ),
  ];

  // Format tiền tệ Việt Nam
  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  // Tính tổng giá trị đơn hàng
  int get _totalAmount {
    return _cartItems.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  // Tính tổng số lượng sản phẩm
  int get _totalItems {
    return _cartItems.fold(0, (total, item) => total + item.quantity);
  }

  // Thay đổi số lượng sản phẩm
  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      // Hiện dialog xác nhận xóa sản phẩm
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Xóa sản phẩm'),
          content: Text('Bạn có muốn xóa "${_cartItems[index].product.name}" khỏi giỏ hàng?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _cartItems.removeAt(index);
                });
              },
              child: const Text('Xóa'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _cartItems[index].quantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Giỏ hàng',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCartContent(),
      bottomNavigationBar: _cartItems.isEmpty
          ? null
          : _buildCheckoutBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          const Text(
            'Giỏ hàng của bạn còn trống',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Hãy thêm sản phẩm vào giỏ hàng',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tiếp tục mua sắm',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return ListView(
      children: [
        // Danh sách sản phẩm
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _cartItems.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = _cartItems[index];
            return Dismissible(
              key: Key(item.product.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  _cartItems.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.product.name} đã bị xóa khỏi giỏ hàng'),
                    action: SnackBarAction(
                      label: 'HOÀN TÁC',
                      onPressed: () {
                        setState(() {
                          _cartItems.insert(index, item);
                        });
                      },
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Hình ảnh sản phẩm
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(item.product.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Thông tin sản phẩm
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Màu: ${item.color}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                _formatCurrency(item.product.price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (item.product.originalPrice != null && item.product.originalPrice! > item.product.price)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    _formatCurrency(item.product.originalPrice!),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Điều chỉnh số lượng
                    Row(
                      children: [
                        _quantityButton(
                          icon: Icons.remove,
                          onPressed: () => _updateQuantity(index, item.quantity - 1),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _quantityButton(
                          icon: Icons.add,
                          onPressed: () => _updateQuantity(index, item.quantity + 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Phần khuyến mãi
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Khuyến mãi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.discount_outlined,
                      color: Colors.blue,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Áp dụng mã giảm giá',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Tiết kiệm hơn với mã khuyến mãi',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Phần tóm tắt đơn hàng
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tóm tắt đơn hàng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildOrderSummaryRow(
                      'Tạm tính (${_totalItems} sản phẩm)',
                      _formatCurrency(_totalAmount),
                    ),
                    const SizedBox(height: 8),
                    _buildOrderSummaryRow(
                      'Giảm giá',
                      '- ${_formatCurrency(0)}',
                      isDiscount: true,
                    ),
                    const SizedBox(height: 8),
                    _buildOrderSummaryRow(
                      'Phí vận chuyển',
                      _formatCurrency(0),
                      isFreeShipping: true,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(),
                    ),
                    _buildOrderSummaryRow(
                      'Tổng tiền',
                      _formatCurrency(_totalAmount),
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSummaryRow(String label, String value,
      {bool isDiscount = false, bool isFreeShipping = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.black : Colors.grey.shade700,
              ),
            ),
            if (isFreeShipping)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Miễn phí',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isDiscount ? Colors.green.shade700 : (isTotal ? Colors.black : Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tổng cộng:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _formatCurrency(_totalAmount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Xử lý khi nhấn thanh toán
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chức năng thanh toán đang được phát triển'),
                  ),
                );
              },
              child: const Text(
                'THANH TOÁN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantityButton({required IconData icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}

// Lớp đối tượng cho sản phẩm trong giỏ hàng
class CartItem {
  final Product product;
  int quantity;
  final String color;

  CartItem({
    required this.product,
    required this.quantity,
    required this.color,
  });
}