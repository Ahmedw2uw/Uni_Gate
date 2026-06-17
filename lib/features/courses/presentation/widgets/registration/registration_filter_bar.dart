import 'package:flutter/material.dart';
import 'package:nuigate/shared/widgets/custom_text.dart';

class RegistrationFilterBar extends StatelessWidget {
  final int? selectedYear;
  final int? selectedSemester;
  final ValueChanged<int?> onYearChanged;
  final ValueChanged<int?> onSemesterChanged;

  const RegistrationFilterBar({
    super.key,
    this.selectedYear,
    this.selectedSemester,
    required this.onYearChanged,
    required this.onSemesterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterDropdown<int?>(
              label: 'السنة الدراسية',
              value: selectedYear,
              items: const [
                DropdownMenuItem(value: null, child: Text('الكل')),
                DropdownMenuItem(value: 1, child: Text('الأولى')),
                DropdownMenuItem(value: 2, child: Text('الثانية')),
                DropdownMenuItem(value: 3, child: Text('الثالثة')),
                DropdownMenuItem(value: 4, child: Text('الرابعة')),
              ],
              onChanged: onYearChanged,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _FilterDropdown<int?>(
              label: 'الترم',
              value: selectedSemester,
              items: const [
                DropdownMenuItem(value: null, child: Text('الكل')),
                DropdownMenuItem(value: 1, child: Text('الأول')),
                DropdownMenuItem(value: 2, child: Text('الثاني')),
              ],
              onChanged: onSemesterChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, fontSize: 11, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              value: value,
              items: items,
              onChanged: onChanged,
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
