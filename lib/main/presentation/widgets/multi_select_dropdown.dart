import 'package:flutter/material.dart';
import 'package:flutter_popup/flutter_popup.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';

class MultiSelectDropdown extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectDropdown({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.onSelectionChanged,
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    final allItems = ["All", ...widget.items];

    return CustomPopup(
      content: StatefulBuilder(
        builder: (context, setInnerState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(allItems.length, (index) {
              final item = allItems[index];
              return CheckboxListTile(
                tileColor: Colors.transparent,
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return darkMint;
                  }
                  return Colors.white;
                }),
                side: BorderSide(
                  color: _selectedItems.contains(item)
                      ? Colors.transparent
                      : darkMint,
                  width: 2,
                ),
                title: Text(
                  item,
                  style: TextStyle(
                    color: _selectedItems.contains(item)
                        ? darkMint
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: _selectedItems.contains(item),
                selected: _selectedItems.contains(item),
                onChanged: (isSelected) {
                  setState(() {
                    setInnerState(() {
                      if (item == "All" && isSelected == true) {
                        _selectedItems = ["All", ...widget.items];
                      } else if (item == "All" && isSelected == false) {
                        _selectedItems.clear();
                      } else {
                        if (isSelected == true) {
                          _selectedItems.add(item);

                          final allExceptAll = Set.from(widget.items);
                          final selectedExceptAll = Set.from(_selectedItems)
                            ..remove("All");

                          if (selectedExceptAll.length == allExceptAll.length) {
                            _selectedItems = ["All", ...widget.items];
                          }
                        } else {
                          _selectedItems.remove(item);
                          _selectedItems.remove("All");
                        }
                      }
                    });
                    widget.onSelectionChanged(_selectedItems);
                  });
                },
              );
            }),
          );
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          color: mint,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedItems.contains("All")
                  ? "All"
                  : "${_selectedItems.length} selected",
              style: TextStyle(color: Colors.white),
            ),
            Gap(4),
            Icon(Icons.filter_alt, size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
