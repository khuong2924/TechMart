import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Category {
  final int id;
  final String name;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class AdvancedDashboard extends StatefulWidget {
  const AdvancedDashboard({Key? key}) : super(key: key);

  @override
  _AdvancedDashboardState createState() => _AdvancedDashboardState();
}

class _AdvancedDashboardState extends State<AdvancedDashboard> {
  bool isLoading = false;
  String selectedTimeRange = 'Last 7 Days';
  List<Category> categories = [];
  bool isCategoriesLoading = false;

  final List<String> timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last Year',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      isCategoriesLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data.map((json) => Category.fromJson(json)).toList();
        });
      } else {
        // Handle error
        print('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading categories: $e');
    } finally {
      setState(() {
        isCategoriesLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });
    // TODO: Implement data loading from API
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          'Advanced Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          DropdownButton<String>(
            value: selectedTimeRange,
            dropdownColor: const Color(0xFF2D2D2D),
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: timeRanges.map((range) {
              return DropdownMenuItem(
                value: range,
                child: Text(range),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedTimeRange = value;
                });
                _loadData();
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPerformanceMetrics(),
                  const SizedBox(height: 24),
                  _buildRevenueChart(),
                  const SizedBox(height: 24),
                  _buildTopProductsAndCategories(),
                  const SizedBox(height: 24),
                  _buildCustomerAnalytics(),
                ],
              ),
            ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final metrics = [
      _buildMetricCard(
        'Total Revenue',
        '\$45,678',
        '+12.5%',
        Icons.attach_money,
        const Color(0xFF4CAF50),
      ),
      _buildMetricCard(
        'Total Orders',
        '567',
        '+8.2%',
        Icons.shopping_cart,
        const Color(0xFF2196F3),
      ),
      _buildMetricCard(
        'Average Order Value',
        '\$80.56',
        '+5.3%',
        Icons.trending_up,
        const Color(0xFFFF9800),
      ),
      _buildMetricCard(
        'Conversion Rate',
        '3.2%',
        '+1.8%',
        Icons.people,
        const Color(0xFFE91E63),
      ),
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: metrics.map((card) => SizedBox(
        width: 170, // Adjust width for mobile
        child: card,
      )).toList(),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    final isPositive = change.startsWith('+');
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
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

  Widget _buildRevenueChart() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Mon';
                            break;
                          case 1:
                            text = 'Tue';
                            break;
                          case 2:
                            text = 'Wed';
                            break;
                          case 3:
                            text = 'Thu';
                            break;
                          case 4:
                            text = 'Fri';
                            break;
                          case 5:
                            text = 'Sat';
                            break;
                          case 6:
                            text = 'Sun';
                            break;
                          default:
                            text = '';
                        }
                        return Text(text, style: style);
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        );
                        return Text(
                          '\$${value.toInt()}k',
                          style: style,
                        );
                      },
                      reservedSize: 42,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: [
                  _generateBarGroup(0, 8),
                  _generateBarGroup(1, 12),
                  _generateBarGroup(2, 6),
                  _generateBarGroup(3, 15),
                  _generateBarGroup(4, 10),
                  _generateBarGroup(5, 18),
                  _generateBarGroup(6, 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _generateBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: Theme.of(context).primaryColor,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductsAndCategories() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        if (isWide) {
          // Tablet/Desktop: song song
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTopProducts(isWide: true)),
              const SizedBox(width: 16),
              Expanded(child: _buildTopCategories(isWide: true)),
            ],
          );
        } else {
          // Mobile: xếp dọc
          return Column(
            children: [
              _buildTopProducts(isWide: false),
              const SizedBox(height: 16),
              _buildTopCategories(isWide: false),
            ],
          );
        }
      },
    );
  }

  Widget _buildTopProducts({required bool isWide}) {
    // Dữ liệu mẫu phù hợp hệ thống công nghệ
    final topProducts = [
      {
        'name': 'MacBook Pro 16"',
        'price': 59990000,
        'sales': 150,
      },
      {
        'name': 'iPhone 15 Pro Max',
        'price': 34990000,
        'sales': 120,
      },
      {
        'name': 'iPad Pro 12.9"',
        'price': 28990000,
        'sales': 90,
      },
      {
        'name': 'Apple Watch Ultra 2',
        'price': 19990000,
        'sales': 70,
      },
      {
        'name': 'AirPods Pro 2',
        'price': 4990000,
        'sales': 60,
      },
    ];
    final medalColors = [Colors.amber, Colors.grey, Color(0xFFCD7F32), Colors.blueGrey, Colors.blueGrey];
    final borderColors = [Colors.amber, Colors.grey, Color(0xFFCD7F32), Colors.grey[700]!, Colors.grey[700]!];

    String formatCurrency(int price) {
      return price.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => '.',
      ) + ' ₫';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            itemCount: topProducts.length,
            itemBuilder: (context, index) {
              final product = topProducts[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColors[index], width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: borderColors[index].withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: medalColors[index],
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    product['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    formatCurrency(product['price'] as int),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, color: Colors.greenAccent, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${product['sales']} sales',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategories({required bool isWide}) {
    if (isCategoriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final categoryColors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
    ];

    final categoryIcons = [
      Icons.smartphone,
      Icons.laptop_mac,
      Icons.headphones,
      Icons.watch,
    ];

    final isMobile = !isWide;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          isMobile
              ? _buildCategoryBarChart(categories, categoryColors, categoryIcons)
              : SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: categories.asMap().entries.map((entry) {
                              final index = entry.key;
                              final category = entry.value;
                              return PieChartSectionData(
                                color: categoryColors[index % categoryColors.length],
                                value: 1, // Equal distribution for now
                                title: '${(100 ~/ categories.length)}%',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: _buildCategoryLegend(categories, categoryColors, categoryIcons, isWide: true),
                      ),
                    ],
                  ),
                ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            _buildCategoryLegend(categories, categoryColors, categoryIcons, isWide: false),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryLegend(List<Category> categories, List<Color> colors, List<IconData> icons, {required bool isWide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.asMap().entries.map<Widget>((entry) {
        final index = entry.key;
        final category = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icons[index % icons.length], color: colors[index % colors.length], size: 18),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryBarChart(List<Category> categories, List<Color> colors, List<IconData> icons) {
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final idx = value.toInt();
                  if (idx < 0 || idx >= categories.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(icons[idx % icons.length], color: colors[idx % colors.length], size: 18),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                },
                reservedSize: 28,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            for (int i = 0; i < categories.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: 100 / categories.length, // Equal distribution for now
                    color: colors[i % colors.length],
                    width: 24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerAnalytics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Analytics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCustomerMetric(
                  'New Customers',
                  '123',
                  '+15%',
                  Icons.person_add,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCustomerMetric(
                  'Returning Customers',
                  '456',
                  '+8%',
                  Icons.people,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCustomerMetric(
                  'Average Order Value',
                  '\$80.56',
                  '+5%',
                  Icons.attach_money,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCustomerMetric(
                  'Customer Satisfaction',
                  '4.5/5',
                  '+2%',
                  Icons.star,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerMetric(
    String title,
    String value,
    String change,
    IconData icon,
  ) {
    final isPositive = change.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.grey[400], size: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
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
    );
  }
} 