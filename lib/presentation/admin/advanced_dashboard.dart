import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdvancedDashboard extends StatefulWidget {
  const AdvancedDashboard({Key? key}) : super(key: key);

  @override
  _AdvancedDashboardState createState() => _AdvancedDashboardState();
}

class _AdvancedDashboardState extends State<AdvancedDashboard> {
  bool isLoading = false;
  String selectedTimeRange = 'Last 7 Days';

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
    // Dữ liệu mẫu phù hợp hệ thống công nghệ
    final categories = [
      {
        'name': 'Laptop',
        'color': const Color(0xFF4CAF50),
        'icon': Icons.laptop_mac,
        'count': 150,
      },
      {
        'name': 'Điện thoại',
        'color': const Color(0xFF2196F3),
        'icon': Icons.smartphone,
        'count': 120,
      },
      {
        'name': 'Tablet',
        'color': const Color(0xFFFF9800),
        'icon': Icons.tablet_mac,
        'count': 90,
      },
      {
        'name': 'Đồng hồ',
        'color': const Color(0xFFE91E63),
        'icon': Icons.watch,
        'count': 70,
      },
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
              ? _buildCategoryBarChart(categories)
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
                            sections: categories.map((cat) {
                              final count = cat['count'] as int;
                              final total = categories.fold<int>(0, (a, b) => a + (b['count'] as int));
                              return PieChartSectionData(
                                color: cat['color'] as Color,
                                value: count.toDouble(),
                                title: '${(count * 100 ~/ total)}%',
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
                        child: _buildCategoryLegend(categories, isWide: true),
                      ),
                    ],
                  ),
                ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            _buildCategoryLegend(categories, isWide: false),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryLegend(List categories, {required bool isWide}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map<Widget>((cat) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: cat['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 18),
              const SizedBox(width: 8),
              Text(
                cat['name'] as String,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                '${cat['count']} sản phẩm',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryBarChart(List categories) {
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: categories.map((c) => c['count'] as int).reduce((a, b) => a > b ? a : b).toDouble() + 10,
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
                    child: Icon(categories[idx]['icon'] as IconData, color: categories[idx]['color'] as Color, size: 18),
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
                    toY: (categories[i]['count'] as int).toDouble(),
                    color: categories[i]['color'] as Color,
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