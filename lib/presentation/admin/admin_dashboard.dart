import 'package:flutter/material.dart';
import 'package:tech_mart/presentation/admin/user_management.dart';
import 'package:tech_mart/presentation/admin/product_management.dart';
import 'package:tech_mart/presentation/admin/order_management.dart';
import 'package:tech_mart/presentation/admin/discount_management.dart';
import 'package:tech_mart/presentation/admin/simple_dashboard.dart';
import 'package:tech_mart/presentation/admin/advanced_dashboard.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // TODO: Implement logout
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Overview Cards
              _buildOverviewCards(context),
              const SizedBox(height: 24),
              
              // Management Sections
              const Text(
                'Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildManagementGrid(context),
              
              const SizedBox(height: 24),
              
              // Dashboard Types
              const Text(
                'Dashboard Views',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDashboardTypes(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildOverviewCard(
          'Total Users',
          '1,234',
          Icons.people,
          const Color(0xFF4CAF50),
        ),
        _buildOverviewCard(
          'Total Orders',
          '567',
          Icons.shopping_cart,
          const Color(0xFF2196F3),
        ),
        _buildOverviewCard(
          'Total Products',
          '890',
          Icons.inventory,
          const Color(0xFFFF9800),
        ),
        _buildOverviewCard(
          'Total Revenue',
          '\$45,678',
          Icons.attach_money,
          const Color(0xFFE91E63),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildManagementCard(
          context,
          'User Management',
          Icons.people,
          const Color(0xFF4CAF50),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserManagement()),
          ),
        ),
        _buildManagementCard(
          context,
          'Product Management',
          Icons.inventory,
          const Color(0xFF2196F3),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProductManagement()),
          ),
        ),
        _buildManagementCard(
          context,
          'Order Management',
          Icons.shopping_cart,
          const Color(0xFFFF9800),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderManagement()),
          ),
        ),
        _buildManagementCard(
          context,
          'Discount Management',
          Icons.local_offer,
          const Color(0xFFE91E63),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DiscountManagement()),
          ),
        ),
      ],
    );
  }

  Widget _buildManagementCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardTypes(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildDashboardTypeCard(
            context,
            'Simple Dashboard',
            Icons.dashboard,
            const Color(0xFF4CAF50),
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SimpleDashboard()),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDashboardTypeCard(
            context,
            'Advanced Dashboard',
            Icons.analytics,
            const Color(0xFF2196F3),
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdvancedDashboard()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardTypeCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 