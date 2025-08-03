import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';
import 'package:halal_life/main/presentation/models/language.dart';

class LanguageDropdown extends StatelessWidget {
  final List<Language> languages;
  final String selectedCode;
  final void Function(String?) onChanged;

  const LanguageDropdown({
    super.key,
    required this.languages,
    required this.selectedCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50), // butonun altına açılması için
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder:
          (context) =>
              languages.map((lang) {
                return PopupMenuItem<String>(
                  value: lang.code,
                  child: Text("${lang.flag} ${lang.name}"),
                );
              }).toList(),
      onSelected: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${languages.firstWhere((l) => l.code == selectedCode).flag} ${languages.firstWhere((l) => l.code == selectedCode).code.toUpperCase()}",
              style: TextStyle(
                fontSize: 16,
                color: mint,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(2),
            Icon(Icons.keyboard_arrow_down_rounded, color: mint),
          ],
        ),
      ),
    );
  }
}
