import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:halal_life/constants.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: mainAppBarPadding.copyWith(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: BoxDecoration(gradient: mainAppBarGradient),
      child: Row(
        children: [
          Container(
            padding: mainAppBarIconPadding,
            decoration: mainAppBarIconDecoration,
            child: Center(child: Text("H", style: mainAppBarIconStyle)),
          ),
          const Gap(16),
          Text("HALAL Life", style: mainAppBarTextStyle),
          Spacer(),
          Container(
            height: 36,
            width: 36,
            decoration: mainAppBarProfileContainerDecoration,
            child: IconButton(
              padding: mainAppBarProfileIconPadding,
              iconSize: mainAppBarProfileIconSize,
              color: mainAppBarProfileIconColor,
              onPressed: () {
                // TODO: Action
              },
              icon: const Icon(Icons.person),
            ),
          ),
        ],
      ),
    );
  }
}
