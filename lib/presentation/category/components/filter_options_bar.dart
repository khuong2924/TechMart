import 'package:flutter/material.dart';

class FilterOptionsBar extends StatelessWidget {
  final int filterCount;
  final VoidCallback? onComparePressed;
  final VoidCallback? onSortPressed;
  final VoidCallback? onFilterPressed;

  const FilterOptionsBar({
    Key? key,
    required this.filterCount,
    this.onComparePressed,
    this.onSortPressed,
    this.onFilterPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Compare button
          Expanded(
            child: InkWell(
              onTap: onComparePressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.compare, size: 20),
                    SizedBox(width: 8),
                    Text('Compare', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          // Vertical divider
          Container(
            height: 32,
            width: 1,
            color: Colors.grey.shade300,
          ),
          // Sort button
          Expanded(
            child: InkWell(
              onTap: onSortPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.sort, size: 20),
                    SizedBox(width: 8),
                    Text('Sort', style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          // Vertical divider
          Container(
            height: 32,
            width: 1,
            color: Colors.grey.shade300,
          ),
          // Filter button
          Expanded(
            child: InkWell(
              onTap: onFilterPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.filter_list, size: 20),
                    const SizedBox(width: 8),
                    Text('Filter', style: const TextStyle(fontWeight: FontWeight.w500)),
                    if (filterCount > 0)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          filterCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}