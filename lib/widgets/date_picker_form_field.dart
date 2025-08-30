import 'package:flutter/material.dart';

class DatePickerFormField extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? iconColor;

  const DatePickerFormField({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.textStyle,
    this.hintStyle,
    this.iconColor,
  });

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialDate != null
          ? "${widget.initialDate!.day}/${widget.initialDate!.month}/${widget.initialDate!.year}"
          : "",
    );
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      style: widget.textStyle,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "Pilih tanggal lahir",
        hintStyle: widget.hintStyle,
        suffixIcon: Icon(Icons.calendar_today, color: widget.iconColor ?? Colors.green.shade700),
      ),
      onTap: _pickDate,
    );
  }
}