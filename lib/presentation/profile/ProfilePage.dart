import 'package:flutter/material.dart';
import 'package:tech_mart/data/repositories/user_repository.dart';
import 'package:tech_mart/models/user_profile.dart';
import 'package:tech_mart/core/network/api_client.dart';
import 'package:tech_mart/presentation/order/OrderListPage.dart';
import 'package:tech_mart/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository _userRepository = UserRepository(ApiClient());
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _selectedGender = 'MALE';

  @override
  void initState() {
    super.initState();
    _loadProfile();
    // Load orders to update stats
    Provider.of<OrderProvider>(context, listen: false).loadOrders();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await _userRepository.getProfile();
      setState(() {
        _profile = profile;
        _fullNameController = TextEditingController(text: profile.fullName);
        _phoneController = TextEditingController(text: profile.phone);
        _addressController = TextEditingController(text: profile.address);
        _selectedGender = profile.gender;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProfile = await _userRepository.updateProfile({
        'fullName': _fullNameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'gender': _selectedGender,
      });

      setState(() {
        _profile = updatedProfile;
        _isEditing = false;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate to HomePage and remove all previous routes
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isMediumScreen = size.width >= 600 && size.width < 1200;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: const Center(
          child: Text('Failed to load profile'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0.5,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.save : Icons.edit,
              size: isSmallScreen ? 20 : 24,
            ),
            onPressed: _isEditing ? _updateProfile : () => setState(() => _isEditing = true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: isSmallScreen ? 50 : 60,
                      backgroundImage: const NetworkImage('https://avatar.iran.liara.run/public/12'),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Text(
                      _profile!.username,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _profile!.email,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 24 : 32),
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderListPage(),
                          ),
                        );
                      },
                      child: _buildStatCard(
                        'Orders',
                        Provider.of<OrderProvider>(context).totalElements.toString(),
                        Icons.shopping_bag_outlined,
                        isSmallScreen,
                      ),
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Expanded(
                    child: _buildStatCard(
                      'Total Spent',
                      _formatCurrency(Provider.of<OrderProvider>(context).totalSpent),
                      Icons.payments_outlined,
                      isSmallScreen,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Cart Items',
                      _profile!.cartItems.toString(),
                      Icons.shopping_cart_outlined,
                      isSmallScreen,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Expanded(
                    child: _buildStatCard(
                      'Wishlist',
                      _profile!.wishlistItems.toString(),
                      Icons.favorite_border,
                      isSmallScreen,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 24 : 32),
              // Profile Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      'Full Name',
                      _fullNameController,
                      isSmallScreen,
                      enabled: _isEditing,
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    _buildFormField(
                      'Phone',
                      _phoneController,
                      isSmallScreen,
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    _buildFormField(
                      'Address',
                      _addressController,
                      isSmallScreen,
                      enabled: _isEditing,
                      maxLines: 2,
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 20),
                    Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    if (_isEditing)
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Male'),
                              value: 'MALE',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                              activeColor: Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Female'),
                              value: 'FEMALE',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                              activeColor: Colors.orange,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        _profile!.gender == 'MALE' ? 'Male' : 'Female',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 24 : 32),
              // Account Info
              Text(
                'Account Information',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              _buildInfoRow('Member Since', DateFormat('dd/MM/yyyy').format(_profile!.createdAt), isSmallScreen),
              SizedBox(height: isSmallScreen ? 8 : 12),
              _buildInfoRow('Last Login', DateFormat('dd/MM/yyyy HH:mm').format(_profile!.lastLogin), isSmallScreen),
              SizedBox(height: isSmallScreen ? 8 : 12),
              _buildInfoRow('Status', _profile!.enabled ? 'Active' : 'Inactive', isSmallScreen),
              SizedBox(height: isSmallScreen ? 24 : 32),
              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showChangePasswordDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                    ),
                  ),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm new password';
                  }
                  if (value != newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await _userRepository.changePassword(
                    currentPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password changed successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error changing password: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text(
              'Change Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.orange,
            size: isSmallScreen ? 24 : 28,
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 6),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    bool isSmallScreen, {
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.grey.shade400,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 16 : 18,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade900,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 20,
              vertical: isSmallScreen ? 12 : 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.grey.shade400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
} 