import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final String labelText;
  final String hintText;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final IconData icon;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.labelText,
    required this.hintText,
    required this.onTap,
    this.onClear,
    this.icon = Icons.calendar_month,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
          enabledBorder: _getBorder(),
          focusedBorder: _getBorder(color: Theme.of(context).primaryColor),
          errorBorder: _getBorder(color: Colors.red),
          focusedErrorBorder: _getBorder(color: Colors.red),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedDate != null
                    ? '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}'
                    : hintText,
                style: TextStyle(
                  fontSize: 16,
                  color: selectedDate != null ? Colors.black : Colors.grey[600],
                ),
              ),
            ),
            if (selectedDate != null && onClear != null)
              InkWell(
                onTap: onClear,
                child: const Icon(Icons.clear, color: Colors.red),
              )
            else
              const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  InputBorder _getBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color ?? Colors.grey),
    );
  }
}
