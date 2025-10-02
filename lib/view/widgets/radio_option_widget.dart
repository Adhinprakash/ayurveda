  import 'dart:ui';

import 'package:flutter/material.dart';

Widget buildRadioOption(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Radio(
            value: selected,
            groupValue: true,
            onChanged: (_) => onTap(),
            activeColor: const Color(0xFF006837),
          ),
          Text(label),
        ],
      ),
    );
  }
