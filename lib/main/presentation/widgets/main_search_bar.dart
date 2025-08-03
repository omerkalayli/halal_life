import 'package:flutter/material.dart';
import 'package:halal_life/constants.dart';

class MainSearchBar extends StatelessWidget {
  const MainSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              hintText: "Şehir, bölge veya işletme ara...",
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              isDense: true,
              filled: true,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: lightMint, width: 2),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: mint, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: mint, width: 2),
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 4),
                child: Icon(Icons.search, color: mint, size: 24),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
