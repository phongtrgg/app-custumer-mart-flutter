import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stackfood_multivendor/util/dimensions.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function? onTap;
  final String? title;
  final bool isSelected;

  const BottomNavItem({super.key, required this.iconData, this.onTap, this.isSelected = false, this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          IconButton(
            iconSize: 18,
            icon: Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, size: 30),
            onPressed: onTap as void Function()?,
          ),
          title != null
              ? Text(
                  title!.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
