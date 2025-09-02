import 'package:flutter/material.dart';
import '../config/app_config.dart';

class DateRangeFilter extends StatelessWidget {
  final DateTimeRange? selectedRange;
  final Function(DateTimeRange?) onChanged;

  const DateRangeFilter({
    Key? key,
    this.selectedRange,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(AppConfig.cardColor),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        border: Border.all(
          color: Color(AppConfig.primaryColor).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Período de Análise',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  context,
                  selectedRange?.start,
                  'Data Inicial',
                  Icons.calendar_today,
                ),
              ),
              SizedBox(width: 12),
              Icon(
                Icons.arrow_forward,
                color: Color(AppConfig.primaryColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDateButton(
                  context,
                  selectedRange?.end,
                  'Data Final',
                  Icons.event,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(
    BuildContext context,
    DateTime? date,
    String label,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Color(AppConfig.primaryColor).withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Color(AppConfig.primaryColor),
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              date != null
                  ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                  : 'Selecionar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: selectedRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(AppConfig.primaryColor),
              surface: Color(AppConfig.cardColor),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}

