import 'package:flutter/material.dart';

class SuggestionContainer extends StatelessWidget {
  const SuggestionContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xffE6E8E1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: child,
    );
  }
}
