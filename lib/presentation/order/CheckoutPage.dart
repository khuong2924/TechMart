import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_mart/providers/cart_provider.dart';
import 'package:tech_mart/providers/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:tech_mart/presentation/home/HomePage.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedPaymentMethod = 'COD';
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      await orderProvider.createOrder(
        shippingAddress: _addressController.text,
        paymentMethod: _selectedPaymentMethod,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      if (mounted) {
        // Clear cart after successful order
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.clearCart();

        // Show success message and navigate to HomePage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt hàng thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF181A20),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          final cart = cartProvider.cart;
          if (cart == null || cart.items.isEmpty) {
            return const Center(
              child: Text('Giỏ hàng trống', style: TextStyle(fontSize: 18, color: Colors.white70)),
            );
          }

          Widget leftColumn = Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Address
                const Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Nhập địa chỉ giao hàng',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF23242A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  maxLines: 3,
                  validator: (value) => (value == null || value.isEmpty) ? 'Vui lòng nhập địa chỉ giao hàng' : null,
                ),
                const SizedBox(height: 28),

                // Payment Method
                const Text('Phương thức thanh toán', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                Card(
                  color: const Color(0xFF23242A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Thanh toán khi nhận hàng (COD)', style: TextStyle(color: Colors.white)),
                        value: 'COD',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                      ),
                      RadioListTile<String>(
                        title: const Text('Chuyển khoản ngân hàng', style: TextStyle(color: Colors.white)),
                        value: 'BANK_TRANSFER',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Notes
                const Text('Ghi chú', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Nhập ghi chú (không bắt buộc)',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: const Color(0xFF23242A),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          );

          Widget rightColumn = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Tóm tắt đơn hàng', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              Card(
                color: const Color(0xFF23242A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tạm tính:', style: TextStyle(color: Colors.white70)),
                          Text(_formatCurrency(cart.subtotal.toInt()), style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                      if (cart.discount > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Giảm giá:', style: TextStyle(color: Colors.amber)),
                            Text('-${_formatCurrency(cart.discount.toInt())}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng cộng:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.amber)),
                          Text(_formatCurrency(cart.total.toInt()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.amber)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                        )
                      : const Text('Đặt hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );

          if (isWideScreen) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: leftColumn),
                  const SizedBox(width: 48),
                  Expanded(flex: 4, child: rightColumn),
                ],
              ),
            );
          }

          // Mobile layout
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftColumn,
                const SizedBox(height: 32),
                rightColumn,
              ],
            ),
          );
        },
      ),
    );
  }
} 